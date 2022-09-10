# github.com/rubyroobs/dotfiles

Personal dotfiles. Managed with [chezmoi](https://www.chezmoi.io/). Heavily inspired by [twpayne's chezmoi setup](https://github.com/twpayne/dotfiles). Secrets are stored in [1Password](https://1password.com/) and managed with the [1Password CLI](https://1password.com/downloads/command-line/). Feel free to use or remix for your own setup.

## Usage (macOS)

Bootstrap with `brew`, setup with `chezmoi`

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install chezmoi
brew install --cask 1password 1password-cli
# Setup 1Password for secrets
chezmoi init rubyroobs
```

Additional installations:

```
# rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path

# GnuPG setup
op document get 4s7zgzzdy3rknmd2sucyh2edeq | gpg --import
op document get hu5n2ec5nwf7odaqhminxmuhke | gpg --allow-secret-key --import
```