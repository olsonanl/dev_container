# Job Outcome Model — Design Document

**Status:** Draft for review
**Date:** 2026-07-14
**Component:** `app_service` (scheduler + AppScript framework), with consumers in
`p3_cli`, the BV-BRC website, and per-application App-XX scripts.
**Driver / first adopter:** lowvan viral annotation (`bvbrc_lowvan`).

---

## 1. Motivation

When a user submits a job (via CLI or website) the parameters are bundled to the
app service and eventually executed by the scheduler. Today a job ends in one of
three ways, but the system can only represent two of them, and it conflates the
axes of *"did the process survive"* and *"did the job achieve the user's intent."*
The three real endings are:

1. **Success (type 1)** — the App-XX script did what the user intended, wrote its
   output to the chosen folder, and (for most apps) a user-facing report. The
   script exits 0.

2. **Diagnosable non-completion (type 2)** — the job did **not** achieve the
   user's intent, but this is **not a system failure**; it derives from the data
   or input, and the application is capable of explaining why. Two flavors:
   - `no_output` — the pipeline ran correctly but the result is legitimately
     empty/negative and attributable to the input (e.g. assembly produced no
     contigs from poor reads; a virus outside the supported reference set yields
     no annotation).
   - `input_error` — a precondition was not met; the run could not proceed. It is
     actionable by the user (e.g. a codon tree cannot be built because too few
     genes are shared across the input genomes; a required input field is
     missing).
   In the current system the App-XX script *may or may not* exit 0 in these
   cases — the behavior is inconsistent across applications — and intermediate
   data may or may not be written. A report is usually not written.

3. **Unexpected failure (type 3)** — the job crashed. It usually writes nothing
   useful and the App-XX script exits non-zero.

These ambiguities confuse users. The goals of this design are to:

- **Distinguish type-2 from type-3.**
- **Enable any application that can diagnose a type-2 condition to enlighten the
  user in a manner consistent across all applications.**
- **Augment the current success/failure reporting** (where "success" today means
  little more than "the process did not crash").

### Non-goals

- No general DAG / dependency engine for pipelines.
- No child-task (`parent_task`) rollup work (no application currently uses child
  tasks; see §12).
- No incremental/live mutation of the durable record in the database (see §8).

---

## 2. Current architecture (what we are changing)

The status of a job is decided at three independent layers today. Only two
terminal outcomes (completed / failed) survive to the durable record, and the
signal originates entirely from the App-XX exit code.

### 2.1 The application's own judgment — `AppScript::subproc_run`

`lib/Bio/KBase/AppService/AppScript.pm:516` wraps the app's `execute_callback`
(the App-XX logic) in an `eval`:

```perl
eval { $job_output = $self->execute_callback->(...) };   # :516-518
if ($@) {                                                # :520
    $failure_report = "Your job has failed with an exception:\n\n$@\n";
    $success = 0;
}
$self->write_results($job_output, $success, $failure_report);   # :531
return ($success ? 0 : 1);   # :534  -> becomes the process exit code
```

The App-XX callback has exactly **two verbs — `die` or `return`** — to express
**three outcomes**. This is the root cause. `success` is a boolean derived purely
from whether the callback threw.

### 2.2 The workspace artifact — `write_results`

`AppScript.pm:775` records the boolean in two places and writes an ad-hoc report:

- `success => 0|1` in the `job_result` JSON (`:799`) and in the output file's
  `task_data` metadata (`:805`).
- `JobFailed.txt` or `JobFailed.html` when a `$failure_report` exists (`:825-829`);
  the html-vs-txt choice is guessed with the regex `/<\S+>/`.

Workspace artifacts are **user-deletable**, so they cannot be the authoritative
long-term record.

### 2.3 The scheduler database — `TaskState`

`lib/Bio/KBase/AppService/Schema.sql:88-101`:

```sql
INSERT INTO TaskState VALUES
   ('Q','Queued','queued'), ('S','Submitted to cluster','pending'),
   ('C','Completed','completed'), ('F','Failed','failed'),
   ('D','Deleted','deleted'), ('T','Terminated','failed');
```

