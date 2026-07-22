# PLAN — Declaring application outputs in `app_specs/*.json`

Status: **draft for review** · Author: (analysis 2026-07-22) · Companion data:
`PLAN-app-output-specs-estimate.md`

## 1. Problem

`app_specs/<App>.json` fully describe a job's **inputs** — every parameter has
`id`, `type`, `required`, `default`, enum values, `wstype`, group structure,
etc. They say **nothing about what the job produces**. There is no machine
-readable answer to "what files does GenomeAnnotation write, where, and of what
workspace type?"

Today the only source of truth for outputs is the imperative code in each
`service-scripts/App-<Name>.pl`, and it is scattered across three idioms:

1. **Explicit typed saves** — `->workspace->save_file_to_file($local, $meta,
   "$folder/$name", $type, ...)`, one call per file with a per-file `$type`
   (e.g. `genome_annotation/…App-GenomeAnnotation`).
2. **Suffix-regex tables** — an in-script `@output_suffixes = ([qr/\.afa$/,
   $type, …], …)` looped over the work dir (e.g. `p3_msa/…App-MSA.pl:693`).
3. **Recursive copies with a suffix map** — `p3-cp -r --map-suffix ext=type …
   ws:<result_folder>` (shared `save_output_files` helper style, e.g.
   `bvbrc_rnaseq`, `bvbrc_taxonomic_classification_2`). Anything whose suffix
   is not in the map is written **untyped** (`unspecified`).

The framework (`app_service/lib/Bio/KBase/AppService/AppScript.pm`) only:
- creates the result folder `.<output_file>/` (`create_result_folder`, :572),
  tagged with metadata `application_type = <app id>`;
- after `execute`, lists that folder recursively and records
  `output_files => [[path,id],…]` into the `job_result` object
  (`write_results`, :785). It never checks or assigns types.

### Consequences
- **No contract.** UI, downstream apps, docs, and QA cannot know expected
  outputs without reading Perl.
- **Type drift / untyped data.** In the 2026-07-22 QA harvest, **324 of 912**
  observed output files (35%) are `unspecified` (unmapped suffixes: `.zip`,
  `.tab`, `.fastq.gz`, `.npz`, `.krona`, `.ref`, `.vcf.gz`, `.pdf`, …). The
  viewer can't render what it can't type. Per §3.1, this tracks the *copy
  mechanism*, not the app.
- **No verification.** Nothing flags "GenomeAnnotation didn't emit
  `GenomeReport.html` this run".

## 2. Goal

Add an **`outputs` section** to each `app_specs/<App>.json`, parallel to
`parameters`, declaring the files/folders a successful run produces: logical
id, name/pattern, workspace type, location, cardinality, condition, and role.
Make it descriptive first (documentation + QA), enforceable later.

## 3. How outputs actually look (from the QA harvest)

Full per-app trees are in `PLAN-app-output-specs-estimate.md`. The 30 apps with
completed runs fall into a small **naming-pattern taxonomy** — this is what the
schema must express:

| Pattern | Meaning | Apps (examples) |
|---|---|---|
| **A. `{output_file}`-prefixed** | files named `<output_file><suffix>` | MSA, MetaCATS, CodonTree, GeneTree, SARS2Assembly, PrimerDesign, GenomeAnnotation(+Genbank) |
| **B. Fixed name** | constant filename regardless of input | ComparativeSystems (`report.txt`), GenomeAnnotation (`GenomeReport.html`, `load_files/*.json`), MetagenomeBinning (`BinningReport.html`), Homology (`blast_out.*`), DifferentialExpression (`expression.json`…), GenomeAlignment (`alignment.*`) |
| **C. Per-input-item** | one file/folder per sample/library/segment/contig/bin/ref | RNASeq (`<condition>/<sample>/…`), SARS2Wastewater (`<SRR>/…`), TaxonomicClassification (`<sample>/…`), Variation (`<lib>.*`), TnSeq (`<contig>.wig/.counts`), ViralAssembly (`<segment>.fasta`, `irma/…`), SubspeciesClassification (`details/<ref>.tre`) |
| **D. Nested tool dumps** | whole working subtree copied (mostly untyped) | RNASeq, SARS2Wastewater, ViralAssembly `irma/`, SequenceSubmission `SequenceValidation/`, quast/, fastqc_results/ |

