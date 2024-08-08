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

# GPG
gpgconf --kill scdaemon # only for openbsd
gpg --edit-card # enter: fetch

# change shell to zsh
chsh -s $(which zsh)

# void: enable services and setup pam_rundir
sudo ln -s /etc/srv/alsa /var/service
sudo ln -s /etc/srv/dhcpcd /var/service
sudo ln -s /etc/srv/pcscd /var/service
sudo ln -s /etc/srv/polkitd /var/service
sudo ln -s /etc/srv/wpa_supplicant /var/service
echo "session         optional        pam_rundir.so" | sudo tee -a /etc/pam.d/login

# openbsd: enable rcctls
doas rcctl enable apmd
doas rcctl start apmd
doas rcctl enable pcscd
doas rcctl start pcscd 

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

## Post-installation

### Linux

- [WhiteSur cursors](https://github.com/vinceliuice/WhiteSur-cursors/tree/master) are not automatically installed
- easyeffects/pulseaudio for x1