`SlurmCluster.pm:1092-1126` sets the terminal `state_code` **purely from the
slurm job state** (`$vals->{State}`), i.e. from the App-XX exit code — it never
sees the app's own judgment. The DB has **no representation of type-2 at any
layer**. This DB is the permanent history (users cannot delete it) and is what
`p3-qstat` / `enumerate_tasks_qstat` and the website job list read.

### 2.4 The out-of-band channel that already exists

The App posts "blocks" back to the service via `write_block($tag,$data)` →
`POST /task/file/<tag>` (`AppServiceImpl.pm:188`), which writes a file into the
task spool directory. Notable properties we will reuse:

- `POST /task/file/<tag>/data` **appends** (`AppServiceImpl.pm:219`, the `>>`
  path); `POST /task/file/<tag>` truncates (`:223-225`).
- Posting `exitcode` publishes a redis `task_completion` event that prods the
  scheduler (`AppServiceImpl.pm:250`).

This is the pipe we will carry the new outcome and stage events over.

---

## 3. Design overview

Introduce a first-class **outcome** that is distinct from the exit code / slurm
state, carried out-of-band into the scheduler DB (the source of truth), with a
**controlled vocabulary** so every application reports type-2 conditions the same
way. Support multi-step applications with a **two-level** structure: per-stage
outcomes plus a composite rollup, using the **same vocabulary** at both levels.

Two axes are deliberately decoupled:

| Axis | Carried by | Values |
|------|-----------|--------|
| **Infra health** | exit code → slurm state → `Task.state_code` (unchanged) | C / F / T / … |
| **Job outcome** | new `Task.outcome` (+ diagnosis columns), app-declared, out-of-band | succeeded / no_output / input_error / failed |

A type-2 job **exits 0** (the process was healthy → slurm `COMPLETED` →
`state_code = 'C'`); its `outcome` column is what separates it from a type-1. This
is why the exit code alone cannot carry three states and why `state_code` must not
be overloaded.

### 3.1 Outcome vocabulary

| `outcome` | Meaning | Exit / slurm |
|-----------|---------|--------------|
| `succeeded` | achieved the user's intent | 0 → C |
| `no_output` | ran correctly; result legitimately empty/negative, attributable to input | 0 → C |
| `input_error` | precondition not met; could not proceed; user-actionable | 0 → C |
| `failed` | unexpected/unhandled failure (type 3) | ≠0 → F, or uncaught `die` |

**Severity order (for composite rollup):** `failed > input_error > no_output >
succeeded`.

`diagnosis_category` is a finer, app-specific code under an outcome (e.g.
`unsupported_taxon`, `low_quality_assembly`, `empty_input`). It is free text in
the schema (a future refinement could validate it against a per-app registry at
`load-app-specs` time; not in scope now).

### 3.2 state_code × outcome decode

```
C + succeeded              -> type 1  (success)
C + no_output|input_error  -> type 2  (diagnosable; process healthy, exit 0)
F  (or C + failed)         -> type 3  (crash)
C + NULL (no outcome posted)-> legacy app -> render as success (back-compat)
```

---

## 4. Two-level structure for multi-step applications

Many applications are multi-step. Some are explicit pipelines (genome annotation
runs lowvan, and can continue with vigor4 or GenBank feature propagation if
lowvan does not apply); others are multi-step but not explicitly pipelined. A
single scalar outcome per job cannot express "lowvan produced nothing but the
job succeeded via a fallback," nor report per-stage status.

### 4.1 Stage record

A **stage** is a named, optional sub-unit of a task with its own outcome, using
the same vocabulary as the job. It is emitted whenever a meaningful sub-step
resolves — this requires no pipeline framework, so loosely-structured apps use
the same primitive as explicit pipelines. Approved JSON shape (one object per
stage, stored as an array in `stage_outcomes`):

```json
{
  "name":        "lowvan",
  "outcome":     "no_output",
  "category":    "unsupported_taxon",
  "summary":     "No reference contig matched; taxon outside supported families.",
  "remediation": "Use vigor4, or supply a genome within a supported family.",
  "criticality": "best_effort",
  "start":       "2026-07-14T15:02:11Z",
  "end":         "2026-07-14T15:04:52Z"
}
```

