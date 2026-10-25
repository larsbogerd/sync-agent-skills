# sync-agent-skills

A Claude Code skill that makes skills installed with `npx skills` usable in Claude Code.

`npx skills` installs to `~/.agents/skills/`, but Claude Code reads `~/.claude/skills/`. This skill puts a symlink in `~/.claude/skills/` for each skill in `~/.agents/skills/` and removes links to skills you have uninstalled.

## Install (once per Mac)

```sh
git clone https://github.com/larsbogerd/sync-agent-skills.git ~/Localdocs/dev/sync-agent-skills
sh ~/Localdocs/dev/sync-agent-skills/install.sh
```

`install.sh` links `skills/sync-agent-skills` into `~/.claude/skills/` and runs a first sync. Because it is a link, `git pull` updates the skill. Do not move or delete the clone after installing.

## Use

After `npx skills add <package>` or `npx skills remove <name>`, tell Claude "sync skills" or run `/sync-agent-skills`. Without Claude:

```sh
sh ~/.claude/skills/sync-agent-skills/scripts/sync.sh
```

Output, one line per skill:

| Status    | Meaning                                                        |
|-----------|----------------------------------------------------------------|
| `linked`  | New link created                                               |
| `relink`  | Link pointed somewhere else and was fixed                      |
| `ok`      | Already linked                                                 |
| `skip`    | A real folder with that name exists in `~/.claude/skills/`; left alone |
| `removed` | Link to a skill that is no longer in `~/.agents/skills/`       |

Claude Code watches `~/.claude/skills/`, so changes normally show up in the running session. If one does not, run `/reload-skills` or start a new session.
