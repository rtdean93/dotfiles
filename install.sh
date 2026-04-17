#!/usr/bin/env bash
# install.sh — symlink dotfiles and install dependencies
# Run this after cloning the repo.
# Usage: bash install.sh [--skip-deps]

set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'
info()    { echo -e "${CYAN}[info]${RESET} $*"; }
success() { echo -e "${GREEN}[done]${RESET} $*"; }
warn()    { echo -e "${YELLOW}[warn]${RESET} $*"; }
die()     { echo -e "${RED}[error]${RESET} $*" >&2; exit 1; }

SKIP_DEPS=false
for arg in "$@"; do [[ "$arg" == "--skip-deps" ]] && SKIP_DEPS=true; done

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

command_exists() { command -v "$1" &>/dev/null; }

# ── detect package manager ────────────────────────────────────────────────────
detect_pm() {
  if   command_exists apt-get; then echo "apt"
  elif command_exists dnf;     then echo "dnf"
  elif command_exists yum;     then echo "yum"
  elif command_exists apk;     then echo "apk"
  elif command_exists pacman;  then echo "pacman"
  elif command_exists brew;    then echo "brew"
  else echo "unknown"
  fi
}

pkg_install() {
  local pm=$1; shift
  case "$pm" in
    apt)    sudo apt-get install -y -q "$@" ;;
    dnf)    sudo dnf install -y -q "$@" ;;
    yum)    sudo yum install -y -q "$@" ;;
    apk)    sudo apk add --no-cache -q "$@" ;;
    pacman) sudo pacman -Sy --noconfirm "$@" ;;
    brew)   brew install "$@" ;;
  esac
}

# ── install dependencies ──────────────────────────────────────────────────────
install_deps() {
  local pm
  pm=$(detect_pm)
  info "Detected package manager: $pm"

  if [[ "$pm" == "unknown" ]]; then
    warn "No known package manager. Install zsh, git, curl manually then re-run."
    return
  fi

  [[ "$pm" == "apt" ]] && sudo apt-get update -qq

  info "Installing zsh, git, curl..."
  case "$pm" in
    brew)   brew list zsh &>/dev/null || pkg_install brew zsh ;;
    *)      pkg_install "$pm" zsh git curl ;;
  esac

  # oh-my-zsh
  if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    info "Installing oh-my-zsh..."
    RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
      sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    success "oh-my-zsh installed"
  else
    info "oh-my-zsh already present"
  fi

  # starship
  if ! command_exists starship; then
    info "Installing starship..."
    curl -sS https://starship.rs/install.sh | sh -s -- --yes
    success "Starship installed"
  else
    info "Starship already present: $(starship --version)"
  fi

  # Set zsh as default shell
  local zsh_path
  zsh_path=$(command -v zsh)
  if [[ "$SHELL" != "$zsh_path" ]]; then
    if ! grep -qx "$zsh_path" /etc/shells 2>/dev/null; then
      echo "$zsh_path" | sudo tee -a /etc/shells > /dev/null
    fi
    chsh -s "$zsh_path" 2>/dev/null && success "Default shell set to zsh" \
      || warn "Could not set default shell. Run: chsh -s $zsh_path"
  fi
}

# ── symlink files ─────────────────────────────────────────────────────────────
symlink() {
  local src="$1" dst="$2"
  local dst_dir
  dst_dir=$(dirname "$dst")

  mkdir -p "$dst_dir"

  if [[ -e "$dst" && ! -L "$dst" ]]; then
    mkdir -p "$BACKUP_DIR"
    info "Backing up existing $(basename "$dst") → $BACKUP_DIR/"
    mv "$dst" "$BACKUP_DIR/"
  elif [[ -L "$dst" ]]; then
    rm "$dst"
  fi

  ln -s "$src" "$dst"
  success "Linked $dst → $src"
}

# ── main ──────────────────────────────────────────────────────────────────────
echo -e "\n${BOLD}${CYAN}Dotfiles installer${RESET}\n"

[[ "$SKIP_DEPS" == false ]] && install_deps

symlink "$DOTFILES_DIR/zshrc"        "$HOME/.zshrc"
symlink "$DOTFILES_DIR/starship.toml" "${XDG_CONFIG_HOME:-$HOME/.config}/starship.toml"
symlink "$DOTFILES_DIR/aliases"      "$HOME/.aliases"

echo -e "\n${BOLD}${GREEN}✓ Done!${RESET}"
echo -e "  Start a new shell or run: ${BOLD}exec zsh${RESET}\n"
