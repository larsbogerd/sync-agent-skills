---
name: sync-agent-skills
description: Link skills from ~/.agents/skills into ~/.claude/skills so that they show up in Claude Code, and clean up links to skills that were removed. `npx skills add` already makes this link when Claude Code is one of the selected agents, so this is for skills that have no link - skills put in ~/.agents/skills by hand (written, copied or cloned with Git) and skills installed with `npx skills` for other agents only. Use this whenever the user says a skill is missing, not showing up, or not in the skill list, when a skill was added to or removed from ~/.agents/skills, when ~/.agents/skills is mentioned, or when the user asks to sync, link or refresh their skills. Not for finding or choosing new skills to install; that is find-skills.
---

# Sync agent skills

`~/.agents/skills/` is a shared folder for many coding agents. Claude Code only scans `~/.claude/skills/`, so a skill in the shared folder stays invisible until it is linked there.

`npx skills add` makes that link itself when Claude Code is one of the selected agents. This skill covers the skills that have no link: ones the user put in `~/.agents/skills/` by hand (written, copied or cloned with Git), and ones installed with `npx skills` for other agents only. Links (not copies) are used so that changes to a skill reach Claude Code with no extra step.

## Run the sync

```sh
sh ~/.claude/skills/sync-agent-skills/scripts/sync.sh
```

The script is safe to run any number of times. It only looks at folders that contain a `SKILL.md` and ignores other folders (such as sync folders). It prints one line per skill:

- `linked`: new link created
- `relink`: link pointed somewhere else and now points to `~/.agents/skills`
- `ok`: already linked, nothing to do
- `skip`: a real folder (not a link) with that name is already in `~/.claude/skills/`; the script leaves it alone because it is probably a skill the user made or installed another way
- `plugin`: an installed Claude Code plugin already has a skill with this name (in its `skills/` folder); the script does not link it, and removes an existing link to it, so the skill does not show up twice. Claude Code uses the plugin version, which the plugin updates. The copy in `~/.agents/skills/` stays for other agents
- `removed`: the skill is gone from `~/.agents/skills/`, so its dead link was deleted

Give the user a short summary of what changed: the skills that were linked or removed, any `plugin` lines, and any `skip` lines, because those mean two different skills have the same name. Don't list all the `ok` lines.

## After the sync

Claude Code watches `~/.claude/skills/`, so new skills normally become available in the running session within a moment. If a skill the user expects still is not in the skill list, ask them to run `/reload-skills` or start a new session. Claude can't run built-in slash commands itself.