### 4.2 Criticality

Each stage carries a criticality that determines its effect on the composite:

| `criticality` | effect of a non-`succeeded` stage on the composite |
|---------------|----------------------------------------------------|
| `required` (default) | drags the composite down to the stage's outcome |
| `best_effort` | composite stays `succeeded`; recorded as a **note** |
| `optional` | note only, lower emphasis |

This single attribute expresses "continue the annotation despite a lowvan
failure" **declaratively** rather than burying the policy in imperative code:
genome annotation marks lowvan `best_effort`.

### 4.3 Composite rollup

The framework computes a **default composite** so unmigrated/partially-migrated
apps still get a sensible result:

- composite = **worst outcome among `required` stages**, by the severity order in
  §3.1;
- `best_effort` / `optional` non-success never lowers the composite — it becomes a
  note;
- the app may override the default with `declare_outcome(...)`.

The one relationship the mechanical default cannot infer is **alternatives**
(lowvan / vigor4 / GenBank propagation are a fallback group where *any one*
succeeding is success — not three independent required stages). For now this is
handled imperatively: mark the members `best_effort` and have the app assert the
final `declare_outcome`. A declarative "stage group with `any_success` policy" is
a possible future refinement (§12) but is not built now.

---

## 5. Data model

Additive columns only. `state_code` and `TaskState` are **unchanged**, so no
existing consumer of `service_status` breaks.

```sql
ALTER TABLE Task
  ADD COLUMN outcome            VARCHAR(20)  DEFAULT NULL,  -- succeeded|no_output|input_error|failed
  ADD COLUMN diagnosis_category VARCHAR(64)  DEFAULT NULL,  -- app-specific finer code
  ADD COLUMN diagnosis_summary  TEXT         DEFAULT NULL,  -- human-readable composite summary
  ADD COLUMN stage_outcomes     JSON         DEFAULT NULL;  -- array of stage records (§4.1)

ALTER TABLE ArchivedTask
  ADD COLUMN outcome            VARCHAR(20)  DEFAULT NULL,
  ADD COLUMN diagnosis_category VARCHAR(64)  DEFAULT NULL,
  ADD COLUMN diagnosis_summary  TEXT         DEFAULT NULL,
  ADD COLUMN stage_outcomes     JSON         DEFAULT NULL;
```

Rationale:

- **Composite in scalar columns** — cheap to index and select for the job list
  and dashboards; `outcome` (and optionally `diagnosis_category`) are the natural
  index candidates. `diagnosis_summary` is `TEXT` (read on job-detail open, not
  on the hot path).
- **Per-stage in a JSON column on the same row** — it archives for free through
  the existing `Task` → `ArchivedTask` partition/archive machinery (the archive
  process copies the row; no second partitioned child table to co-migrate).
  Per-stage aggregation ("how often does lowvan hit `unsupported_taxon`?") uses
  JSON functions off the hot path. A relational `TaskStage` child table would
  give cleaner `GROUP BY`s but must co-partition with the partitioned tables — a
  cost we take only if stage-level dashboards become a first-class need.
- `outcome NULL` = legacy job → rendered as success from the exit code.

---

## 6. Transport vs. durable tiers

These are two distinct tiers; only the transport tier appends.

### 6.1 Transport tier (append, live, no DB traffic)

The app **streams** stage events by appending newline-delimited JSON to a
`stages` spool block during the run:

```
POST /task/file/stages/data     (one JSON object per record_stage, '\n'-terminated)
```

This uses the existing append path (`AppServiceImpl.pm:219`) and behaves exactly
like `exitcode`/`job_result_id` today — no database writes while the job runs. If
a live "stage 3/5 running" view is ever wanted on the website, a monitor can tail
this spool file; that is optional and additive.

The app also posts a final composite block:

```
POST /task/file/outcome    { "outcome": ..., "category": ..., "summary": ..., "remediation": ... }
```

### 6.2 Durable tier (DB, written exactly once)

