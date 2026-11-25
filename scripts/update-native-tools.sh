#!/usr/bin/env bash
set -euo pipefail

failed=0

run_update() {
    local label="$1"
    shift
    echo "==> Updating $label..."
    if ! "$@"; then
        echo "warn: failed to update $label" >&2
        failed=1
    fi
}

if [ -x "$HOME/.local/bin/codex" ]; then
    run_update "codex" "$HOME/.local/bin/codex" update
fi

if [ -x "$HOME/.local/bin/claude" ]; then
    run_update "claude" "$HOME/.local/bin/claude" update
fi

if [ -x "$HOME/.local/bin/agy" ]; then
    run_update "agy" "$HOME/.local/bin/agy" update
fi

if [ -x "$HOME/.local/bin/omp" ]; then
    run_update "omp" "$HOME/.local/bin/omp" update
    run_update "omp plugins" "$HOME/.local/bin/omp" update --plugins
fi

if [ -x "$HOME/.local/share/google-cloud-sdk/bin/gcloud" ]; then
    run_update "gcloud" "$HOME/.local/share/google-cloud-sdk/bin/gcloud" components update --quiet
fi

if [ -f "$HOME/.antidote/antidote.zsh" ] && command -v zsh >/dev/null 2>&1; then
    run_update "antidote bundles" zsh -c 'source "$HOME/.antidote/antidote.zsh" && antidote update --bundles'
fi

if [ -x "$HOME/.tmux/plugins/tpm/bin/update_plugins" ]; then
    run_update "tmux plugins" "$HOME/.tmux/plugins/tpm/bin/update_plugins" all
fi

exit "$failed"
