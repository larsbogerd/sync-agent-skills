---
name: sync-agent-skills
description: Link skills installed with `npx skills` (in ~/.agents/skills) into ~/.claude/skills so Claude Code can use them, and remove links to skills that were uninstalled. Use after `npx skills add` or `npx skills remove`, or when the user says sync skills, link skills, or a newly installed skill does not show up.
---

# Sync agent skills

`npx skills` installs to `~/.agents/skills/`. Claude Code reads `~/.claude/skills/`. This skill keeps a symlink in `~/.claude/skills/` for each skill in `~/.agents/skills/`.

## Steps

1. Run the script:

   ```sh
   sh ~/.claude/skills/sync-agent-skills/sync.sh
   ```

   It prints one line per skill: `linked`, `relink`, `ok`, `skip` (a real folder with that name already exists, so it is left alone), or `removed` (dead link to an uninstalled skill).

2. Tell the user what changed.

3. Reload: Claude Code watches `~/.claude/skills/` and picks up new or removed skills in the running session, so no restart is normally needed. If a new skill still does not appear in the skill list, ask the user to run `/reload-skills` (Claude cannot run built-in slash commands itself) or start a new session.