The database `stage_outcomes` JSON column and the scalar outcome columns are
written **once, at terminal transition** — never mutated incrementally. This
keeps the DB as the durable end-state truth, avoids per-stage UPDATE churn, JSON
rewrite storms, and concurrency/ordering concerns.

---

## 7. Completion-handler ingest (both terminal paths)

The single DB write is tied to **terminal-state detection, whichever path
fires**, so a crash still persists the stage history the app managed to spool:

1. **Clean path** — the app posts `exitcode`, which publishes redis
   `task_completion` (`AppServiceImpl.pm:250`); the scheduler reconciles.
2. **Crash path** — `SlurmCluster.pm:1113` sets the terminal `state_code` from an
   `sacct`-detected `FAILED`/`TIMEOUT`/`CANCELLED`/OOM state, possibly without any
   final post from the (dead) app.

At the point of terminal transition the handler:

1. reads the `stages` spool file, parsing NDJSON and **discarding a truncated
   final line** (crash-safe);
2. reads the `outcome` spool block if present;
3. determines the composite: the app's `declare_outcome` value if posted, else
   the framework rollup over the parsed stages (§4.3); if neither exists and
   slurm reports a crash, the composite is `failed`;
4. writes `outcome`, `diagnosis_category`, `diagnosis_summary`, and
   `stage_outcomes` in **one** `UPDATE` alongside the terminal `state_code`
   update.

Result: type-3 crashes still capture partial `stage_outcomes` up to the death
point (e.g. `✓ assembly, ✓ lowvan, ✗ died in stage 3`).

---

## 8. AppScript / AppDiagnosis API

### 8.1 `Bio::KBase::AppService::AppDiagnosis` (new)

A small exception class the app throws to abort with a diagnosis:

- fields: `outcome` (`no_output` | `input_error`), `category`, `summary`,
  `remediation`;
- `isa`-checkable so `subproc_run` can distinguish it from an ordinary `die`;
- stringifies to `summary` so an uncaught instance still logs sensibly.

### 8.2 `subproc_run` (`AppScript.pm:516`) — the disambiguation

```perl
eval { $job_output = $self->execute_callback->(...) };
my ($outcome, $diag);
if (my $err = $@) {
    if (ref($err) && $err->isa('Bio::KBase::AppService::AppDiagnosis')) {
        $outcome = $err->outcome;             # type-2: healthy process
        $diag    = $err;
    } else {
        $outcome = 'failed';                  # type-3: unexpected
        $diag    = _wrap_exception($err);     # summary = $err text
    }
}
$outcome //= $self->declared_outcome         # explicit app override, if any
          // $self->rollup_outcome           # framework default over recorded stages
          // 'succeeded';

$self->write_results($job_output, $outcome, $diag);   # workspace detail
$self->write_block("outcome",
    $self->json->encode({ outcome => $outcome, ($diag ? %$diag : ()) }));

return ($outcome eq 'failed' ? 1 : 0);        # type-2 exits 0 -> slurm COMPLETED
```

### 8.3 `record_stage`

```perl
sub record_stage {
    my ($self, %s) = @_;   # name, outcome, category, summary, remediation, criticality
    $s{criticality} //= 'required';
    $s{start} //= $self->{_stage_start};      # framework may stamp start/end
    $s{end}   //= _now_iso8601();
    push @{$self->{stages}}, \%s;
    $self->write_block("stages/data", $self->json->encode(\%s) . "\n");  # NDJSON append
}
```

A stage that fails internally is caught by the app's stage-runner and recorded
via `record_stage` **without aborting the job** — this is the mechanism behind
"continue after a best-effort stage fails."

### 8.4 `declare_outcome` / `rollup_outcome`

- `declare_outcome($outcome, %diag)` — sets an explicit composite override.
- `rollup_outcome` — worst of `required` stages by severity; `best_effort` /
  `optional` non-success recorded as notes only.

### 8.5 `write_results` (`AppScript.pm:775`) changes

- signature becomes `($job_output, $outcome, $diag)`; derive `success = ($outcome
  eq 'succeeded' ? 1 : 0)` and keep writing the existing `success` field in
  `job_result`/`task_data` for **backward compatibility**;
- add `outcome`, `diagnosis`, and `stage_outcomes` to the `job_result` object and
  the `task_data` metadata;
