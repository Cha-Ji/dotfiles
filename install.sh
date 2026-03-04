#!/bin/bash
# dotfiles 설치 스크립트
# 플랫폼 자동 감지: Arch Linux / WSL / macOS
# 기존 파일을 백업하고 symlink를 생성합니다.

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d_%H%M%S)"

# ─── 플랫폼 감지 ───
detect_platform() {
  if [[ -f /etc/arch-release ]]; then
    echo "arch"
  elif grep -qiE "microsoft|wsl" /proc/version 2>/dev/null; then
    echo "wsl"
  elif [[ "$(uname)" == "Darwin" ]]; then
    echo "macos"
  else
    echo "linux"
  fi
}

PLATFORM=$(detect_platform)
echo "=== Dotfiles 설치 ==="
echo "플랫폼: $PLATFORM"
echo "소스: $DOTFILES_DIR"
echo ""

backup_and_link() {
  local src="$1"
  local dest="$2"

  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    mkdir -p "$BACKUP_DIR"
    echo "  백업: $dest → $BACKUP_DIR/"
    cp -r "$dest" "$BACKUP_DIR/"
    rm -rf "$dest"
  elif [ -L "$dest" ]; then
    echo "  기존 symlink 제거: $dest"
    rm "$dest"
  fi

  mkdir -p "$(dirname "$dest")"
  ln -s "$src" "$dest"
  echo "  연결: $dest → $src"
}

# ─── 공통 (모든 플랫폼) ───

# zsh - 플랫폼별 분기
echo "[zsh]"
if [[ "$PLATFORM" == "arch" || "$PLATFORM" == "macos" ]]; then
  backup_and_link "$DOTFILES_DIR/zsh/.zshrc-standalone" "$HOME/.zshrc"
  echo "  (standalone: starship, pacman/brew 플러그인)"
else
  backup_and_link "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
  echo "  (oh-my-zsh + powerlevel10k)"
fi

# vim
echo "[vim]"
backup_and_link "$DOTFILES_DIR/vim/.vimrc" "$HOME/.vimrc"
mkdir -p "$HOME/.vim/undodir"

# starship
echo "[starship]"
backup_and_link "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship.toml"

# tmux (플랫폼 자동 감지 내장)
echo "[tmux]"
backup_and_link "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"

# nvim
echo "[nvim]"
backup_and_link "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"

# ─── WSL 전용 ───
if [[ "$PLATFORM" == "wsl" ]]; then
  # wezterm (Windows 경로에 복사 — WSL→Windows symlink 불가)
  if [ -f "$DOTFILES_DIR/wezterm/.wezterm.lua" ]; then
    echo "[wezterm] (WSL)"
    WEZTERM_DEST="/mnt/c/Users/$(cmd.exe /C echo %USERNAME% 2>/dev/null | tr -d '\r')/.wezterm.lua"
    if [ -f "$WEZTERM_DEST" ]; then
      mkdir -p "$BACKUP_DIR"
      echo "  백업: $WEZTERM_DEST → $BACKUP_DIR/"
      cp "$WEZTERM_DEST" "$BACKUP_DIR/.wezterm.lua"
    fi
    cp "$DOTFILES_DIR/wezterm/.wezterm.lua" "$WEZTERM_DEST"
    echo "  복사: → $WEZTERM_DEST (Windows 경로라 복사)"
  fi
fi

# ─── Arch Linux / native Linux 전용 ───
if [[ "$PLATFORM" == "arch" || "$PLATFORM" == "linux" ]]; then
  echo "[kitty]"
  backup_and_link "$DOTFILES_DIR/kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf"

  echo "[waybar]"
  backup_and_link "$DOTFILES_DIR/waybar/config" "$HOME/.config/waybar/config"
  backup_and_link "$DOTFILES_DIR/waybar/style.css" "$HOME/.config/waybar/style.css"
  backup_and_link "$DOTFILES_DIR/waybar/scripts/pocket-monitor.py" "$HOME/.config/waybar/scripts/pocket-monitor.py"

  echo "[wofi]"
  backup_and_link "$DOTFILES_DIR/wofi/config" "$HOME/.config/wofi/config"
  backup_and_link "$DOTFILES_DIR/wofi/style.css" "$HOME/.config/wofi/style.css"
fi

echo ""
echo "=== 완료 ==="
if [ -d "$BACKUP_DIR" ]; then
  echo "백업 위치: $BACKUP_DIR"
fi
echo ""
echo "후속 작업:"
echo "  zsh:      exec zsh (또는 source ~/.zshrc)"
echo "  tmux:     tmux source ~/.tmux.conf && prefix+I (플러그인 설치)"
echo "  nvim:     nvim 실행 시 lazy.nvim 자동 설치"
if [[ "$PLATFORM" == "wsl" ]]; then
  echo "  wezterm:  WezTerm 재시작"
fi
if [[ "$PLATFORM" == "arch" || "$PLATFORM" == "linux" ]]; then
  echo "  kitty:    kitty 재시작"
  echo "  waybar:   pkill waybar && waybar &"
fi
