# Spec and plan

Both documents are internal context for agents and maintainers. The user reads
the HTML report, not these. Write them for a cold reader: an agent resuming
after a reset must be able to continue from the files alone.

## Spec contents

Use the repository's own headings if it has a convention. Otherwise:

1. **Goal**: one paragraph covering the problem, who it is for and the ticket ID.
2. **Decisions**: a table with one row per decision taken while shaping.

   | # | Decision | User's words | Consequence |
   |---|----------|--------------|-------------|
   | 1 | The app issues its own API tokens; the identity provider only signs the user in | "option B is correct" | Own token store; provider tokens never reach clients |

3. **Behavior and acceptance criteria**: observable behavior, including errors
   and permission boundaries, as checkable statements.
4. **Design**: components and the flow between them, data and API changes,
   configuration, and approved UI decisions (link the preview if there was one).
5. **Security and limits**: authentication, authorization, data scope, caps,
   timeouts and lifetimes.
6. **Test strategy**: which behaviors get automated tests and at which layer,
   and how the feature is exercised through its real consumer.
7. **Out of scope and later**: what was explicitly deferred.
8. **Production checklist**: configuration, secrets and builds the user must
   handle before release.

## Plan contents

```markdown
# <Feature> implementation plan

Spec: <path>. Branch: <branch>. Started: <date time, timezone>.

## Task 1: <name>
Files: <paths>
Steps: <short list>
Verify: <command and expected result>

## Task 2: ...

## Progress
Next: Task 4, wire the token endpoint into the controller (updated 2026-11-05 22:10 CET)

- [x] Spec and plan (a1b2c3d)
- [x] Task 1: configuration (e4f5a6b)
- [x] Task 2: client IDs and token helpers (0c1d2e3)
- [x] Task 3: grant store (4f5a6b7)
- [ ] Task 4: OAuth endpoints
- [ ] Task 5: tools
- [ ] Real-consumer smoke test
- [ ] Loop 1: broad review and real-client tests
- [ ] Loop 2: correct answers
- [ ] Loop 3: behavioral
- [ ] Loop 4: final gate
- [ ] Report

### Decisions made in the auto phase
- A1: Capped active grants per user at 20 (`app.mcp.max-grants`) so one user
  can't exhaust memory. Change the config value to adjust.

### Questions for the user
- (none)

### Loop log
| Loop | Focus | Critical | Important | Minor | Fix commits | Notes |
|------|-------|----------|-----------|-------|-------------|-------|
| 1 | Broad review | 0 | 2 | 11 | 9a8b7c6 | real client rejected `title: null` in tool list |

### Deviations from the spec
- None yet.
```

Rules:

- Tick a box and update `Next:` in the same commit as the work it describes.
- `Next:` names a concrete action, not "continue".
- Unchecked loops that the stop rule made unnecessary are marked
  `- [~] Loop 3: not needed (loop 2 found no critical or important issues)`.
- Record times with a timezone, so a later reader can reconstruct the timeline.
