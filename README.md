# ai-plugin-marketplace

Private Claude Code plugin marketplace for JFB projects.

## Plugins

| Plugin | Description |
|---|---|
| `project-manager` | Cross-repo PM helper: `/pm-all` (full sweep), or individually `/pm-overview`, `/pm-roadmap`, `/pm-standup`, `/pm-doc-audit`, `/pm-doc-archive`, `/pm-pitch`. |

## Install — cloud sessions (Claude Code on the web)

The default environment runs `setup/install.sh` on session start. The script writes `~/.claude/settings.json` to register this marketplace and enable the default plugin set.

To wire it in, point the environment's setup script at:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/johnfbartlett/ai-plugin-marketplace/main/setup/install.sh)
```

Requires `jq` in the env (Claude Code on the web envs have it by default).

To change which plugins auto-enable, edit `PLUGINS_TO_ENABLE` in `setup/install.sh`.

## Install — local sessions

Merge `settings/local-settings.json.example` into `~/.claude/settings.json`. Same effect — registers the marketplace and enables the default plugin set.

## Layout

```
.claude-plugin/marketplace.json       Marketplace manifest
plugins/<plugin-name>/
  .claude-plugin/plugin.json          Plugin manifest
  skills/<skill>/SKILL.md             Skill instructions
  commands/<cmd>.md                   Slash command definitions
setup/install.sh                      Cloud env setup script
settings/local-settings.json.example  Local user settings snippet
```

## Adding a new plugin

1. Create `plugins/<name>/` with `.claude-plugin/plugin.json`, plus `skills/` and/or `commands/`.
2. Add an entry to `.claude-plugin/marketplace.json` under `plugins`.
3. To auto-install it everywhere, add the name to `PLUGINS_TO_ENABLE` in `setup/install.sh` and to `enabledPlugins` in `settings/local-settings.json.example`.

## Development

Test the marketplace locally without pushing:

```bash
# In any Claude Code session:
/plugin marketplace add /path/to/ai-plugin-marketplace
/plugin install project-manager@jfb-marketplace
```
