#!/usr/bin/env bash
# Cloud environment setup script for Claude Code on the web.
#
# Clones this (public) marketplace and installs the selected plugins by
# copying their skill + command files into ~/.claude/skills/ and
# ~/.claude/commands/. We bypass the plugin runtime because the cloud env
# does not support `/plugin` — but the underlying skills + commands
# directories ARE honored.
#
# Idempotent: re-running updates the marketplace and refreshes installed
# files.
#
# Wire it into your default cloud env by setting the env's setup script
# to this one-liner:
#
#   bash <(curl -fsSL https://raw.githubusercontent.com/johnfbartlett/ai-plugin-marketplace/main/setup/install.sh)
#
# To change which plugins auto-install, edit PLUGINS_TO_INSTALL below and
# push to main — every new session picks up the change.

set -euo pipefail

MARKETPLACE_REPO_URL="https://github.com/johnfbartlett/ai-plugin-marketplace.git"
MARKETPLACE_DIR="$HOME/.jfb-marketplace"
CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"

PLUGINS_TO_INSTALL=(
  "project-manager"
)

if [ ! -d "$MARKETPLACE_DIR/.git" ]; then
  git clone --depth 1 "$MARKETPLACE_REPO_URL" "$MARKETPLACE_DIR"
else
  git -C "$MARKETPLACE_DIR" fetch --depth 1 origin main
  git -C "$MARKETPLACE_DIR" reset --hard FETCH_HEAD
fi

mkdir -p "$CLAUDE_DIR/skills" "$CLAUDE_DIR/commands"

for plugin in "${PLUGINS_TO_INSTALL[@]}"; do
  PLUGIN_DIR="$MARKETPLACE_DIR/plugins/$plugin"
  if [ ! -d "$PLUGIN_DIR" ]; then
    echo "install.sh: plugin '$plugin' not found in marketplace" >&2
    exit 1
  fi

  if [ -d "$PLUGIN_DIR/skills" ]; then
    for skill_path in "$PLUGIN_DIR/skills/"*/; do
      [ -d "$skill_path" ] || continue
      skill_name=$(basename "$skill_path")
      rm -rf "$CLAUDE_DIR/skills/$skill_name"
      cp -r "$skill_path" "$CLAUDE_DIR/skills/$skill_name"
    done
  fi

  if [ -d "$PLUGIN_DIR/commands" ]; then
    for cmd_file in "$PLUGIN_DIR/commands/"*.md; do
      [ -f "$cmd_file" ] || continue
      cp "$cmd_file" "$CLAUDE_DIR/commands/$(basename "$cmd_file")"
    done
  fi

  echo "install.sh: installed $plugin"
done

echo "install.sh: done. skills -> $CLAUDE_DIR/skills, commands -> $CLAUDE_DIR/commands"
