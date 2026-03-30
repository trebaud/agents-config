#!/usr/bin/env bash
set -euo pipefail

SOURCE_DIR="$HOME/.agents/skills"
TARGETS=(
  "$HOME/.claude/skills"
  "$HOME/.opencode/skills"
)

if [[ ! -d "$SOURCE_DIR" ]]; then
  echo "Error: source directory $SOURCE_DIR does not exist" >&2
  exit 1
fi

for target_dir in "${TARGETS[@]}"; do
  mkdir -p "$target_dir"

  # Remove stale symlinks pointing to skills that no longer exist in source
  for link in "$target_dir"/*/; do
    [[ -L "${link%/}" ]] || continue
    link="${link%/}"
    name="$(basename "$link")"
    if [[ ! -d "$SOURCE_DIR/$name" ]]; then
      echo "removing stale symlink: $link"
      rm "$link"
    fi
  done

  # Create or update symlinks for each skill
  for skill in "$SOURCE_DIR"/*/; do
    [[ -d "$skill" ]] || continue
    name="$(basename "$skill")"
    link="$target_dir/$name"

    if [[ -L "$link" ]]; then
      current="$(readlink "$link")"
      if [[ "$current" == "$skill" || "$current" == "${skill%/}" ]]; then
        continue
      fi
      echo "updating symlink: $link"
      rm "$link"
    elif [[ -e "$link" ]]; then
      echo "warning: $link exists and is not a symlink, skipping" >&2
      continue
    fi

    ln -s "${skill%/}" "$link"
    echo "linked: $link -> ${skill%/}"
  done
done
