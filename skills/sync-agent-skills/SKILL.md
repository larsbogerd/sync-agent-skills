---
name: sync-agent-skills
description: Make skills installed with the `npx skills` CLI show up in Claude Code by symlinking each one from ~/.agents/skills into ~/.claude/skills, and clean up links to skills that were removed. Use this whenever a skill was just installed, updated or removed with `npx skills` (including right after the find-skills skill installs one), when the user says a skill they installed is missing, not showing up, or not in the skill list, when ~/.agents/skills is mentioned, or when the user asks to sync, link or refresh their skills. Not for finding or choosing new skills to install; that is find-skills.
---

# Sync agent skills

`npx skills` installs into `~/.agents/skills/`, a shared folder for many coding agents. Claude Code only scans `~/.claude/skills/`, so a freshly installed skill stays invisible until it is linked there. Links (not copies) are used so that `npx skills update` changes reach Claude Code with no extra step.

## Run the sync

```sh
sh ~/.claude/skills/sync-agent-skills/scripts/sync.sh
```

The script is safe to run any number of times. It prints one line per skill:

- `linked`: new link created
- `relink`: link pointed somewhere else and now points to `~/.agents/skills`
- `ok`: already linked, nothing to do
- `skip`: a real folder (not a link) with that name is already in `~/.claude/skills/`; the script leaves it alone because it is probably a skill the user made or installed another way
- `removed`: the skill is gone from `~/.agents/skills/`, so its dead link was deleted

Give the user a short summary of what changed: the skills that were linked or removed, and any `skip` lines, because those mean two different skills have the same name. Don't list all the `ok` lines.

## After the sync

Claude Code watches `~/.claude/skills/`, so new skills normally become available in the running session within a moment. If a skill the user expects still is not in the skill list, ask them to run `/reload-skills` or start a new session. Claude can't run built-in slash commands itself.
