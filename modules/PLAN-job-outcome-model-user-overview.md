# Understanding Job Results: What's Changing

**Audience:** Experienced BV-BRC users (researchers running jobs via the website
or the command-line tools) — no programming background assumed.
**Companion to:** the technical design in `PLAN-job-outcome-model.md`.
**Date:** 2026-07-14

---

## The short version

Today, when you run a job in BV-BRC, the system tells you essentially one of two
things: **Completed** or **Failed**. That is often not enough to understand what
actually happened. We are adding a richer, consistent way for jobs to report
*what* happened and, when appropriate, *why* — so that a job which couldn't
produce a result because of the input data no longer looks the same as a job that
crashed, and neither is left for you to guess about.

---

## The problem you may have run into

Every BV-BRC job ends in one of three ways, but the current system can only show
you two of them. That mismatch is the source of a lot of confusion:

1. **It worked.** The job did what you asked, wrote its output to your workspace,
   and (for most applications) produced a report. This case is fine today.

2. **It ran, but couldn't give you the result you wanted — and this is not a bug.**
   The problem is in the data or the input, and the application often *knows*
   exactly what went wrong. Examples:
   - an **assembly** that couldn't build any contigs from low-quality reads;
   - a **viral annotation** of a virus that isn't in the reference set the tool
     supports, so nothing could be annotated;
   - a **codon tree** that can't be built because the input genomes share too few
     genes in common.

   Today these can show up in confusing ways. Sometimes the job is marked
   **Failed** (looking exactly like a crash), sometimes it's marked **Completed**
   with an empty or incomplete output folder, and usually there is **no
   explanation** telling you the input was the issue or what to do about it.

3. **It crashed.** Something went genuinely wrong inside the software. The job is
   marked **Failed** and usually leaves nothing useful behind.

The core issue: **category 2 has nowhere to live.** It gets squeezed into either
"Completed" or "Failed," and the explanation — which the application often
already has — never reaches you.

---

## What's changing

We are giving every job a clear **outcome**, separate from whether the underlying
computer job technically ran. There are now four possible outcomes, and — this is
the important part — **the same four are used by every application**, so you learn
them once:

| Outcome | What it means |
|---------|---------------|
| **Succeeded** | The job produced the result you asked for. |
| **No output** | The job ran correctly, but there was no usable result — and that traces back to the input data (e.g. no contigs assembled, virus not in the supported set). This is *not* a crash. |
| **Input problem** | The job could not proceed because something about the input needs to be fixed (e.g. a required field is missing, or not enough shared genes to build a tree). This is *actionable by you*. |
| **Failed** | An unexpected error inside the software. This is the one we investigate. |

Crucially, the two middle cases — **No output** and **Input problem** — are no
longer disguised as crashes. When the application understands what happened, it
will tell you in a **consistent, plain-language diagnosis**, including, where
possible, **what you can do about it**.

### Before vs. after

| Situation | Today | With the new model |
|-----------|-------|--------------------|
| Assembly finds no contigs (poor reads) | "Completed" (empty folder) or "Failed" | **No output** — "No contigs could be assembled from the provided reads," with guidance |
| Viral annotation of an unsupported virus | "Failed" (looks like a crash) | **No output** — "This virus is outside the supported reference set" |
| Codon tree, too few shared genes | "Failed" | **Input problem** — "The input genomes share too few genes to build a tree" |
| Missing required input | "Failed" | **Input problem** — names the missing input |
| Genuine software error | "Failed" | **Failed** (unchanged — but now clearly distinct from the above) |
| Normal successful run | "Completed" | **Succeeded** (unchanged) |

---

## Multi-step jobs: seeing inside the pipeline

Some applications are really several steps run in sequence. Genome annotation, for
example, may try one annotation method and, if it doesn't apply, fall back to
another. Today, if one internal step doesn't work, you can't see it — the job just
succeeds or fails as a whole, with no window into what happened along the way.

The new model lets each application **report the status of individual steps** in
addition to the overall result. So a genome annotation job might show:

> **Completed (with notes)**
> - Assembly — succeeded
> - LowVan viral annotation — *no output: virus outside supported set* (skipped)
> - VIGOR4 annotation — succeeded

The overall job is a genuine success, and you can still **see** that one step
didn't apply and why, instead of being left in the dark. When a step that doesn't
affect the final result runs into trouble, the job is marked **"Completed (with
notes)"** — a signal to glance at the details without implying anything went
wrong.

This same "step-by-step" reporting works even for applications that aren't strict
pipelines; any multi-step application can use it.

---

## Where you'll see this

- **The job list** (website and `p3-qstat` on the command line) will show the new
  outcome at a glance — for example "Completed," "Completed (with notes),"
  "No output," "Input problem," or "Failed" — instead of just "Completed" or
  "Failed."
- **The job details** will include the plain-language diagnosis and, for
  multi-step jobs, the per-step breakdown.
- **Your existing outputs and reports are unchanged.** The diagnosis is a small,
  consistent summary added *on top of* whatever an application already produces —
  it does not replace the detailed reports you're used to.

### One durability note

The outcome and its explanation are recorded in the system's **permanent job
history**, which you cannot accidentally delete. The more detailed diagnosis files
are also written into your workspace (where you can read or remove them like any
other file), but the essential "what happened and why" is preserved for the life
of the job record regardless.

---

## Rollout

This is a foundation that applications adopt over time. Nothing about your current
jobs breaks: an application that hasn't been updated yet will behave exactly as it
does today. As applications are enhanced, they gain the clearer outcomes and
diagnoses described here.

The **first application** being updated is **LowVan viral annotation**, precisely
because it has several distinct, common situations (unsupported virus, low-quality
assembly, missing input) that today all look like the same unhelpful "Failed." The
most-used applications will follow.

---

## In one sentence

We're replacing a two-way "Completed / Failed" signal — which forced very
different situations to look alike — with a small, consistent set of outcomes that
tell you whether your job succeeded, whether the input was the issue (and what to
do), or whether the software genuinely failed, along with step-by-step visibility
for multi-step jobs.
