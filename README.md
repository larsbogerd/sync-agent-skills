# sync-agent-skills

A Claude Code skill that makes skills from `npx skills` available in Claude Code.

`npx skills` installs skills in `~/.agents/skills/`. Claude Code reads skills only from `~/.claude/skills/`. For each skill in `~/.agents/skills/`, this skill puts a symbolic link (a "link") in `~/.claude/skills/`. It also removes links to skills that are no longer in `~/.agents/skills/`.

## Install (one time on each Mac)

```sh
git clone https://github.com/larsbogerd/sync-agent-skills.git ~/Localdocs/dev/sync-agent-skills
sh ~/Localdocs/dev/sync-agent-skills/install.sh
```

`install.sh` puts a link to `skills/sync-agent-skills` in `~/.claude/skills/`. Then it runs the first sync.

The installed skill is a link to the clone. When you run `git pull` in the clone, the skill updates too. Keep the clone in the same location. If you move or remove the clone, the link breaks.

## Use

After you run `npx skills add <package>` or `npx skills remove <name>`, tell Claude "sync skills". You can also run `/sync-agent-skills`.

To run the sync without Claude:

```sh
sh ~/.claude/skills/sync-agent-skills/scripts/sync.sh
```

The script writes one line for each skill:

| Status    | Meaning                                                                       |
|-----------|-------------------------------------------------------------------------------|
| `linked`  | The script made a new link.                                                   |
| `relink`  | The link pointed to a different location. The script changed it.              |
| `ok`      | The link is correct. The script did not change it.                            |
| `skip`    | A real folder with that name is in `~/.claude/skills/`. The script did not change it. |
| `removed` | The skill is no longer in `~/.agents/skills/`. The script removed its link.   |

Claude Code monitors `~/.claude/skills/`. Changes usually appear in the running session. If a change does not appear, run `/reload-skills` or start a new session.
