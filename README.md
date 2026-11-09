# jadamski-skills

Personal agent skills that work in both **Claude Code** and **Codex**. Each skill
is a folder under `skills/` in the shared Agent Skills format (`SKILL.md` with
`name` and `description` front matter, plus optional `references/`, `assets/`
and `agents/openai.yaml` for Codex's display metadata).

| Skill | Use it for |
|-------|------------|
| [`feature-implementation-flow`](skills/feature-implementation-flow/SKILL.md) | Delivering a substantial feature end to end. You shape the design together with the agent; after your approval it runs unattended (spec, plan, implementation in small commits, up to 4 review/test/fix loops) and finishes with an HTML report that tells you how to review and test the work. It survives resets and session limits by resuming from the plan's Progress section. |
| [`uzupelnij-notatki`](skills/uzupelnij-notatki/SKILL.md) | Catching up on daily work notes in an Obsidian vault (`RRRR/MM-miesiąc/DD-DD/DD.MM.RRRR.md`), one working day at a time, from GitLab (`glab`), Slack, Google Calendar and Jira/Confluence activity. The first run sets up your personal config and, if you have no notes yet, your first note (see [Use](#uzupelnij-notatki)). Written in Polish. **Claude Code only**: it relies on Claude Code's MCP tools and `ToolSearch`. Optional argument: the last filled-in day (`DD.MM.RRRR`). |

## Install

Pick one method per tool. Installing both a plugin and a personal copy makes the
skill appear twice.

### Claude Code

As a plugin (to pick up changes, see [Update](#update)):

```bash
claude plugin marketplace add <git-url-or-local-path-of-this-repo>
```

```bash
claude plugin install jadamski-skills@jadamski-skills
```

The same works inside a session with `/plugin marketplace add …` and
`/plugin install …`. The skills are then `/jadamski-skills:<skill-name>`, for
example `/jadamski-skills:uzupelnij-notatki`.

As a personal skill (`~/.claude/skills/`), copied or symlinked:

```bash
bash install.sh --claude --link
```

### Codex

As a plugin:

```bash
codex plugin marketplace add <git-url-or-local-path-of-this-repo>
```

```bash
codex plugin add jadamski-skills@jadamski-skills
```

As a personal skill (`~/.agents/skills/`):

```bash
bash install.sh --codex --link
```

Use `--link` to keep the installed skill pointing at this checkout, so a
`git pull` updates it. Without `--link` the files are copied. `--force` replaces
an existing copy.

Skill names differ by install method. Installed as a plugin, the skill is
`jadamski-skills:feature-implementation-flow` in both tools, and Codex also uses
that name for a `--link` install, because it follows the symlink back to this
repository's plugin manifest. A copied personal skill is plain
`feature-implementation-flow`.

## Update

### Claude Code plugin

Claude Code runs the plugin from a copy in
`~/.claude/plugins/cache/jadamski-skills/jadamski-skills/<version>/`, not from
this folder. It replaces that copy only when the version changes. After editing
a skill:

1. Bump `version` in `.claude-plugin/plugin.json`, in the plugin entry of
   `.claude-plugin/marketplace.json` and in `.codex-plugin/plugin.json`, and add
   a changelog entry.
2. Refresh the marketplace and update the plugin:

```bash
claude plugin marketplace update jadamski-skills
```

```bash
claude plugin update jadamski-skills@jadamski-skills
```

3. Start a new session. Sessions that are already running keep the old copy.

If you added the marketplace from a local path, the update copies the folder as
it is, uncommitted changes included. If you added it from a git URL, commit and
push first, because the update reads the remote.

To try an edit before bumping the version, load the plugin straight from this
folder for one session. If the installed plugin is also enabled, the skills may
appear twice.

```bash
claude --plugin-dir <path-of-this-repo>
```

### Personal skills

A `--link` install points at this checkout, so edits and `git pull` take effect
in the next session. A copied install needs `bash install.sh --force` (with the
same `--claude` or `--codex` flag) after each change. On Windows, Git Bash's
`ln -s` makes a copy instead of a link unless `MSYS=winsymlinks:nativestrict` is
set (this needs Developer Mode), so check that `--link` created a link.

## Use

Ask for a skill in your own words, or name it.

### feature-implementation-flow

- Claude Code: `/feature-implementation-flow add CSV export to the audit log (ABC-123)`
- Codex: `$feature-implementation-flow add CSV export to the audit log (ABC-123)`
  (or `$jadamski-skills:feature-implementation-flow …`, depending on how it is installed)

A typical run:

1. The agent explores the code and asks one question at a time, each with
   options and a recommendation.
2. It presents the design in sections and waits for your explicit approval
   ("proceed to auto implementation").
3. Unattended, it writes the spec and plan, implements in small commits, tests
   with real clients and runs up to four review/test/fix loops. It decides
   reversible details itself and records them, and parks anything risky as a
   question.
4. You get an HTML report: what changed, the decisions, a reading order for code
   review, step-by-step test instructions, the evidence, and what's left for you.

If the session is reset or hits its time limit, start a new one with "resume
the feature implementation flow for <branch>". The agent continues from the
plan's Progress section.

### uzupelnij-notatki

`/uzupelnij-notatki`, or `/uzupelnij-notatki 16.10.2026` to name the last
filled-in day. The skill and its prompts are in Polish.

Your personal settings live in `~/.claude/uzupelnij-notatki.md`
(`%USERPROFILE%\.claude\uzupelnij-notatki.md` on Windows), outside this
repository, so updating the skill never overwrites them. They cover the vault
path, time zone, which sources you use, GitLab host and project IDs, Slack user
ID and channels, Atlassian site, recurring meetings to leave out, and your own
style rules. On the first run, when the file doesn't exist, the agent asks for
the vault path and your sources, works out the rest (GitLab host from `glab`,
MCP tool prefixes, Slack user ID, Atlassian site, time zone), and writes the file
from [`assets/konfiguracja.md`](skills/uzupelnij-notatki/assets/konfiguracja.md)
after you confirm it. Later it offers to add new projects, channels and rules as
it learns them.

If the vault has no notes yet, or doesn't exist, the agent asks which day to
start from and creates the folders, the month index and the first note. It can
also add the tasks you already have in progress.

## Repository layout

```
skills/<skill-name>/SKILL.md        the skill (shared by Claude Code and Codex)
skills/<skill-name>/references/     detail loaded only when needed
skills/<skill-name>/assets/         templates
skills/<skill-name>/agents/openai.yaml   Codex display metadata
.claude-plugin/                     Claude Code plugin + marketplace manifests
.codex-plugin/plugin.json           Codex plugin manifest
.agents/plugins/marketplace.json    Codex marketplace manifest
install.sh                          personal-skill installer for both tools
```

## Adding a skill

1. Create `skills/<name>/SKILL.md`. `name` uses lowercase letters, digits and
   hyphens and matches the folder. `description` is one line, at most 1024
   characters, and says when to use the skill.
2. Keep `SKILL.md` focused. Move long reference material into `references/`
   and link it with relative paths. Write tool-neutral actions ("dispatch a
   subagent"), and put tool names in a harness note.
3. Optionally add `agents/openai.yaml` (Codex `interface`: `display_name`,
   `short_description`, `default_prompt`).
4. Validate, then bump `version` in both plugin manifests and the Claude
   marketplace entry:

```bash
claude plugin validate .
```

```bash
codex plugin marketplace add "$PWD" && codex plugin list
```

## Changelog

### 1.2.0 (2026-11-09)

- **`uzupelnij-notatki` is no longer tied to one person.** The vault path,
  GitLab host and project IDs, Slack IDs and channels, Atlassian site, Jira
  project, recurring meetings and style examples moved out of the skill into a
  per-user config file, `~/.claude/uzupelnij-notatki.md`. The first run creates
  it from `assets/konfiguracja.md` and detects what it can. Sources you don't
  use can be switched off.
- **First note.** When the vault has no notes, or doesn't exist yet, the skill
  asks which day to start from and creates the folders, the month index and the
  first note.
- **Resume.** When the newest note is still the full working file from the
  previous run (empty Tematy or open tasks), the skill fills in and finalizes
  that day before moving on, instead of skipping it.
- **Fixes.** Confluence calls use the Atlassian plugin's current tool names
  (`searchConfluence`, `getConfluenceContent`). Calendar queries pass local time
  plus `timeZone` instead of a fixed `+02:00` offset, which was an hour off in
  winter. The `<N>`/`<N+2>` query bounds are now defined as calendar days, so the
  queries for a Monday don't pick up the weekend.

### 1.1.0 (2026-11-06)

- **New skill: `uzupelnij-notatki`.** Moved from the `notatki` vault, where it
  was a project skill (`.claude/skills/`). The skill now states the vault's
  path, so it also works when the session runs in another folder. A broken
  `newline="\n"` example in its Windows tip is fixed.

### 1.0.0 (2026-11-06)

`feature-implementation-flow`, reworked from the original single-file version:

- **Auto phase.** After approval, the run continues to the report without
  routine questions. A "decide, record, continue" rule covers gaps in the plan,
  and anything risky is parked as a question.
- **Survives interruptions.** The plan has a Progress section with a `Next:`
  line, committed with every task. The skill opens with a resume procedure that
  restores the checkout and continues where the run stopped.
- **Time limits.** Near a session limit, the agent commits, writes the `Next:`
  line and reports what is verified.
- **Shaping.** Questions come one at a time, each with options and a
  recommendation. The design is approved section by section. The approval
  message flags anything new that will be in the spec.
- **Loops.** The focus changes from loop to loop: broad review, correct answers,
  behavior, then the final gate. The stop rule is explicit: minor findings never
  start another loop. Reviewer and tester briefs and a severity scale are
  included.
- **Real consumers.** The feature is tested through its real consumer (official
  SDK, CLI or browser) before loop 1, not only through unit tests.
- **Report.** New sections: Try it first, Decisions, How to review (reading
  order), How to test it yourself, and Left for you.
- **Harnesses.** Claude Code and Codex notes cover tool names, subagents,
  approvals and sandboxing, report delivery and skill locations. Plugin
  manifests for both tools and `install.sh` are included.
