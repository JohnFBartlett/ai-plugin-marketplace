# ai-plugin-marketplace

Private Claude Code plugin marketplace for JFB projects.

## Plugins

| Plugin | Description |
|---|---|
| `project-manager` | Cross-repo PM helper: `/pm-all` (full sweep), or individually `/pm-overview`, `/pm-roadmap`, `/pm-standup`, `/pm-doc-audit`, `/pm-doc-archive`, `/pm-pitch`. |

## Install — cloud sessions (Claude Code on the web)

Paste the contents of `setup/install.sh` directly into your environment's setup script field. The script writes `~/.claude/settings.json` with `extraKnownMarketplaces` + `enabledPlugins`; Claude Code fetches the marketplace contents inside the session, where GitHub creds are available.

Why inline instead of `curl | bash` or `git clone`: this repo is private, and the cloud env's setup phase runs before user secrets / GitHub creds are injected, so any fetch from GitHub during setup fails with 401/128. Inlining sidesteps the problem.

Requires `jq` in the env (Claude Code on the web envs have it preinstalled).

To change which plugins auto-enable, edit `PLUGINS_TO_ENABLE` in both `setup/install.sh` (canonical reference) and the inlined copy in your env's setup script field.

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
3. To auto-install it everywhere, add the name to `PLUGINS_TO_ENABLE` in `setup/install.sh`, to `enabledPlugins` in `settings/local-settings.json.example`, **and** to the inlined copy of `install.sh` in your cloud env's setup script field.

## Development

Test the marketplace locally without pushing:

```bash
# In any Claude Code session:
/plugin marketplace add /path/to/ai-plugin-marketplace
/plugin install project-manager@jfb-marketplace
```
