#!/usr/bin/env bash
# setup.sh — one-shot bootstrap for new Linux servers
#
# Clones the dotfiles repo and runs install.sh.
# Can also be piped directly: curl -fsSL <raw-url>/setup.sh | bash
#
# Usage:
#   bash setup.sh                     # full setup
#   bash setup.sh --skip-deps         # symlinks only (deps already installed)
#   DOTFILES_REPO=git@... bash setup.sh  # use a custom repo URL

set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'
info()    { echo -e "${CYAN}[info]${RESET} $*"; }
success() { echo -e "${GREEN}[done]${RESET} $*"; }
warn()    { echo -e "${YELLOW}[warn]${RESET} $*"; }
die()     { echo -e "${RED}[error]${RESET} $*" >&2; exit 1; }

# ── config ────────────────────────────────────────────────────────────────────
DOTFILES_REPO="${DOTFILES_REPO:-https://github.com/rtdean93/dotfiles.git}"
DOTFILES_BRANCH="${DOTFILES_BRANCH:-main}"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
INSTALL_ARGS=("$@")

# ── bootstrap curl/git if missing ─────────────────────────────────────────────
ensure_bootstrap_deps() {
  local missing=()
  command -v curl &>/dev/null || missing+=(curl)
  command -v git  &>/dev/null || missing+=(git)
  [[ ${#missing[@]} -eq 0 ]] && return

  info "Installing bootstrap dependencies: ${missing[*]}"
  if   command -v apt-get &>/dev/null; then sudo apt-get update -qq && sudo apt-get install -y -q "${missing[@]}"
  elif command -v dnf     &>/dev/null; then sudo dnf install -y -q "${missing[@]}"
  elif command -v yum     &>/dev/null; then sudo yum install -y -q "${missing[@]}"
  elif command -v apk     &>/dev/null; then sudo apk add --no-cache -q "${missing[@]}"
  elif command -v pacman  &>/dev/null; then sudo pacman -Sy --noconfirm "${missing[@]}"
  else die "Cannot install ${missing[*]}: no supported package manager found"
  fi
}

# ── clone or update dotfiles ──────────────────────────────────────────────────
get_dotfiles() {
  if [[ -d "$DOTFILES_DIR/.git" ]]; then
    info "Dotfiles already cloned, pulling latest..."
    git -C "$DOTFILES_DIR" fetch origin
    git -C "$DOTFILES_DIR" checkout "$DOTFILES_BRANCH"
    git -C "$DOTFILES_DIR" pull --ff-only origin "$DOTFILES_BRANCH"
  else
    info "Cloning dotfiles from $DOTFILES_REPO (branch: $DOTFILES_BRANCH)..."
    git clone -b "$DOTFILES_BRANCH" "$DOTFILES_REPO" "$DOTFILES_DIR"
  fi
  success "Dotfiles at $DOTFILES_DIR"
}

# ── main ──────────────────────────────────────────────────────────────────────
echo -e "\n${BOLD}${CYAN}╔══════════════════════════════════════╗${RESET}"
echo -e "${BOLD}${CYAN}║     Shell Environment Bootstrap      ║${RESET}"
echo -e "${BOLD}${CYAN}╚══════════════════════════════════════╝${RESET}\n"

ensure_bootstrap_deps
get_dotfiles

info "Running installer..."
bash "$DOTFILES_DIR/install.sh" "${INSTALL_ARGS[@]}"
