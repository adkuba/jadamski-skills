---
name: feature-implementation-flow
description: "Use when the user wants a substantial feature or ticket delivered end to end: shaped together first, then built unattended after their approval (\"proceed to auto implementation\", \"spec, implement, review loops, report\", \"implement it while I'm away\"), or when resuming such a run after a reset, compaction or session time limit. Not for questions, standalone code reviews or small edits unless the user asks for this flow."
---

# Feature Implementation Flow

A feature is delivered in two modes with one approval between them:

1. **Shaping (interactive).** Explore the code, ask the questions that matter,
   design the feature with the user until they approve it.
2. **Auto phase (unattended).** From approval to report: spec, plan,
   implementation in small commits, up to four review/test/fix loops, and a report
   that lets the user review and test the work. No routine questions; the user
   may be away for hours and the session may stop at any moment.

Current user instructions override any part of this flow (skip a phase, change
the loop count, waive the preview). Make such a change explicit; don't infer it
from enthusiasm. Preserve the project's architecture and conventions throughout.
Tool names differ between Claude Code and Codex: see
[references/harness-notes.md](references/harness-notes.md).

## Resuming? Start here

If this task already has a plan with a Progress section, or the conversation
summary mentions one, you are resuming. Don't restart, re-plan or re-ask for
approval.

1. Restore the checkout. Cloud and container workspaces can come back reset to
   the default branch: fetch and check out the feature branch named in the
   summary or plan. Never re-implement lost work from memory.
2. Read the plan's Progress section and `git log` on the branch, then continue at
   the `Next:` line (the first unchecked item).
3. Keep the loop count, findings and decisions already recorded.

If the branch exists nowhere (it was never pushed and the workspace was wiped),
say so plainly. Then rebuild from the spec and plan files if they survived, or
from the conversation summary if they didn't, starting at the first task. Note
the loss in the report.

## Phase 1: Shape the feature with the user

- **Explore first.** Read repository instructions (CLAUDE.md, AGENTS.md, README),
  the relevant code, contracts, permissions, tests and Git state. Settle routine
  choices from the code instead of asking.
- **Ask one question at a time**, and only questions whose answer changes the
  design. Offer 2–4 lettered options with their trade-offs and say which one you
  recommend and why. When the user asks how something works, explain it plainly
  (simpler on a second ask), then return to the open question.
- **Present the design in sections** of roughly 150–300 words: architecture,
  flow and data, API/UI, security, testing and rollout. Confirm each section
  before the next. "Looks good" on one section approves that section only.
- **Keep a decision list** as you go: each user decision in their own words plus
  your one-line reading of it. It becomes the spec's Decisions table.
- Shaping means investigation, questions and previews. Don't start the feature,
  make backend mutations or commit implementation code yet.

### Interactive UI preview, when useful

If the feature introduces or materially changes a user flow, offer a clickable
preview before approval.

- Build it from the application's real components, styles, layout and language,
  using a comparable screen as reference. Don't invent a new visual style.
- Keep it isolated and reversible. Use synthetic data or fixtures for side
  effects, check ports and running services first, and never wire it to a live
  backend by accident.
- Show the actual preview (a screenshot alone is not interactive) and let the
  user polish wording, layout and confirmations. Backend-only work needs no
  artificial UI demo.

### Approval gate

**Start the auto phase only on explicit approval of the whole design**, such as
"proceed", "go ahead and implement" or "start the auto phase". A request to build
a loose idea, silence, elapsed time or praise for a demo is not approval. If
intent is unclear, ask one focused question and stay in shaping.

In the message that asks for approval, include:

- anything the spec will contain that you haven't discussed (defaults, limits,
  names, new dependencies), so the user approves it in chat and doesn't need to
  read the spec;
- the auto-phase plan in one line (loop count, test scope, report form);
- if the workspace is ephemeral and pushing isn't already allowed: whether you may
  push the feature branch as a backup (a backup, not a release).