- replace the ad-hoc `JobFailed.$type` (`:825-829`) with a structured
  `JobDiagnosis.json` (plus an optional rendered `JobDiagnosis.html`), eliminating
  the `/<\S+>/` html/text guess. `JobFailed.*` may continue to be written for one
  release cycle for compatibility with existing UI code.

---

## 9. Workspace artifacts

The workspace holds the **extended** detail; the DB holds the authoritative,
non-deletable summary.

- `JobDiagnosis.json` — the composite diagnosis + the full stage array (the same
  data as the DB columns, plus any longer text the app wants to include).
- Optional `JobDiagnosis.html` — rendered report banner.
- Existing per-app rich reports are unchanged; the diagnosis is a small,
  consistent header/banner, not a replacement for an app's own report.

---

## 10. Consumers

- **`SchedulerDB.pm`** — enumerate / qstat queries select the new columns
  (natural extension of `enumerate_tasks_qstat`, added July 2026). Elapsed/time
  handling is unchanged.
- **`p3-qstat` (`p3_cli/scripts/p3-qstat.pl`)** — render:
  - `succeeded` → `Completed`
  - `succeeded` with any non-success `best_effort`/`optional` stage →
    **`Completed (notes)`**
  - `no_output` → `Completed (no output: <category>)`
  - `input_error` → `Input error: <category>`
  - `failed` → `Failed`
- **Website** — job list keys off `outcome` (and the "notes" flag); job detail
  renders the stage timeline (`✓ assembly · ⚠ lowvan (skipped: unsupported_taxon)
  · ✓ vigor4`) and `JobDiagnosis.json`.

---

## 11. Backward compatibility & migration

- **Free back-compat:** an app that posts no `outcome` block yields `outcome
  NULL`, which renders exactly as today (success derived from the exit code).
  Nothing breaks; migration is opt-in per app.
- **Low-friction adoption:** an author adds one `die AppDiagnosis->new(...)` at
  each known error mode, and `record_stage(...)` at each sub-step. No framework
  scaffolding required.
- **Optional backstop (future):** an app-spec may declare its expected primary
  outputs; the framework can downgrade a claimed `succeeded` to
  `no_output` when none appear — catching sloppy type-2s that just `return`,
  without per-app work. Not in the initial scope.

---

## 12. Deferred / future work

- **Child-task rollup** — `Task.parent_task` exists (`Schema.sql:159,184`) and a
  child task would receive the `outcome` column for free, so a parent could roll
  up over children with the same policy. No application currently uses child
  tasks, so this is a **noop for now**.
- **Declarative stage-groups** (`any_success`) — captures alternative/fallback
  groups without imperative `declare_outcome`. Add only if the pattern recurs.
- **Live DB stage status** — flipping the durable tier to incremental updates
  would make per-stage progress queryable from the DB during the run. Additive;
  deferred (the transport spool already supports a live view).
- **Registered `diagnosis_category` vocabulary** — validate categories against a
  per-app registry at `load-app-specs` time for clean cross-app dashboards.

---

## 13. Worked example — lowvan viral annotation

lowvan is the driver because it exhibits all three outcome types today and
mishandles the boundaries. It is a 4-stage shell pipeline in
`bvbrc_lowvan/service-scripts/p3x-annotate-lowvan.pl`, which collapses **every**
failure to `exit 1` (`:119-127`). The diagnosable modes live in the four
component scripts in `bvbrc_lowvan/Viral_Annotation/`.

### 13.1 Current defects

- **The most common type-2 is silent, then surfaces as a misleading type-3.**
  When no reference contig matches (a virus outside the supported families —
  Bunyavirales, Coronaviridae, Filoviridae, Orthomyxoviridae, Paramyxoviridae,
  Pneumoviridae — or contigs too diverged), stage 1
  (`annotate_by_viral_pssm-GTO.pl:97-101`) *swallows the failure* (`warn` +
  continue), writes an empty GTO, and exits 0. Stage 2 then hits `$fam or die
  "GTO has no viral_family field (not annotated by LowVan?)"`
  (`get_splice_variant_features.pl:88`) → pipeline `exit 1` → task **Failed**. The
  single most actionable message ("we don't support this virus") reaches the user
  as a generic crash.
