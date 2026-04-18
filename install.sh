#!/usr/bin/env bash
set -euo pipefail

REPO_DOTFILES="git@github.com:entendu/dotfiles.git"
REPO_NX01_DOCS="git@github.com:entendu/nx01-docs.git"
CODE_DIR="${HOME}/code"

echo "==> Ensuring ${CODE_DIR} exists"
mkdir -p "${CODE_DIR}"

if ! command -v chezmoi >/dev/null 2>&1; then
    echo "==> Installing chezmoi"
    if command -v brew >/dev/null 2>&1; then
        brew install chezmoi
    else
        sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "${HOME}/.local/bin"
        export PATH="${HOME}/.local/bin:${PATH}"
    fi
fi

if [[ ! -d "${CODE_DIR}/nx01-docs" ]]; then
    echo "==> Cloning nx01-docs"
    git clone "${REPO_NX01_DOCS}" "${CODE_DIR}/nx01-docs"
fi

if [[ ! -d "${CODE_DIR}/dotfiles" ]]; then
    echo "==> Cloning dotfiles"
    git clone "${REPO_DOTFILES}" "${CODE_DIR}/dotfiles"
fi

echo "==> Initializing chezmoi (source = ${CODE_DIR}/dotfiles)"
chezmoi init --source "${CODE_DIR}/dotfiles"

echo "==> Previewing changes (chezmoi diff)"
chezmoi diff || true

echo
echo "Next step: review the diff above, then run:"
echo "    chezmoi apply -v"
