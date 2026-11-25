#!/usr/bin/env bash
set -euo pipefail

HTTPS_ORIGIN="https://github.com/rubyroobs/dotfiles.git"
SSH_ORIGIN="git@github.com:rubyroobs/dotfiles.git"

ENV_NAME="${1:-}"
if [ -z "$ENV_NAME" ]; then
    read -r -p "Machine environment (personal/corp) [personal]: " ENV_NAME
    ENV_NAME="${ENV_NAME:-personal}"
fi

case "$ENV_NAME" in
    personal|corp) ;;
    *)
        echo "error: expected 'personal' or 'corp', got '$ENV_NAME'" >&2
        exit 1
        ;;
esac

export PATH="$HOME/.local/bin:$PATH"
if ! command -v mise >/dev/null 2>&1; then
    curl -fsSL https://mise.run | sh
fi

if [ ! -d "$HOME/.dotfiles/.git" ]; then
    git clone "$HTTPS_ORIGIN" "$HOME/.dotfiles"
fi

FROM_URL="$(git -C "$HOME/.dotfiles" remote get-url origin)"
printf 'env = ["%s"]\n' "$ENV_NAME" > "$HOME/.dotfiles/.config/mise/miserc.local.toml"

mise bootstrap \
    --from "$FROM_URL" \
    --from-dir "$HOME/.dotfiles" \
    --config-dir .config/mise

if [ "$FROM_URL" != "$SSH_ORIGIN" ]; then
    git -C "$HOME/.dotfiles" remote set-url origin "$SSH_ORIGIN"
fi

if GIT_SSH_COMMAND="ssh -o BatchMode=yes -o ConnectTimeout=5" git -C "$HOME/.dotfiles" ls-remote --exit-code origin HEAD >/dev/null 2>&1; then
    echo "Verified SSH origin ($SSH_ORIGIN)."
else
    echo "Switched origin to $SSH_ORIGIN, but SSH auth is not ready yet."
    echo "Insert your GPG smartcard, run 'gpg --edit-card' (enter: fetch), then verify with:"
    echo "  git -C ~/.dotfiles ls-remote origin HEAD"
fi