- **Real tool crashes are swallowed** at the same `!$ok` site — a genuine BLAST
  failure can also slip through as an empty result.
- **A ready-made diagnosis is discarded:** stage 4 (`viral_genome_quality.pl`)
  already computes a structured `genome_quality` (`Good`/`Poor`) plus
  `genome_quality_flags` (e.g. "Too many contigs for $seg", "Contig is missing:
  $seg", "Contig has too many ambiguous bases", "Genome has too few HSPs for
  $anno") and writes them into the GTO — then exits 0, so the job outcome never
  sees them.

### 13.2 Mapping to the model

| Condition (where) | Today | `outcome` | `diagnosis_category` | criticality |
|---|---|---|---|---|
| No reference/PSSM match; unsupported family (stage 1, silent → stage 2 die) | Failed | `no_output` | `unsupported_taxon` | best_effort |
| `genome_quality="Poor"` + flags (stage 4, exits 0) | Completed | `no_output` | `low_quality_assembly` | best_effort |
| `No sequences in the input GTO` (`...GTO.pl:73`) | Failed | `input_error` | `empty_input` | required |
| `No NCBI taxonomy ID` / `No genome name` (`:74-75`) | Failed | `input_error` | `missing_input_metadata` | required |
| `Error reading and parsing input` (unparseable GTO) | Failed | `input_error` | `malformed_input` | required |
| BLAST/tool non-zero rc; `Cannot open JSON BLASTn output` | Failed (or swallowed) | `failed` | (type-3) | — |
| `No splice variant features for $fam` (`get_splice_variant_features.pl:399`) | Completed | `succeeded` | *(informational note only)* | — |

The last row is the type-1/type-2 boundary: "no splice variants for this family"
is a **legitimate expected negative**, not a diagnosis — it stays `succeeded`.
The dividing line is "did the user get the result they came for."

### 13.3 Emission plan for lowvan

1. **Component scripts** get distinct exit codes (or a structured reason) for
   their diagnosable modes instead of bare `die`/silent-continue; fix the two
   swallowing bugs (propagate real tool failure; detect the empty-table/no-match
   case explicitly).
2. **The wrapper** maps stage exit code → `{outcome, category}`, and for the
   Good/Poor path reads `genome_quality`/`genome_quality_flags` from the output
   GTO.
3. **The App-XX callback** (which runs lowvan as one `best_effort` stage of the
   larger genome-annotation pipeline; its integration point is not in this tree)
   calls `record_stage` for lowvan and, on the fallback path, for vigor4 / GenBank
   propagation, then `declare_outcome` (or lets the rollup default apply).

---

## 14. Implementation checklist

1. **Schema** — `ALTER TABLE Task` / `ArchivedTask` (§5); confirm archive process
   copies the new columns.
2. **`AppDiagnosis.pm`** — new exception class (§8.1).
3. **`AppScript.pm`** — `subproc_run` branch (§8.2), `record_stage` (§8.3),
   `declare_outcome` / `rollup_outcome` (§8.4), `write_results` changes (§8.5).
4. **Spool** — confirm `stages/data` append and `outcome` block round-trip
   through `AppServiceImpl.pm` (existing paths; no change expected).
5. **Completion handler** — ingest on both terminal paths (§7), single `UPDATE`.
6. **`SchedulerDB.pm` / `p3-qstat`** — select and render the new columns (§10).
7. **Website** — outcome-aware job list + stage timeline + `JobDiagnosis.json`
   (separate track).
8. **lowvan** — first adopter (§13.3): fix swallowing bugs, add exit codes / stage
   records, wire quality flags.
9. **Docs** — update `app_service` module notes and CLAUDE.md.

---

## 15. Open questions

- Exact set of initial `diagnosis_category` values to bless as "standard" vs.
  leave app-specific.
- Whether `no_output` should count against an app's "failure rate" metrics
  (§3.1 treats it as non-failure).
- Whether `JobFailed.*` is retired immediately or kept one release for UI
  compatibility (§8.5).