If the user approves before you have listed these, put them in your first
auto-phase message and start anyway; the user can object when they're back.
Honor approval already given; don't ask again. Material changes to scope or
behavior after approval need renewed agreement (see "Decide, record, continue").

## Phase 2: Auto phase

### Operating rules

- **Decide, record, continue.** For a choice the plan doesn't cover:
  - *Inside the approved design and easy to change later*: safety limits and
    caps, defaults, timeouts, names, error messages, internal structure. Pick the
    conservative option you would have recommended, implement it, and record it in
    the plan under "Decisions made in the auto phase" with the reason and how to
    change it. List it in the report.
  - *Outside it*: contradicts a user decision; adds or removes a capability the
    users of the feature would notice; changes an external contract; is
    irreversible or outward-facing (pushing without permission, deploying,
    migrating shared data, sending messages, deleting); or changes security
    policy the user set. Don't do it. Add it to "Questions for the user" and
    continue with everything it doesn't block. If everything left depends on the
    answer, finish the report with the question at the top.
- **Commit small and often.** Commit each plan task or coherent fix once its
  checks pass, and update the Progress section in the same commit. Check that
  you're on the feature branch before each commit. Stage only task-owned files,
  never secrets or caches, and skip empty commits. Push only when allowed.
- **Watch the clock.** If the environment has a session limit, check the elapsed
  time at each task. With about 30 minutes left, don't start a new loop. Do these
  in order:
  1. Commit what passes its checks.
  2. Bring Progress up to date with a precise `Next:` line, and commit.
  3. If it fits, run the most valuable missing check, usually the real-consumer
     run.
  4. Write the report with what is verified so far, marking the rest as not run.
- **Keep the user's constraints.** Constraints set while shaping ("only necessary
  tests", "don't upgrade the framework", "read-only") bind every later step.

### Step 1: Branch, spec and plan

1. **Branch.** Reuse the branch for this task if it exists. Otherwise use the
   repository's naming rule, or a branch the user or harness designated, falling
   back to `feature/<ticket>-<slug>`. Preserve unrelated working changes. Use
   corresponding branches when several repositories are involved.
2. **Spec.** Follow the repository's convention for design documents (for
   example `docs/superpowers/specs/YYYY-MM-DD-<topic>.md`, or numbered
   `docs/NNN-<feature>.md`). If there is none, create `docs/NNN-<feature>.md`
   with the next free number. Contents are listed in
   [references/spec-and-plan.md](references/spec-and-plan.md). Don't ask the user
   to review it: anything new was already flagged at approval.
3. **Plan.** Break the work into tasks small enough to commit one by one (about
   5–30 minutes each), each naming its files, steps and verification. End the
   plan with the **Progress** section from
   [references/spec-and-plan.md](references/spec-and-plan.md): a checkbox per
   task, per loop and for the report, plus a `Next:` line. It is the resume
   point after any interruption, so keep it current. The plan can share a file
   with the spec if that is the convention.
4. Commit the spec and plan before writing product code.

### Step 2: Implement

- Follow the plan task by task, using existing patterns. Reuse tests and
  fixtures before adding new ones.
- **Add only valuable tests**: business rules, authorization and isolation, data
  integrity, boundaries, integration contracts and regression-prone failure
  handling. Pick the smallest useful set at the right layer, and prefer a
  parameterized case over a new suite. Skip tests that mirror implementation,
  assert incidental wording or styling, or duplicate coverage. Copy and styling
  changes need visual checks, not new tests. Report real test counts: a run that
  discovers zero tests proves nothing.
- Independent parts (for example the frontend of a backend feature) may go to a
  subagent in an isolated worktree with disjoint files. Review its diff before
  merging it.
- **Before loop 1, smoke-test the main path through its real consumer**: the
  official SDK or CLI that will call it, a browser for UI, a real HTTP client for
  an API. Unit tests passing doesn't mean it works. The smoke test answers
  whether it works at all; the testing in each loop goes broader and deeper. Use
  synthetic dependencies only where real calls would mutate data or need access
  you don't have, and keep track of what that fixture leaves unproven.
