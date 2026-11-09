# Review loops

## Severity scale

| Severity | Meaning | Examples |
|----------|---------|----------|
| Critical | Wrong results on the main path, security hole, data loss, feature unusable by its real consumer | an API reports "missing" for data that exists; a token is accepted after revocation; the real client rejects the response |
| Important | Wrong or misleading in a realistic edge case, missing guard, failure presented as success | a dependency outage returns an empty, confident answer; an unbounded list; an error that leaks internals |
| Minor | Naming, comments, logs, small inconsistencies, low-value tests | a misleading comment; an inconsistent log message |

The stop rule counts only critical and important findings. Minor findings are
fixed in the loop that found them, or recorded as left over when they aren't
worth it.

## Reviewer brief

Give every reviewer a fresh context and this shape of brief. Fill in the
brackets and leave out your own opinion of the code.

```text
Review the implementation of <feature> on branch <branch> (diff against <base>).
Spec: <path>. Plan with progress and earlier loop logs: <path>.
Repository instructions: <CLAUDE.md / AGENTS.md path>.

This is review loop <n> of at most 4. Focus: <loop focus from the table in SKILL.md,
plus any weak area found earlier>. Earlier loops already fixed: <one line per fix,
so you don't re-report them>.

Read the actual code; run tests or the application if that helps you confirm a
finding. Do not edit product files. Temporary files go under <scratch dir>.

Report findings as a list, most severe first. Each finding has:
severity (critical / important / minor), file:line, what is wrong, a concrete
failing scenario (inputs or state, then the wrong output), and a suggested fix.
Say "no findings" for a severity with none. Finish with anything you could not
check.
```

Varying the reviewer's angle between loops finds more than repeating the same
brief. Loop 2 compares outputs with the source of truth. Loop 3 plays the real
user, for example an AI agent answering real questions through new tools, or a
person completing the task in the UI. Loop 4 breaks dependencies on purpose.

## Real-testing brief

Real testing can be done by the primary agent or a second subagent. Whoever runs
it owns the shared server or browser for the duration.

```text
Exercise <feature> in the running application at <url / command>, using <real
consumer: official SDK / CLI / browser / HTTP client>. Do not edit product files.

Scenarios: <happy path>, <boundaries>, <permission denied>, <cancellation>,
<dependency failure: how to simulate it>, <restart / expiry if relevant>.

For each scenario report: steps, expected, observed, pass/fail, evidence (output
excerpt or screenshot path). List anything you could not exercise and why.
```

## Evaluating findings

- Verify each finding against the code before fixing it. A reviewer can be wrong;
  say so in the loop log with the reason.
- Fix root causes, not the symptom a reviewer happened to hit. For example,
  replace a lookup that silently returns empty on failure with one that
  distinguishes "absent" from "unknown".
- After fixing, rerun the scenario that exposed the problem, plus the affected
  automated tests.
- When a fix changes behavior described in the spec, update the spec and note
  the deviation in the plan.

## Feature-type checklists

- **API or service:** status codes and error format, validation, authorization
  per role, pagination and size limits, timeouts, idempotency, outage behavior.
- **UI:** real components and design language, loading, empty and error states,
  keyboard and focus, narrow screens, copy, and disabled states for missing
  permissions.
- **Integration consumed by another tool (CLI, SDK, AI agent, webhook):** the
  real consumer accepts the output (schemas, nullability, content types), the
  auth handshake works end to end, errors are actionable for that consumer, and
  results are unambiguous to a reader with no context.
- **Data change or migration:** a dry run on realistic data, rollback, partial
  failure and rerun safety.
