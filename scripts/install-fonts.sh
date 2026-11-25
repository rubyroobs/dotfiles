#!/usr/bin/env bash
set -euo pipefail

TAR_BIN="$(command -v bsdtar 2>/dev/null || command -v tar)"

if [[ "$OSTYPE" == "darwin"* ]]; then
    FONT_DIR="$HOME/Library/Fonts"
else
    FONT_DIR="$HOME/.fonts"
fi
mkdir -p "$FONT_DIR"

installed_any=0

if [ ! -d "$FONT_DIR/zpix" ]; then
    echo "Installing zpix font..."
    mkdir -p "$FONT_DIR/zpix"
    curl -fsSL -o "$FONT_DIR/zpix/zpix.ttf" https://github.com/SolidZORO/zpix-pixel-font/releases/latest/download/zpix.ttf
    curl -fsSL -o "$FONT_DIR/zpix/zpix.bdf" https://github.com/SolidZORO/zpix-pixel-font/releases/latest/download/zpix.bdf
    installed_any=1
fi

if [ ! -d "$FONT_DIR/PixelMplus" ]; then
    echo "Installing PixelMplus font..."
    tmpdir=$(mktemp -d)
    curl -fsSL -o "$tmpdir/font.zip" "https://github.com/itouhiro/PixelMplus/releases/download/v1.0.0/PixelMplus-20130602.zip"
    7z x "$tmpdir/font.zip" -aoa -bsp0 -bso0 -y -o"$tmpdir/out"
    mkdir -p "$FONT_DIR/PixelMplus"
    install -m644 "$tmpdir"/out/PixelMplus-20130602/*.tt[fc] "$FONT_DIR/PixelMplus"
    rm -rf "$tmpdir"
    installed_any=1
fi

if [ ! -d "$FONT_DIR/DejaVuSansMono" ]; then
    echo "Installing DejaVu Sans Mono font..."
    mkdir -p "$FONT_DIR/DejaVuSansMono"
    curl -fsSL "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/DejaVuSansMono.tar.xz" | xzcat | "$TAR_BIN" xf - -C "$FONT_DIR/DejaVuSansMono"
    installed_any=1
fi

if [ ! -d "$FONT_DIR/JetBrainsMono" ]; then
    echo "Installing JetBrains Mono font..."
    mkdir -p "$FONT_DIR/JetBrainsMono"
    curl -fsSL "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz" | xzcat | "$TAR_BIN" xf - -C "$FONT_DIR/JetBrainsMono"
    installed_any=1
fi

if [ ! -d "$FONT_DIR/NotoNerdFont" ]; then
    echo "Installing Noto Nerd Font..."
    mkdir -p "$FONT_DIR/NotoNerdFont"
    curl -fsSL "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Noto.tar.xz" | xzcat | "$TAR_BIN" xf - -C "$FONT_DIR/NotoNerdFont"
    installed_any=1
fi

if [ ! -d "$FONT_DIR/Noto" ]; then
    echo "Installing Noto font..."
    tmpdir=$(mktemp -d)
    curl -fsSL -o "$tmpdir/font.zip" "https://github.com/notofonts/notofonts.github.io/archive/refs/tags/noto-monthly-release-24.8.1.zip"
    7z x "$tmpdir/font.zip" "notofonts.github.io-noto-monthly-release-24.8.1/fonts/*" -aoa -bsp0 -bso0 -y -o"$tmpdir/out"
    mkdir -p "$FONT_DIR/Noto"
    find "$tmpdir/out" -path '*/hinted/ttf/*' \( -name '*.ttf' -o -name '*.ttc' \) -exec install -m644 {} "$FONT_DIR/Noto" \;
    rm -rf "$tmpdir"
    installed_any=1
fi

if [ ! -d "$FONT_DIR/NotoCJK" ]; then
    echo "Installing Noto CJK font..."
    tmpdir=$(mktemp -d)
    curl -fsSL -o "$tmpdir/font.zip" "https://github.com/notofonts/noto-cjk/releases/download/Sans2.004/02_NotoSansCJK-TTF-VF.zip"
    7z x "$tmpdir/font.zip" -aoa -bsp0 -bso0 -y -o"$tmpdir/out"
    mkdir -p "$FONT_DIR/NotoCJK"
    find "$tmpdir/out/Variable/TTF" \( -name '*.ttf' -o -name '*.ttc' \) -exec install -m644 {} "$FONT_DIR/NotoCJK" \;
    rm -rf "$tmpdir"
    installed_any=1
fi

if [ ! -d "$FONT_DIR/MPLUS" ]; then
    echo "Installing MPLUS font..."
    tmpdir=$(mktemp -d)
    curl -fsSL -o "$tmpdir/font.zip" "https://github.com/coz-m/MPLUS_FONTS/archive/c47fd4ff0a604d1517625a0f3d67e6d64e12d585.zip"
    7z x "$tmpdir/font.zip" -aoa -bsp0 -bso0 -y -o"$tmpdir/out"
    mkdir -p "$FONT_DIR/MPLUS"
    install -m644 "$tmpdir"/out/MPLUS_FONTS-c47fd4ff0a604d1517625a0f3d67e6d64e12d585/fonts/ttf/*.tt[fc] "$FONT_DIR/MPLUS"
    rm -rf "$tmpdir"
    installed_any=1
fi

if [ ! -d "$FONT_DIR/MapleMono" ]; then
    echo "Installing Maple Mono font..."
    tmpdir=$(mktemp -d)
    curl -fsSL -o "$tmpdir/font.zip" "https://github.com/subframe7536/maple-font/releases/latest/download/MapleMono-NF.zip"
    mkdir -p "$FONT_DIR/MapleMono"
    7z x "$tmpdir/font.zip" -aoa -bsp0 -bso0 -y -o"$FONT_DIR/MapleMono"
    rm -rf "$tmpdir"
    installed_any=1
fi

if [ "$installed_any" -eq 1 ] && command -v fc-cache >/dev/null 2>&1; then
    fc-cache -f
fi
