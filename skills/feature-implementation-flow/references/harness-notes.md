# Harness notes: Claude Code and Codex

The skill describes actions; this table maps them to each harness. If your
actual tool list disagrees with this table, trust the tool list.

| Action | Claude Code | Codex |
|--------|-------------|-------|
| Ask a multiple-choice question | `AskUserQuestion` (recommended option first), or a plain message with lettered options | A plain message with lettered options |
| Track tasks during a session | The task or todo tools (`TaskCreate`/`TaskUpdate`, `TodoWrite` in older versions) | `update_plan` |
| Dispatch a reviewer with a fresh context | `Agent` tool (`general-purpose`); `run_in_background: true` to run reviewer and tester in parallel | `spawn_agent` with `fork_turns: "none"`, then `wait_agent` |
| Continue the same subagent | `SendMessage` to the agent | `followup_task` |
| Isolated workspace for a parallel implementer | `Agent` with `isolation: "worktree"`, or `git worktree` | `git worktree`, or the Codex app's worktree mode |
| Invoke this skill | `/feature-implementation-flow` (`/jadamski-skills:feature-implementation-flow` when installed as a plugin) | `$feature-implementation-flow` (`$jadamski-skills:feature-implementation-flow` when installed as a plugin or symlinked from the repo), or pick it from `/skills` |
| Deliver the report | An `Artifact` tool, if present (claude.ai sessions): publish the HTML as a private artifact and link it. Otherwise write the file and give its path; a file-sending tool, if present, can attach it. | Write the file and give its path; the Codex app opens local HTML |

## Claude Code

- **Long runs and compaction.** Context is summarized when it fills up. The
  Progress section is what survives reliably, so keep it current. Before a manual
  `/compact`, pass instructions that name the branch, the plan path and the
  current loop.
- **Cloud and self-hosted runners** may reset an idle workspace to the default
  branch and may stop a session after a fixed time. Push the feature branch for
  safekeeping only if the user or the environment instructions allow it. Treat
  the limit as the clock in "Watch the clock".
- **Subagents.** Give reviewers `subagent_type: general-purpose` (or a review
  agent the user defined), a model override only if the user asked for one, and
  the brief from `review-loops.md`. Background agents notify on completion, so
  don't poll them.
- **Commits.** End commit messages with any attribution lines the harness
  provides.
- **Artifacts.** When the report is published through an `Artifact` tool, that
  tool's page rules (title, theming, allowed libraries) take precedence over the
  template's defaults.

## Codex

- **Subagents** need the `multi_agent` feature, which is on by default in
  current versions (`codex features list`). On older versions, add
  `[features] multi_agent = true` to `~/.codex/config.toml`. Spawn reviewers with
  `fork_turns: "none"` so they don't inherit your transcript and your
  conclusions. Set `model` and `reasoning_effort` together when overriding.
  Wait in long stretches (`wait_agent` with a timeout of 5–10 minutes) instead
  of short polls.
- **Unattended runs and approvals.** The auto phase stalls if every command
  waits for approval while the user is away. Start the run with a policy that
  suits it, for example `codex -s workspace-write -a on-request`, or a stricter
  setup the user chooses. Never use `--dangerously-bypass-approvals-and-sandbox`
  outside an externally sandboxed environment.
- **Sandbox limits.** If the sandbox blocks network access, local servers or Git
  writes that the plan needs, say so in the approval message and ask once for
  the required permission. If a step is still blocked during the run, record it in
  Progress and in the report's "Left for you"; don't claim it passed.
- **Branches.** The Codex app may create its own branch (often `codex/...`) or
  run on a detached worktree. Use the branch it gives you. When branching or
  pushing is impossible, commit locally and tell the user to use the app's
  branch or hand-off controls.
- **Skill locations**: `~/.agents/skills/` (user) or `.agents/skills/` in a
  repository. `agents/openai.yaml` in the skill folder holds Codex's display
  metadata.