- When a test harness is worth keeping (an end-to-end script, a fixture
  launcher), commit it to the repository's tooling so the user can rerun it.

### Step 3: Review, test and fix (up to four loops)

Each loop runs these steps:

1. **Review.** A fresh subagent gets the spec, the branch or diff and the
   repository context, but not your opinion of the code. It reports findings with
   severity, file and line, and a reproduction or reasoning. Briefs and the
   severity scale are in [references/review-loops.md](references/review-loops.md).
2. **Real testing.** Exercise the running application against the spec through
   its real consumers: happy paths, boundaries, permissions, cancellation and
   failure behavior. This can run in parallel with the review. One owner controls
   the shared server or browser.
3. **Fix and verify.** Only the primary agent edits product code. Evaluate each
   finding on its merits, fix the justified ones, then rerun the affected checks
   and scenarios.
4. **Record and commit.** Log findings, fixes, checks and leftovers in the
   Progress section, and commit.

Shift the focus each loop, unless a loop exposes a weak area worth another pass:

| Loop | Focus |
|------|-------|
| 1 | Broad code review: correctness, security, conventions, test value |
| 2 | Correct answers: compare outputs with the source of truth on realistic data |
| 3 | Behavioral: use the feature as its real user would, and look for misleading results, confusing errors and missing guidance |
| 4 | Final gate: dependency outages, restarts, permission edges, concurrency; full suite and end-to-end rerun |

**Stop rule.** After a loop's fixes are verified, stop if that loop found no
critical or important issues. Fix its minor findings in the same loop; they never
justify another loop. Stop early too when an external blocker makes another loop
useless, and record the check as blocked. Never run a fifth loop: report what is
left.

If subagents are unavailable, say so, run the checks yourself, and don't call it
an independent review.

### Step 4: Report for the human

Write a self-contained HTML report from
[assets/implementation-report.html](assets/implementation-report.html). Use the
same number or slug as the spec where practical, for example
`reports/NNN-<feature>.html`. It must let the user do three things without
reading the transcript.

- **Understand the result:** outcome and delivery state, what changed and where
  the user sees it, how it works (only the choices that matter), and the
  decisions table (the user's decisions plus those made in the auto phase).
- **Review the code:** a suggested reading order of 5–10 files, each with what
  to look for, plus a compact file map.
- **Test it themselves:** numbered steps with commands and expected results,
  starting with the quickest convincing check.

Then add the evidence and what's left:

- **Evidence:** automated counts, real-consumer runs, and manual and simulated
  checks, labeled as such. Failed, blocked and skipped checks appear honestly.
  Include the review loops (findings by severity per loop, notable catches) and
  the branch and commits.
- **Left for you:** what you couldn't verify (production build, real SSO,
  production configuration), open questions and known limitations.

Put commands, file lists and screenshots behind expandable sections. Escape
inserted text, remove unused sections and all placeholders, and include no
credentials. Check the layout before delivering. Publish or open it as described
in [references/harness-notes.md](references/harness-notes.md), and link it from
the plan.

**Final reply:** the report link and 3–5 lines (outcome, the first thing to try,
open issues). Don't paste the report or offer another implementation round.

## Red flags in the auto phase

| Thought | Do instead |
|---------|------------|
| "I'll quickly ask the user" | They're away. Decide, record and continue, or park the question. |
| "I'll commit once it's all done" | A hard stop loses it. Commit each task. |
| "I'll update the plan later" | Update Progress in the same commit. |
| "The checkout looks empty, so I'll redo it" | Fetch the branch and resume from Progress. |
| "All tests pass, so it works" | Run it through the real consumer. |
| "Only minor findings: one more loop" | Fix them in this loop and stop. |
| "Loop 4 still found things: one more" | Stop and report them. |
| "I'll tell the reviewer it looks correct" | Give it the spec and the diff, and let it reach its own conclusion. |
| "This choice is small enough to skip recording" | Record it: the user reviews decisions, not diffs. |
