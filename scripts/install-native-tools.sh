#!/usr/bin/env bash
set -euo pipefail

mkdir -p "$HOME/.local/bin" "$HOME/.local/share"

if [ ! -x "$HOME/.local/bin/codex" ]; then
    echo "Installing codex..."
    curl -fsSL https://chatgpt.com/codex/install.sh | sh
fi

if [ ! -x "$HOME/.local/bin/claude" ]; then
    echo "Installing claude..."
    curl -fsSL https://claude.ai/install.sh | bash
fi

if [ ! -x "$HOME/.local/bin/agy" ]; then
    echo "Installing antigravity CLI (agy)..."
    curl -fsSL https://antigravity.google/cli/install.sh | bash
fi

if [ ! -x "$HOME/.local/bin/omp" ]; then
    echo "Installing omp..."
    curl -fsSL https://omp.sh/install | sh
fi

if [ ! -x "$HOME/.local/share/google-cloud-sdk/bin/gcloud" ]; then
    echo "Installing Google Cloud SDK..."
    curl -fsSL https://sdk.cloud.google.com | bash -s -- \
        --disable-prompts \
        --install-dir="$HOME/.local/share"
fi
