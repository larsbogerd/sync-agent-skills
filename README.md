# sync-agent-skills

A Claude Code skill that links skills from `~/.agents/skills/` into `~/.claude/skills/`.

`~/.agents/skills/` is a shared folder for many coding agents. Claude Code reads skills only from `~/.claude/skills/`. A skill in `~/.agents/skills/` is not available in Claude Code until a symbolic link (a "link") to it is in `~/.claude/skills/`.

## When you need this skill

Use this skill for skills that have no link:

- Skills that you put in `~/.agents/skills/` manually. For example, a skill that you wrote, copied, or cloned with Git.
- Skills that you installed with `npx skills add` for other agents only.

For each such skill, this skill puts a link in `~/.claude/skills/`. It also removes its own links to skills that are no longer in `~/.agents/skills/`.

## Install

Requirements: macOS or Linux, Node.js, and Claude Code.

```sh
npx skills add larsbogerd/sync-agent-skills -g
```

When the command asks for the agents, select Claude Code.

To get a new version of the skill:

```sh
npx skills update sync-agent-skills -g
```

## Use

After you add a skill to `~/.agents/skills/` or remove one, tell Claude "sync skills". You can also run `/sync-agent-skills`.

To run the sync without Claude:

```sh
sh ~/.claude/skills/sync-agent-skills/scripts/sync.sh
```

The script writes one line for each skill. A skill is a folder that contains a `SKILL.md` file. The script ignores other folders.

| Status    | Meaning                                                                       |
|-----------|-------------------------------------------------------------------------------|
| `linked`  | The script made a new link.                                                   |
| `relink`  | The link was not the absolute path to the skill in `~/.agents/skills/`. The script changed it. |
| `ok`      | The link is correct. The script did not change it.                            |
| `skip`    | A real folder with that name is in `~/.claude/skills/`. The script did not change it. |
| `plugin`  | An installed Claude Code plugin has a skill with that name. The script did not make a link, and removed the link if there was one. |
| `removed` | The skill is no longer in `~/.agents/skills/`. The script removed its link.   |

Claude Code monitors `~/.claude/skills/`. Changes usually appear in the running session. If a change does not appear, run `/reload-skills` or start a new session.
