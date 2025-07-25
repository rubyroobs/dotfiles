# dotfiles

macOS, Linux and OpenBSD dotfiles! very heavily personalized to my usage but feel free to copy/remix~

## Installation

Bootstrap with `brew` or the `install.sh` script, setup with `chezmoi`

```shell
# manually install mise
curl https://mise.run | sh

# macOS specific
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install chezmoi

# init
chezmoi init rubyroobs

# GPG
gpgconf --kill scdaemon # only for openbsd
gpg --edit-card # enter: fetch

# change shell to zsh
chsh -s $(which zsh)

# setup mac like keybinds https://superuser.com/a/1197929

# void: enable services and setup pam_rundir
sudo ln -s /etc/srv/dbus /var/service
sudo ln -s /etc/srv/dhcpcd /var/service
sudo ln -s /etc/srv/elogind /var/service
sudo ln -s /etc/srv/pcscd /var/service
sudo ln -s /etc/srv/polkitd /var/service
sudo ln -s /etc/srv/wpa_supplicant /var/service
echo "session         optional        pam_rundir.so" | sudo tee -a /etc/pam.d/login
sudo usermod -a -G users ruby
sudo usermod -a -G plugdev ruby

# openbsd: enable rcctls
doas rcctl enable apmd
doas rcctl start apmd
doas rcctl enable pcscd
doas rcctl start pcscd 

# macOS: enable services
brew services start borders
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
    5CTF_544_panther \
    5AN_009_queen ; do
    op_download_ssh_key $yubikeyHandle
done
```

## Post-installation

### Linux

- [WhiteSur cursors](https://github.com/vinceliuice/WhiteSur-cursors/tree/master) are not automatically installed
- easyeffects/pulseaudio for x1

### Repo on corp laptop

```shell
git config user.name "Ruby Nealon"
git config user.email "ruby@ruby.sh"
git config user.signingkey "9421A2F39BB45E3CCF0DDB7F30C8419F45FDFD51"
git config gpg.format "openpgp"
git config gpg.program "gpg"
```

## TODOs

- [ ] Auto sorting for package lists (for now `for file in Brewfile.tmpl Brewfile.bootstrap.tmpl pkg_add.txt xbps-install.txt yay.txt; do sort -o $HOME/.local/share/chezmoi/home/private_dot_config/packages/$file{,}; done`)

