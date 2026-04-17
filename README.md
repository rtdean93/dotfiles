# dotfiles

Shell environment for macOS and Linux — starship prompt, oh-my-zsh, common aliases.

## What's included

| File | Purpose |
|------|---------|
| `zshrc` | Zsh config (oh-my-zsh + starship) |
| `starship.toml` | Prompt: multi-line, git status, language versions |
| `aliases` | Common git/nav/network shortcuts |
| `install.sh` | Symlinks files + installs dependencies |
| `setup.sh` | One-liner bootstrap for new servers |

## New server (one command)

```bash
curl -fsSL https://raw.githubusercontent.com/rtdean93/dotfiles/main/setup.sh | bash
```

Or with SSH access to the repo:

```bash
DOTFILES_REPO=git@github.com:rtdean93/dotfiles.git \
  curl -fsSL https://raw.githubusercontent.com/rtdean93/dotfiles/main/setup.sh | bash
```

## Already have the repo cloned?

```bash
cd ~/dotfiles
bash install.sh
```

Skip dependency installation (already set up):

```bash
bash install.sh --skip-deps
```

## Manual steps

```bash
git clone https://github.com/rtdean93/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash install.sh
exec zsh
```

## Supported systems

- Ubuntu / Debian (apt)
- CentOS / RHEL / Fedora (dnf / yum)
- Alpine (apk)
- Arch (pacman)
- macOS (brew)

## Prompt preview

```
~/NoLimitzLab/SWE-AF on ⌥main !(2) via 🐍 v3.12.6
|→ _
```

- **Directory** — bold cyan, truncated to 3 segments
- **Branch** — `⌥branch-name` in yellow
- **Git status** — red indicators for modified/staged/untracked
- **Language** — Python, Node, Go, Rust version shown automatically
- **Arrow** — `|→` green on success, red on error

## Updating

```bash
cd ~/dotfiles
git pull
# symlinks already point here, no reinstall needed
```
