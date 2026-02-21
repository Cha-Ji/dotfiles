# dotfiles

WSL2 (Ubuntu) 개발 환경 설정 파일 모음.

## 포함 설정

| 도구 | 경로 | 설명 |
|------|------|------|
| **Zsh** | `zsh/.zshrc` | Oh My Zsh + Powerlevel10k, fzf, zoxide, yazi |
| **Vim** | `vim/.vimrc` | 기본 설정 (Neovim 없는 환경용) |
| **Starship** | `starship/starship.toml` | 크로스 셸 프롬프트 (Powerlevel10k 대안) |
| **tmux** | `tmux/.tmux.conf` | 마우스, vim 키바인딩, One Dark 테마, 세션 복원 |
| **Neovim** | `nvim/` | Lua 기반 설정, lazy.nvim 플러그인 매니저 |
| **WezTerm** | `wezterm/.wezterm.lua` | WSL2 기본 도메인, tmux 세션 자동 탭 생성 |

## 설치

```bash
git clone https://github.com/Cha-Ji/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

기존 파일은 `~/.dotfiles-backup/` 에 자동 백업됩니다.

### 사전 요구사항

```bash
# Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Powerlevel10k (zsh 테마)
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# zsh 플러그인
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# tmux 플러그인 매니저 (TPM)
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Starship (선택)
curl -sS https://starship.rs/install.sh | sh

# Neovim (v0.9+)
# lazy.nvim은 첫 실행 시 자동 설치됨
```

## Symlink 구조

```
~/.zshrc              → ~/dotfiles/zsh/.zshrc
~/.vimrc              → ~/dotfiles/vim/.vimrc
~/.config/starship.toml → ~/dotfiles/starship/starship.toml
~/.tmux.conf          → ~/dotfiles/tmux/.tmux.conf
~/.config/nvim/       → ~/dotfiles/nvim/
~/.wezterm.lua        → ~/dotfiles/wezterm/.wezterm.lua (Windows: 복사)
```

## 주요 키바인딩

### tmux (prefix: Ctrl+a)

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
- WezTerm: `OneDark (base16)`
- tmux 상태바: `#282C34` 배경, `#61AFEF` 활성 윈도우
- Neovim: onedark.nvim (`dark` 스타일)

## 특이사항

- **WSL2 전용**: 클립보드 연동이 `clip.exe` / `powershell.exe Get-Clipboard` 사용
- **WezTerm**: WSL→Windows 경로 symlink 불가하여 `install.sh`가 복사로 처리
- **tmux-resurrect + continuum**: 15분 간격 세션 자동 저장, 재부팅 후 복원
