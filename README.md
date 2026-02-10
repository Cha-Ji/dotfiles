# dotfiles

WSL2 (Ubuntu) 개발 환경 설정 파일 모음.

## 포함 설정

| 도구 | 경로 | 설명 |
|------|------|------|
| **tmux** | `tmux/.tmux.conf` | 마우스, vim 키바인딩, One Dark 테마, 세션 복원 |
| **Neovim** | `nvim/` | Lua 기반 설정, lazy.nvim 플러그인 매니저 |
| ~~Vim~~ | `.vimrc` | 레거시 (Neovim으로 전환됨) |

## 설치

```bash
git clone https://github.com/Cha-Ji/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

기존 파일은 `~/.dotfiles-backup/` 에 자동 백업됩니다.

### 사전 요구사항

```bash
# tmux 플러그인 매니저 (TPM)
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Neovim (v0.9+)
# lazy.nvim은 첫 실행 시 자동 설치됨
```

## Symlink 구조

```
~/.tmux.conf     → ~/dotfiles/tmux/.tmux.conf
~/.config/nvim/  → ~/dotfiles/nvim/
```

## 주요 키바인딩

### tmux (prefix: Ctrl+b)

| 키 | 동작 |
|----|------|
| `\|` | 수평 분할 |
| `-` | 수직 분할 |
| `Alt+h/j/k/l` | 패널 이동 (prefix 불필요) |
| `Alt+방향키` | 패널 리사이즈 |
| `Alt+y` | yazi 팝업 |
| `v` (복사모드) | 선택 시작 |
| `y` (복사모드) | 복사 (Windows 클립보드) |
| `prefix+p` | 붙여넣기 (Windows 클립보드) |

### Neovim (leader: Space)

| 키 | 동작 |
|----|------|
| `Ctrl+n` | Neo-tree 토글 |
| `Ctrl+h/j/k/l` | 윈도우 이동 |
| `Ctrl+방향키` | 윈도우 리사이즈 |
| `Shift+h/l` | 버퍼 전환 |
| `< / >` (visual) | 인덴트 유지 |

### Neovim 플러그인

| 플러그인 | 역할 |
|---------|------|
| lazy.nvim | 플러그인 매니저 |
| neo-tree.nvim | 파일 탐색기 |
| telescope.nvim | Fuzzy 검색 |
| nvim-treesitter | 구문 강조 |
| vim-fugitive | Git 통합 |
| gitsigns.nvim | Git diff 표시 |
| onedark.nvim | One Dark 테마 |

## 테마

전체 환경에 **One Dark** 테마를 일관 적용:
- tmux 상태바: `#282C34` 배경, `#61AFEF` 활성 윈도우
- Neovim: onedark.nvim (`dark` 스타일)

## 특이사항

- **WSL2 전용**: 클립보드 연동이 `clip.exe` / `powershell.exe Get-Clipboard` 사용
- **tmux-resurrect + continuum**: 15분 간격 세션 자동 저장, 재부팅 후 복원
