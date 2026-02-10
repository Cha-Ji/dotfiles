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
    mv "$dest" "$BACKUP_DIR/"
  elif [ -L "$dest" ]; then
    echo "  기존 symlink 제거: $dest"
    rm "$dest"
  fi

  ln -s "$src" "$dest"
  echo "  연결: $dest → $src"
}

# tmux
echo "[tmux]"
backup_and_link "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"

# nvim
echo "[nvim]"
mkdir -p "$HOME/.config"
backup_and_link "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"

echo ""
echo "=== 완료 ==="
if [ -d "$BACKUP_DIR" ]; then
  echo "백업 위치: $BACKUP_DIR"
fi
echo ""
echo "후속 작업:"
echo "  tmux: tmux source ~/.tmux.conf"
echo "  nvim: nvim 실행 시 자동 적용"
