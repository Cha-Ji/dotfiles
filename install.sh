#!/bin/bash
# dotfiles 설치 스크립트
# 기존 파일을 백업하고 symlink를 생성합니다.

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d_%H%M%S)"

echo "=== Dotfiles 설치 ==="
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

# zsh
echo "[zsh]"
backup_and_link "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"

# vim
echo "[vim]"
backup_and_link "$DOTFILES_DIR/vim/.vimrc" "$HOME/.vimrc"
mkdir -p "$HOME/.vim/undodir"

# starship
echo "[starship]"
backup_and_link "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship.toml"

# tmux
echo "[tmux]"
backup_and_link "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"

# nvim
echo "[nvim]"
backup_and_link "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"

# wezterm (Windows 경로에 복사 — WSL→Windows symlink 불가)
if [ -f "$DOTFILES_DIR/wezterm/.wezterm.lua" ]; then
  echo "[wezterm]"
  WEZTERM_DEST="/mnt/c/Users/$(cmd.exe /C echo %USERNAME% 2>/dev/null | tr -d '\r')/.wezterm.lua"
  if [ -f "$WEZTERM_DEST" ]; then
    mkdir -p "$BACKUP_DIR"
    echo "  백업: $WEZTERM_DEST → $BACKUP_DIR/"
    cp "$WEZTERM_DEST" "$BACKUP_DIR/.wezterm.lua"
  fi
  cp "$DOTFILES_DIR/wezterm/.wezterm.lua" "$WEZTERM_DEST"
  echo "  복사: → $WEZTERM_DEST (Windows 경로라 복사)"
fi

echo ""
echo "=== 완료 ==="
if [ -d "$BACKUP_DIR" ]; then
  echo "백업 위치: $BACKUP_DIR"
fi
echo ""
echo "후속 작업:"
echo "  zsh:      exec zsh (또는 source ~/.zshrc)"
echo "  vim:      vim 실행 시 자동 적용"
echo "  starship: starship 설치 필요 시 → curl -sS https://starship.rs/install.sh | sh"
echo "  tmux:     tmux source ~/.tmux.conf"
echo "  nvim:     nvim 실행 시 자동 적용"
echo "  wezterm:  WezTerm 재시작"