### 3.1 Per-app type coverage + pattern (QA harvest 2026-07-22)

One completed job per app; files counted recursively (folders excluded); "typed"
= written with a workspace type (not `unspecified`). Sorted worst-typed first.

| App | Typed frac | Typed / files | Pattern |
|---|---|---|---|
| SequenceSubmission | 0.14 | 25 / 177 | C+D per-sample `SequenceValidation/<sample>/` |
| ViralAssembly | 0.47 | 96 / 206 | C+D per-segment + `irma/`, `quast/` |
| CodonTree | 0.53 | 9 / 17 | A+B; `detail_files/` untyped |
| RNASeq | 0.58 | 33 / 57 | C+D `<condition>/<sample>/` + matrices |
| StructureSequencePrediction | 0.67 | 4 / 6 | D `out/{probs,scores,seqs}/` |
| HASubtypeNumberingConversion | 0.80 | 8 / 10 | B+C fixed + per-query |
| TaxonomicClassification | 0.82 | 37 / 45 | C+D per-sample nested + aggregates |
| Homology | 0.83 | 5 / 6 | B fixed `blast_out.*` |
| SARS2Wastewater | 0.87 | 78 / 90 | C+D per-SRR `assembly/ fastqc/ freyja/` |
| Variation | 0.89 | 24 / 27 | C+B+D per-library `SE1.*` + `Text_Files_…/` |
| GenomeAnnotation | 0.97 | 29 / 30 | A+B + `load_files/*.json` |
| GenomeAnnotationGenbank | 0.97 | 30 / 31 | A+B (as GenomeAnnotation) |
| ComparativeSystems | 1.00 | 7 / 7 | A+B |
| ComprehensiveSARS2Analysis | 1.00 | 42 / 42 | B+D composite (`.annotation/ .assembly/` + job_results) |
| DifferentialExpression | 1.00 | 4 / 4 | B fixed (`diffexp_*` types) |
| FastqUtils | 1.00 | 2 / 2 | C per-input `<read>_fastqc.html` |
| GeneTree | 1.00 | 6 / 6 | A+B |
| Genomad | 1.00 | 10 / 10 | C per-input prefix `<contig>_*` |
| GenomeAlignment | 1.00 | 4 / 4 | B fixed `alignment.*` |
| GenomeAssembly2 ⚠ | 1.00 | 2 / 2 | B+D — **degenerate sample (JobFailed)** |
| GenomeComparison | 1.00 | 10 / 10 | B fixed `circos.*`, `genome_comparison.*` |
| MSA | 1.00 | 11 / 11 | A `{output_file}.*` |
| MetaCATS | 1.00 | 4 / 4 | A+B |
| MetagenomeBinning | 1.00 | 6 / 6 | B+C fixed + per-bin |
| MetagenomicReadMapping | 1.00 | 6 / 6 | B fixed `kma.*` |
| PrimerDesign | 1.00 | 3 / 3 | A |
| SARS2Assembly | 1.00 | 16 / 16 | A+D `{output_file}.*` + `sra-metadata/` |
| StabilityPrediction | 1.00 | 1 / 1 | B single `csv` |
| SubspeciesClassification | 1.00 | 30 / 30 | B+C report + `details/<ref>.tre` |
| TnSeq | 1.00 | 46 / 46 | C per-contig `.counts/.wig` |
| **Total** | **0.65** | **588 / 912** | — |

**Typed-fraction tracks the copy mechanism, not the app or the pattern.** Every
app at 1.00 uses explicit `save_file_to_file(...,$type)` per file. Every app
below ~0.9 uses a recursive `p3-cp --map-suffix` dump (idiom 3), where any suffix
absent from the map is written untyped. So the cleanup lever is the emitter, not
the spec.

