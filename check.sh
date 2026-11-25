#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
export MISE_TRUSTED_CONFIG_PATHS="${MISE_TRUSTED_CONFIG_PATHS:+$MISE_TRUSTED_CONFIG_PATHS:}$repo_root/.config/mise"

bash -n "$repo_root/bootstrap.sh" "$repo_root/check.sh" "$repo_root"/scripts/*.sh
zsh -n "$repo_root/groups/common/dot-zshrc" "$repo_root/groups/common/dot-zprofile"

while IFS= read -r file; do
    jq empty "$file"
done < <(find "$repo_root/groups" "$repo_root/edits" -type f -name '*.json' | sort)

while IFS= read -r file; do
    python3 -c 'import sys, tomllib; tomllib.loads(open(sys.argv[1]).read())' "$file"
done < <(find "$repo_root/.config/mise" "$repo_root/groups" "$repo_root/edits" -type f -name '*.toml' | sort)

if command -v mise >/dev/null 2>&1; then
    for env_name in personal corp; do
        MISE_CONFIG_DIR="$repo_root/.config/mise" MISE_ENV="$env_name" mise config ls >/dev/null
    done
fi
