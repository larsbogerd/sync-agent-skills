#!/bin/sh
# Install the sync-agent-skills skill into Claude Code on this Mac, then run a first sync.
# The skill is linked, not copied, so `git pull` in this repo updates it.
set -e
repo=$(cd "$(dirname "$0")" && pwd)
skill="$repo/skills/sync-agent-skills"
link="$HOME/.claude/skills/sync-agent-skills"

mkdir -p "$HOME/.claude/skills"
if [ -e "$link" ] && [ ! -L "$link" ]; then
  echo "error: $link exists and is not a symlink; move it away and run again" >&2
  exit 1
fi
ln -sfn "$skill" "$link"
echo "installed $link -> $skill"

sh "$skill/sync.sh"
