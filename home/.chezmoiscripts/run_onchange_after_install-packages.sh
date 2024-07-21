#!/bin/bash

# asdf plugins
if [ -f "$HOME/.asdf/asdf.sh" ]; then
    . $HOME/.asdf/asdf.sh
    for pluginName in \
        ruby \
        golang \
        nodejs \
        yarn \
        golang \
        shellcheck ; do
        asdf plugin add $pluginName >/dev/null 2>&1
    done
fi

# rustup
if [ ! -f "$HOME/.cargo/bin/rustup" ]; then
    echo "Installing rustup..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi

# fonts
#
# force BSD tar
TAR_BIN=`command -v tar 2>&1`
if command -v bsdtar > /dev/null 2>&1; then
    TAR_BIN=`command -v bsdtar 2>&1`
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
  FONT_DIR="$HOME/Library/Fonts"
else
  FONT_DIR="$HOME/.fonts"
  SYS_FONT_DIR="/usr/share/fonts/"
fi

if [ ! -d "$FONT_DIR/zpix" ]; then
    echo "Installing zpix font..."
    mkdir -p $FONT_DIR/zpix
    curl -o $FONT_DIR/zpix/zpix.ttf https://github.com/SolidZORO/zpix-pixel-font/releases/latest/download/zpix.ttf
    curl -o $FONT_DIR/zpix/zpix.bdf https://github.com/SolidZORO/zpix-pixel-font/releases/latest/download/zpix.bdf
fi

if [ ! -d "$FONT_DIR/PixelMplus-20130602" ]; then
    echo "Installing PixelMplus font... (this might fail without unzip installed)"
    curl -sL "https://github.com/itouhiro/PixelMplus/releases/download/v1.0.0/PixelMplus-20130602.zip" | $TAR_BIN xvf - -C $FONT_DIR
fi

if [ ! -d "$FONT_DIR/DejaVuSansMono" ]; then
    echo "Installing DejaVu Sans Mono font..."
    mkdir -p $FONT_DIR/DejaVuSansMono
    curl -sL "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/DejaVuSansMono.tar.xz" | $TAR_BIN xvf - -C $FONT_DIR/DejaVuSansMono
fi

if [ ! -d "$FONT_DIR/JetBrainsMono" ]; then
    echo "Installing JetBrains Mono font..."
    mkdir -p $FONT_DIR/JetBrainsMono
    curl -sL "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz" | $TAR_BIN xvf - -C $FONT_DIR/JetBrainsMono
fi

if [ ! -d "$FONT_DIR/Noto" ]; then
    echo "Installing Noto font..."
    mkdir -p $FONT_DIR/Noto
    curl -sL "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Noto.tar.xz" | $TAR_BIN xvf - -C $FONT_DIR/Noto
fi

unamestr=$(uname)
if [[ "$unamestr" == "Linux" || "$unamestr" == *"BSD" ]]; then
    sudo cp -R ~/.fonts/* /usr/share/fonts/
    sudo mkfontscale /usr/share/fonts/*
    sudo mkfontdir /usr/share/fonts/*
fi

echo "Rebuilding font cache..."
fc-cache -f

# macOS application and sketchybar helper bootstrap
if [[ "$OSTYPE" == "darwin"* ]]; then
    if [ ! -f "/Applications/kitty.app/Contents/MacOS/kitty" ]; then
        echo "Installing bootstrap applications (to stop this in future applies, make sure kitty is installed)..."
        brew bundle --verbose --no-lock --file=$HOME/.config/homebrew/Brewfile.bootstrap
    fi

    if [ ! -f "$HOME/.local/share/sketchybar_lua/sketchybar.so" ]; then
        echo "Installing SbarLua (Sketchybar Lua helpers)..."
        git clone https://github.com/FelixKratz/SbarLua.git /tmp/SbarLua && cd /tmp/SbarLua/ && make install && rm -rf /tmp/SbarLua/
    fi
fi
