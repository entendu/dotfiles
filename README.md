# dotfiles

chezmoi-managed dotfiles for Dom's machines. Sibling repo to `entendu/nx01-docs` (shared Claude memory).

## Layout

- `dot_*` — home-dir files (chezmoi convention: `dot_bashrc` → `~/.bashrc`)
- `private_dot_ssh/` — SSH config (mode 600)
- `*.tmpl` — rendered by chezmoi with per-host data (hostname, OS, arch, identity)
- `Brewfile.tmpl` — Homebrew bundle for macOS
- `run_onchange_after_*` — hooks that re-run when their content changes:
  - `10-brewfile` — installs Homebrew + runs `brew bundle`
  - `20-claude-memory-symlinks` — wires `~/.claude/projects/*/memory` to `~/code/nx01-docs/memory`
  - `30-dotfiles-sync-agent` — installs launchd agent that pulls both repos + `chezmoi apply` every 10 min
- `install.sh` — bootstrap: installs chezmoi, clones both repos into `~/code/`, runs `chezmoi init`

## Bootstrap a new machine

```sh
curl -fsSL https://raw.githubusercontent.com/entendu/dotfiles/main/install.sh | bash
chezmoi apply -v
```

After that, the launchd agent keeps both repos pulled and applied every 10 minutes.

## Sync model

- **Pull-only on all machines.** Each machine pulls every 10 min and re-applies.
- **Authoring is manual.** Edit in `~/code/dotfiles/` (the chezmoi source), commit, push. Other machines pick up the change on their next pull.
- `chezmoi edit ~/.bashrc` opens the source file; `chezmoi apply` re-renders.

## Archive

The previous repo (a stale fork of geerlingguy's dotfiles) is preserved in the `archive` branch.
