# dotfiles

personalized dotfiles, simplified for how I currently use my computers~

## Installation

Bootstrap with `brew` or the `install.sh` script, setup with `chezmoi`

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install chezmoi
chezmoi init rubyroobs
gpg --edit-card # enter: fetch
```

After setting up `op` (1Password CLI), get yubikey private keys stubs and generate secrets from templates:

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
    5CTF_544_panther \
    5AN_009_queen ; do
    op_download_ssh_key $yubikeyHandle
done
```

## TODOs

- [ ] Auto sorting for package lists (for now `for file in Brewfile.tmpl Brewfile.bootstrap.tmpl ; do sort -o $HOME/.local/share/chezmoi/home/private_dot_config/packages/$file{,}; done`)

