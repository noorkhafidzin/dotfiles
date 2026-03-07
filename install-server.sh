#!/bin/bash

# =============================================================================
#  Auto Installer: Zsh + Oh-My-Zsh + Plugins + fzf + tmux
#  Usage: sh -c "$(curl -fsSL https://raw.githubusercontent.com/noorkhafidzin/dotfiles/master/install-server.sh)"
# =============================================================================

set -e

# --- Warna Output ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# --- Konfigurasi Repository ---
# Ganti dengan username dan nama repo GitHub kamu
GITHUB_USER="noorkhafidzin"
GITHUB_REPO="dotfiles"
GITHUB_BRANCH="master"
RAW_BASE="https://raw.githubusercontent.com/${GITHUB_USER}/${GITHUB_REPO}/refs/heads/${GITHUB_BRANCH}"

# -------------------------------------------------------
log()     { echo -e "${GREEN}${BOLD}[✔]${RESET} $1"; }
info()    { echo -e "${CYAN}${BOLD}[➜]${RESET} $1"; }
warn()    { echo -e "${YELLOW}${BOLD}[!]${RESET} $1"; }
error()   { echo -e "${RED}${BOLD}[✘]${RESET} $1"; exit 1; }
section() { echo -e "\n${BOLD}${CYAN}━━━ $1 ━━━${RESET}\n"; }
# -------------------------------------------------------

echo -e "${BOLD}"
cat << 'EOF'
  ____       _                    ___           _        _ _
 / ___|  ___| |_ _   _ _ __     |_ _|_ __  ___| |_ __ _| | |
 \___ \ / _ \ __| | | | '_ \     | || '_ \/ __| __/ _` | | |
  ___) |  __/ |_| |_| | |_) |    | || | | \__ \ || (_| | | |
 |____/ \___|\__|\__,_| .__/    |___|_| |_|___/\__\__,_|_|_|
                       |_|
EOF
echo -e "${RESET}"

# ─── 1. Update & Install Zsh ──────────────────────────────────────────────────
section "Install Zsh"

if command -v zsh &>/dev/null; then
  warn "zsh sudah terinstall: $(zsh --version)"
else
  info "Menginstall zsh..."
  sudo apt update -qq
  sudo apt install -y zsh
  log "zsh berhasil diinstall."
fi

# ─── 2. Install Oh-My-Zsh ─────────────────────────────────────────────────────
section "Install Oh-My-Zsh"

if [ -d "$HOME/.oh-my-zsh" ]; then
  warn "Oh-My-Zsh sudah ada di $HOME/.oh-my-zsh, melewati..."
else
  info "Menginstall Oh-My-Zsh..."
  RUNZSH=no CHSH=no sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  log "Oh-My-Zsh berhasil diinstall."
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# ─── 3. Install Plugin: zsh-autosuggestions ───────────────────────────────────
section "Plugin: zsh-autosuggestions"

PLUGIN_DIR="$ZSH_CUSTOM/plugins/zsh-autosuggestions"
if [ -d "$PLUGIN_DIR" ]; then
  warn "zsh-autosuggestions sudah ada, melewati..."
else
  info "Menginstall zsh-autosuggestions..."
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$PLUGIN_DIR"
  log "zsh-autosuggestions berhasil diinstall."
fi

# ─── 4. Install Plugin: zsh-syntax-highlighting ───────────────────────────────
section "Plugin: zsh-syntax-highlighting"

PLUGIN_DIR="$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
if [ -d "$PLUGIN_DIR" ]; then
  warn "zsh-syntax-highlighting sudah ada, melewati..."
else
  info "Menginstall zsh-syntax-highlighting..."
  git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting "$PLUGIN_DIR"
  log "zsh-syntax-highlighting berhasil diinstall."
fi

# ─── 5. Install Plugin: zsh-completions ───────────────────────────────────────
section "Plugin: zsh-completions"

PLUGIN_DIR="$ZSH_CUSTOM/plugins/zsh-completions"
if [ -d "$PLUGIN_DIR" ]; then
  warn "zsh-completions sudah ada, melewati..."
else
  info "Menginstall zsh-completions..."
  git clone --depth=1 https://github.com/zsh-users/zsh-completions "$PLUGIN_DIR"
  log "zsh-completions berhasil diinstall."
fi

# ─── 6. Install fzf ───────────────────────────────────────────────────────────
section "Install fzf"

if [ -d "$HOME/.fzf" ]; then
  warn "fzf sudah ada di $HOME/.fzf, melewati..."
else
  info "Menginstall fzf..."
  git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
  "$HOME/.fzf/install" --all --no-bash --no-fish
  log "fzf berhasil diinstall."
fi

# ─── 7. Install tmux ──────────────────────────────────────────────────────────
section "Install tmux"

if command -v tmux &>/dev/null; then
  warn "tmux sudah terinstall: $(tmux -V)"
else
  info "Menginstall tmux..."
  sudo apt install -y tmux
  log "tmux berhasil diinstall."
fi

# ─── 8. Download .zshrc & .tmux.conf dari GitHub ─────────────────────────────
section "Mengunduh Konfigurasi dari GitHub"

info "Mengunduh .zshrc dari ${GITHUB_USER}/${GITHUB_REPO}..."
if curl -fsSL "${RAW_BASE}/zsh-server/.zshrc" -o "$HOME/.zshrc"; then
  log ".zshrc berhasil diunduh."
else
  warn "Gagal mengunduh .zshrc. Periksa GITHUB_USER dan GITHUB_REPO di script ini."
fi

info "Mengunduh .tmux.conf dari ${GITHUB_USER}/${GITHUB_REPO}..."
if curl -fsSL "${RAW_BASE}/tmux/.tmux.conf" -o "$HOME/.tmux.conf"; then
  log ".tmux.conf berhasil diunduh."
else
  warn "Gagal mengunduh .tmux.conf. Periksa GITHUB_USER dan GITHUB_REPO di script ini."
fi

# ─── 9. Set Zsh sebagai Default Shell ─────────────────────────────────────────
section "Set Default Shell ke Zsh"

if [ "$SHELL" = "$(which zsh)" ]; then
  warn "Zsh sudah menjadi default shell."
else
  info "Mengubah default shell ke zsh..."
  chsh -s "$(which zsh)"
  log "Default shell berhasil diubah ke zsh."
fi

# ─── Selesai ──────────────────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}${BOLD}╔══════════════════════════════════════════════╗${RESET}"
echo -e "${GREEN}${BOLD}║     ✅  Instalasi Selesai dengan Sukses!     ║${RESET}"
echo -e "${GREEN}${BOLD}╚══════════════════════════════════════════════╝${RESET}"
echo ""
echo -e "  ${CYAN}Langkah selanjutnya:${RESET}"
echo -e "  ${BOLD}1.${RESET} Logout dan login kembali, atau jalankan: ${YELLOW}exec zsh${RESET}"
echo -e "  ${BOLD}2.${RESET} Untuk tmux, jalankan: ${YELLOW}tmux${RESET}"
echo ""
echo -e "  ${BOLD}Tools yang terinstall:${RESET}"
echo -e "   • zsh $(zsh --version 2>/dev/null | head -1)"
echo -e "   • Oh-My-Zsh"
echo -e "   • zsh-autosuggestions"
echo -e "   • zsh-syntax-highlighting"
echo -e "   • zsh-completions"
echo -e "   • fzf"
echo -e "   • tmux $(tmux -V 2>/dev/null)"
echo ""