### 3.2 Consolidating the pattern taxonomy (side goal)

The four "patterns" of §3 are not four kinds — they are **two orthogonal axes**
that got conflated:

- **Axis 1 — leaf naming:** `{output_file}`-prefixed (A) · fixed literal (B) ·
  per-input-item (C). These are real, distinct needs.
- **Axis 2 — folder shape:** flat vs nested. **D is not a naming pattern** — it
  is just any of A/B/C emitted into subfolders.

`B` (fixed literal names like `GenomeReport.html`, `alignment.xmfa`) is mostly
historical accident and could migrate onto the `{output_file}` prefix for
consistency, but that is a behavior change and not required for phase 1.

**Consolidation target — collapse to one model the schema (§4) already encodes:**
- leaf naming ∈ { `{output_file}`, `{sample}` (via `for_each`), literal } — Axis 1
- `folder` field carries all nesting — Axis 2, so `D` disappears as a concept
- every declared output has a `type`; the idiom-3 suffix maps get extended (or
  replaced by declared globs) so nothing lands `unspecified`.

This makes the worst-typed apps (SequenceSubmission, ViralAssembly, RNASeq) the
natural pilots for *declaring* and *fixing types* in one pass.

Cross-cutting structural facts:
- Outputs live under `result_folder` = `.<output_file>/`. Some apps nest
  subfolders (`detail_files/`, `load_files/`, `details/`, per-sample dirs).
- Composite apps re-emit **`job_result`** objects for sub-jobs
  (ComprehensiveSARS2Analysis has `annotation` + `assembly` job_results).
- A few names embed a run timestamp (`vigor_out-20260722-170409.ini`) — truly
  dynamic; the spec should match these by glob, not exact name.
- **Type vocabulary observed:** `genome, contigs, reads, feature_dna_fasta,
  feature_protein_fasta, aligned_dna_fasta, aligned_protein_fasta,
  feature_table, genbank_file, embl, gff, bam, bai, bigwig, vcf, wig, nwk,
  phyloxml, tsv, csv, txt, json, html, svg, png, xls, xml, tar_gz,
  genome_comparison_table, diffexp_experiment/expression/mapping/sample,
  job_result, folder, unspecified`.

## 4. Proposed schema

Add a top-level `"outputs"` array. Each entry:

```jsonc
{
  "id": "genome_report",           // logical, stable, unique within app
  "label": "Genome report",        // human label (UI)
  "desc": "HTML summary of the annotated genome.",
  "pattern": "GenomeReport.html",  // literal, or with {output_file} / {sample} / glob
  "type": "html",                  // workspace type (vocabulary above)
  "folder": "",                    // subfolder under result root ("" = root)
  "cardinality": "one",            // one | optional | many
  "for_each": null,                // null, or a param id whose items expand {sample}
  "condition": null,               // null, or {"param":"recipe","in":["…"]}
  "role": "report",                // report | primary | data | index | detail | log | intermediate
  "viewable": true                 // surfaced in the workspace UI vs. internal
}
```

Field notes:
- **`pattern`** — template vars: `{output_file}` (the `output_file` param),
  `{sample}` (bound by `for_each`). Glob (`*`) allowed for dynamic/timestamped
  names. Exactly one of literal / template / glob per entry.
- **`cardinality`** — `one` (always exactly one), `optional` (0–1, e.g. only if
  a param set), `many` (glob / per-item set).
- **`for_each`** — names an input param (a group/list, e.g. `paired_end_libs`,
  `experimental_conditions`) that generates pattern-C subtrees; `{sample}`
  resolves per item. Keeps the spec compact instead of enumerating SRRs.
- **`condition`** — declares parameter-conditional outputs (tree only when
  `recipe`≠none, DE tsv only when contrasts given). Optional in phase 1.
- **`role`/`viewable`** — lets the UI pick the landing report and hide
  intermediates (`irma/intermediate/…`, `quast/`).
