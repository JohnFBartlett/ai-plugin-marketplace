#!/usr/bin/env bash
# Cloud environment setup script for Claude Code on the web.
#
# Configures every new session in this environment to know about the JFB
# plugin marketplace and to auto-enable the project-manager plugin.
#
# This script is idempotent: re-running it is safe.
#
# Wire it into your default environment by pointing the env's
# "setup script" (or post-clone hook) at:
#   bash <(curl -fsSL https://raw.githubusercontent.com/johnfbartlett/ai-plugin-marketplace/main/setup/install.sh)
# or, when the marketplace repo is cloned into the env:
#   bash ai-plugin-marketplace/setup/install.sh

set -euo pipefail

MARKETPLACE_NAME="jfb-marketplace"
MARKETPLACE_REPO="johnfbartlett/ai-plugin-marketplace"
PLUGINS_TO_ENABLE=(
  "project-manager"
)

SETTINGS_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
SETTINGS_FILE="$SETTINGS_DIR/settings.json"

mkdir -p "$SETTINGS_DIR"

if [ ! -f "$SETTINGS_FILE" ]; then
  echo '{}' > "$SETTINGS_FILE"
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "install.sh: jq is required but not installed. Aborting." >&2
  exit 1
fi

# Build the enabledPlugins object: { "project-manager@jfb-marketplace": true, ... }
ENABLED_JSON='{}'
for plugin in "${PLUGINS_TO_ENABLE[@]}"; do
  ENABLED_JSON=$(echo "$ENABLED_JSON" | jq --arg key "${plugin}@${MARKETPLACE_NAME}" '. + {($key): true}')
done

# Merge into settings.json: register the marketplace and enable each plugin.
TMP=$(mktemp)
jq \
  --arg name "$MARKETPLACE_NAME" \
  --arg repo "$MARKETPLACE_REPO" \
  --argjson enabled "$ENABLED_JSON" \
  '
  .extraKnownMarketplaces = ((.extraKnownMarketplaces // {}) + {
    ($name): { "source": { "source": "github", "repo": $repo } }
  })
  | .enabledPlugins = ((.enabledPlugins // {}) + $enabled)
  ' "$SETTINGS_FILE" > "$TMP"

mv "$TMP" "$SETTINGS_FILE"

echo "install.sh: registered marketplace '$MARKETPLACE_NAME' and enabled: ${PLUGINS_TO_ENABLE[*]}"
echo "install.sh: settings file -> $SETTINGS_FILE"
