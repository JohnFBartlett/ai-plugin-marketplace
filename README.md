# ai-plugin-marketplace

Public Claude Code marketplace for JFB project helpers.

## Plugins

| Plugin | Description |
|---|---|
| `project-manager` | Cross-repo PM helper: `/pm-all` (full sweep), or individually `/pm-overview`, `/pm-roadmap`, `/pm-standup`, `/pm-doc-audit`, `/pm-doc-archive`, `/pm-pitch`. |

## Install — cloud sessions (Claude Code on the web)

Set the default environment's setup script to:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/johnfbartlett/ai-plugin-marketplace/main/setup/install.sh)
```

`install.sh` clones this repo and copies each enabled plugin's `SKILL.md` and `commands/*.md` into `~/.claude/skills/` and `~/.claude/commands/`. Idempotent — re-runs fast-forward the marketplace and refresh installed files.

The cloud env doesn't support the `/plugin` slash command, so we bypass the plugin runtime and write skills/commands directly. The marketplace/plugin manifests still exist for use in local sessions where `/plugin` works.

To change which plugins auto-install, edit `PLUGINS_TO_INSTALL` in `setup/install.sh` and push to `main`.

## Install — local sessions (desktop / IDE)

Local Claude Code sessions DO support `/plugin`. Run once:

```
/plugin marketplace add johnfbartlett/ai-plugin-marketplace
/plugin install project-manager@jfb-marketplace
```

Or merge `settings/local-settings.json.example` into `~/.claude/settings.json` for auto-enable.

## Layout

```
.claude-plugin/marketplace.json       Marketplace manifest (used by local /plugin)
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
3. To auto-install in cloud envs, add the name to `PLUGINS_TO_INSTALL` in `setup/install.sh`.
4. For local sessions, also add it to `enabledPlugins` in `settings/local-settings.json.example`.

## Development

Test the marketplace locally without pushing:

```
/plugin marketplace add /path/to/ai-plugin-marketplace
/plugin install project-manager@jfb-marketplace
```