- **Folders** as first-class outputs (`type:"folder"`, cardinality reflecting
  per-sample) let pattern-C/D apps declare the subtree shape without listing
  every leaf; use `many` + glob leaves inside.

Backward compatible: unknown top-level keys are ignored by existing loaders
(`AppScript::preprocess_parameters` only reads `parameters`). Verify the DB
app-spec cache path (`p3x-load-app-specs`) round-trips the new key — see §7.

## 5. Methodology for the estimate (what was done here)

For each app: took **one completed job** from the 2026-07-22 QA HTML, recursively
listed its workspace result folder with types (via a `Workspace ls` walker), and
normalized the basename to `{output_file}`. This yields the observed truth; the
service script yields the *intent* (which files are conditional, the suffix→type
maps, the intended type of currently-`unspecified` files). The spec for each app
should be written from **both**: QA harvest = "what actually came out", code =
"what is possible / what type it should be".

Coverage: 30/40 specs have a completed sample. **No completed run** for:
AlphaFold, ComprehensiveGenomeAnalysis, PredictStructureApp,
StructureSequencePrediction(partial), and the non-QA specs (Date, Sleep,
GenomeAnnotationGenbankTest, cepi-ppi, Docking, SyntenyGraph, TreeSort,
WholeGenomeSNPAnalysis, CoreGenomeMLST, SubspeciesClassification variants). These
must be derived from code (or a fresh QA run) alone.

## 6. Rollout

1. **Agree schema** (this doc, §4) + register the workspace **type vocabulary**
   as an enum so specs can be validated.
2. **Pilot on 3 apps**, one per complexity tier:
   - `MSA` (pattern A, suffix-map, clean) — trivial.
   - `GenomeAnnotation` (A+B, explicit typed saves, `load_files/`) — the
     reference for well-typed multi-file.
   - `RNASeq` (C+D, per-sample nesting, lots of `unspecified`) — exercises
     `for_each`, folders, and the untyped-cleanup case.
3. **Write a validator** (`p3x-check-app-outputs`): given a spec + a finished
   result folder, assert every `cardinality:one` output exists, flag
   `unspecified` files not covered by a declared glob, and report undeclared
   extras. Wire into the QA harness so future runs verify contracts.
4. **Backfill remaining specs**, code-first for the 10 apps lacking a sample.
5. **(Later) enforce & fix types.** Where the harvest shows `unspecified` but the
   declared `type` is concrete, fix the emitting code (extend the `--map-suffix`
   table or switch to `save_file_to_file` with the type). Optionally have the
   framework assign declared types at `write_results` time.
6. **(Later) consume.** UI reads `outputs` for result rendering; downstream
   apps resolve inputs by declared output id.

## 7. Open questions / risks

- **Cache round-trip:** does `p3x-load-app-specs` → `Application.spec` (DB) and
  the frozen `Task.app_spec` preserve an unknown `outputs` key intact? Must
  confirm before relying on it at runtime (cf. the preflight/spec-source
  behavior already documented in CLAUDE.md).
- **Who owns the vocabulary?** The workspace type list is currently implicit.
  Declaring outputs forces us to canonicalize it (and decide on `unspecified`
  as a legal declared type or a lint failure).
- **Conditional granularity:** phase 1 can mark conditional outputs simply
  `cardinality:optional` and defer the machine-readable `condition` DSL.
- **Degenerate samples:** GenomeAssembly2's only harvested "OK" run is a
  `JobFailed.txt` (task exit 1). QA "OK" ≠ full output — re-sample clean runs
  when writing specs, don't trust a single harvest row.
- **`job_result` / composite apps:** decide whether re-emitted sub-job
  `job_result` objects are declared outputs or framework artifacts.

## 8. Deliverables produced so far

- `PLAN-app-output-specs-estimate.md` — observed output tree + types for 30 apps
  (the estimate this task was asked to start with).
- This plan (schema + rollout).
