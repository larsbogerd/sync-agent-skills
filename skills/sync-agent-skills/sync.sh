#!/bin/sh
# Link every skill in ~/.agents/skills into ~/.claude/skills and remove dead links.
src="$HOME/.agents/skills"
dst="$HOME/.claude/skills"
mkdir -p "$dst"

for d in "$src"/*/; do
  [ -d "$d" ] || continue
  name=$(basename "$d")
  target="${d%/}"
  link="$dst/$name"
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
