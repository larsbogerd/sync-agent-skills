#!/bin/sh
# Link every skill in ~/.agents/skills into ~/.claude/skills and remove dead links.
# A skill is a folder that contains SKILL.md. Other folders are ignored.
# Skip skills that an installed Claude Code plugin already provides.
src="${SKILLS_SRC:-$HOME/.agents/skills}"
dst="${SKILLS_DST:-$HOME/.claude/skills}"
plugins="${SKILLS_PLUGINS:-$HOME/.claude/plugins/installed_plugins.json}"
mkdir -p "$dst"

# Print the install path of each installed plugin, one per line.
plugin_paths() {
  [ -f "$plugins" ] || return 0
  grep -o '"installPath"[[:space:]]*:[[:space:]]*"[^"]*"' "$plugins" | sed 's/.*"\([^"]*\)"$/\1/'
}

# If an installed plugin has skills/<name>/, print that plugin's path.
plugin_with_skill() {
  plugin_paths | while IFS= read -r p; do
    [ -d "$p/skills/$1" ] && { echo "$p"; break; }
  done
}

for d in "$src"/*/; do
  [ -d "$d" ] || continue
  [ -f "$d/SKILL.md" ] || continue  # not a skill (for example a sync folder)
  name=$(basename "$d")
  target="${d%/}"
  link="$dst/$name"

  p=$(plugin_with_skill "$name")
  if [ -n "$p" ]; then
    # The plugin version wins. Remove our link so the skill does not show up twice.
    if [ -L "$link" ] && [ "$(cd "$link" 2>/dev/null && pwd -P)" = "$(cd "$target" && pwd -P)" ]; then
      rm "$link"
    fi
    echo "plugin  $name (provided by plugin in $p)"
    continue
  fi

  if [ -L "$link" ]; then
    [ "$(readlink "$link")" = "$target" ] && { echo "ok      $name"; continue; }
    ln -sfn "$target" "$link" && echo "relink  $name"
  elif [ -e "$link" ]; then
    echo "skip    $name (a real folder with this name exists in $dst)"
  else
    ln -s "$target" "$link" && echo "linked  $name"
  fi
done

# Remove links that point into ~/.agents/skills but whose target is gone.
for l in "$dst"/*; do
  [ -L "$l" ] || continue
  case "$(readlink "$l")" in
    "$src"/*) [ -e "$l" ] || { rm "$l" && echo "removed $(basename "$l") (no longer in $src)"; } ;;
  esac
done
