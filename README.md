# dotfiles

my personal macOS dotfiles, managed with `mise dot` (`[dotfile_groups]` in copy mode) and `mise bootstrap`.

## Structure

- `.config/mise/config.toml`: shared settings and bootstrap tasks
- `.config/mise/conf.d/`: split declarative config (`tools.toml`, `packages.toml`, `dotfiles.toml`, `macos.toml`)
- `.config/mise/config.{personal,corp}.toml`: per-environment `dotfile_groups`, env vars, and optional env-only packages/tools
- `.config/mise/config.local.toml`: optional gitignored per-machine overrides (`[tools]`, `[bootstrap.packages]`, `[env]`)
- `groups/{common,corp,personal}/`: dotfiles using `dot-` prefixes, copied into `~` (no symlinks)
- `edits/codex-theme.toml`: partial TOML merge applied to `~/.codex/config.toml`
- `scripts/`: idempotent native installer (`codex`, `claude`, `agy`, `omp`, `gcloud`), font, and Dock setup scripts

## Installation

```bash
curl -fsSL https://raw.githubusercontent.com/rubyroobs/dotfiles/main/bootstrap.sh | bash -s -- personal
# or `corp` on a work laptop
gpg --edit-card # enter: fetch
```

`bootstrap.sh` installs `mise` if missing, clones this repo into `~/.dotfiles`, writes the gitignored `~/.dotfiles/.config/mise/miserc.local.toml` (`env = ["personal"]` or `env = ["corp"]`), links `~/.config/mise` to `~/.dotfiles/.config/mise`, and runs `mise bootstrap`.

`mise` installs declared `brew:` formulae directly into `/opt/homebrew` on Apple Silicon without requiring Homebrew to be pre-installed.

## Usage

```bash
# Preview all changes without modifying the machine
mise bootstrap --dry-run

# Sync repo changes and apply dotfiles, tools, packages, and defaults
mise bootstrap --update

# Preview, apply, or prune removed dotfiles
mise dot diff
mise dot apply --prune

# Pull edits made to a live file back into ~/.dotfiles
mise dot add ~/.zshrc

# Self-update mise, upgrade packages/tools/repos, and update native CLIs and plugins
mise run upgrade

# Validate repo syntax and both machine environments
./check.sh
```

## Adding software

Pick the backend first (`mise registry <name>` shows what `mise` uses):

1. **Runtimes and precompiled CLIs (`core:`, `aqua:`, `github:`):** prefer `[tools]` (avoid `vfox:` and `asdf:` plugins).
2. **System CLI tools, libraries, fonts, or macOS casks:** use `"brew:<name>" = "latest"` or `"brew-cask:<name>" = "latest"` under `[bootstrap.packages]` (`mise` installs both directly into `/opt/homebrew` without Homebrew). Third-party GitHub taps use `"brew:<owner>/<tap>/<formula>"`; add `[bootstrap.brew.taps]` only if the repo does not match `github.com/<owner>/homebrew-<tap>`.
3. **Rapidly self-updating CLIs (agent harnesses, `gcloud`):** add an idempotent install block in `scripts/install-native-tools.sh` and its updater command in `scripts/update-native-tools.sh`.

Then place the declaration by scope:

- **All machines (common):** `.config/mise/conf.d/tools.toml` or `.config/mise/conf.d/packages.toml`.
- **One environment (`personal` or `corp`):** `[tools]` or `[bootstrap.packages]` in `.config/mise/config.personal.toml` or `.config/mise/config.corp.toml`.
- **One machine only (untracked):** `[tools]` or `[bootstrap.packages]` in gitignored `.config/mise/config.local.toml`.

Apply and validate:

```bash
# Install newly added packages and tools
mise bootstrap --only packages,tools

# Or run a one-off brew/cask install without editing config
mise bootstrap packages apply brew:<formula>

# Validate before committing
./check.sh
```
