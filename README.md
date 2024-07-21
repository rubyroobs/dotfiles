# dotfiles

macOS, Linux and OpenBSD dotfiles! very heavily personalized to my usage but feel free to copy/remix~

## Installation

Bootstrap with `brew` or the `install.sh` script, setup with `chezmoi`

```shell
# macOS specific
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install chezmoi

# init
chezmoi init rubyroobs

# macOS: enable services
brew services start borders
brew services start sketchybar
```

After setting up `op` (1Password CLI), get yubikey private keys tubs and generate secrets from templates:

```shell
for secretFile in \
    $HOME/.config/gh/hosts.yml \
    $HOME/.config/git/credentials ; do
    op_update_secret_from_template $secretFile
done

for yubikeyHandle in \
    5AN_562_fox \
    5AT_825_mona \
    5CNF_636_joker \
    5CN_104_skull \
    5CTF_544_panther ; do
    op_download_ssh_key $yubikeyHandle
done
```