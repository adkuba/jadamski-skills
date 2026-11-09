#!/usr/bin/env bash
# Install the skills in ./skills as personal skills for Claude Code and/or Codex.
#
#   bash install.sh                 # copy into ~/.claude/skills and ~/.agents/skills
#   bash install.sh --link          # symlink instead, so `git pull` updates them
#   bash install.sh --claude        # Claude Code only
#   bash install.sh --codex         # Codex only
#   bash install.sh --force         # replace an existing copy of a skill
#
# Plugin installs (marketplaces) are described in README.md; use one method, not both,
# or the skill shows up twice.
set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
mode=copy force=0 targets=()

for arg in "$@"; do
  case "$arg" in
    --link)   mode=link ;;
    --force)  force=1 ;;
    --claude) targets+=("$HOME/.claude/skills") ;;
    --codex)  targets+=("$HOME/.agents/skills") ;;
    -h|--help) sed -n '2,11p' "$0"; exit 0 ;;
    *) echo "Unknown option: $arg" >&2; exit 2 ;;
  esac
done
[ ${#targets[@]} -eq 0 ] && targets=("$HOME/.claude/skills" "$HOME/.agents/skills")

for target in "${targets[@]}"; do
  mkdir -p "$target"
  for skill in "$repo"/skills/*/; do
    name="$(basename "$skill")"
    dest="$target/$name"
    if [ -e "$dest" ] || [ -L "$dest" ]; then
      if [ -L "$dest" ] || [ "$force" -eq 1 ]; then
        rm -rf "$dest"
      else
        echo "skip  $dest (exists; rerun with --force to replace it)"
        continue
      fi
    fi
    if [ "$mode" = link ]; then
      ln -s "${skill%/}" "$dest"
    else
      cp -R "${skill%/}" "$dest"
    fi
    echo "$mode  $name -> $dest"
  done
done
