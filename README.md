# dotfiles

크로스 플랫폼 개발 환경 설정 파일 모음. WSL2 / Arch Linux / macOS 자동 감지.

## 포함 설정

| 도구 | 경로 | 플랫폼 | 설명 |
|------|------|--------|------|
| **Zsh** | `zsh/.zshrc` | WSL | Oh My Zsh + Powerlevel10k, fzf, zoxide, yazi |
| **Zsh** | `zsh/.zshrc-standalone` | Arch/macOS | Starship, pacman/brew 플러그인 |
| **Vim** | `vim/.vimrc` | 공통 | 기본 설정 (Neovim 없는 환경용) |
| **Starship** | `starship/starship.toml` | 공통 | 크로스 셸 프롬프트 |
| **tmux** | `tmux/.tmux.conf` | 공통 | vim 키바인딩, One Dark, 클립보드 자동 감지 |
| **Neovim** | `nvim/` | 공통 | Lua 기반 설정, lazy.nvim |
| **WezTerm** | `wezterm/.wezterm.lua` | WSL | WSL2 도메인, tmux 세션 자동 탭 |
| **kitty** | `kitty/kitty.conf` | Arch/Linux | One Dark, keyd 연동 |
| **waybar** | `waybar/` | Arch/Linux | Hyprland 상단 바, One Dark |
| **wofi** | `wofi/` | Arch/Linux | 앱 런처, 다크 테마 |

## 설치

```bash
git clone https://github.com/Cha-Ji/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

`install.sh`가 플랫폼(Arch/WSL/macOS)을 자동 감지하여 적절한 설정만 설치합니다.
기존 파일은 `~/.dotfiles-backup/` 에 자동 백업됩니다.

### 사전 요구사항

**공통:**
```bash
# tmux 플러그인 매니저 (TPM)
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

**WSL (Oh My Zsh 사용):**
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

**Arch Linux:**
```bash
sudo pacman -S zsh zsh-autosuggestions zsh-syntax-highlighting starship fzf fd kitty waybar wofi
```

## Symlink 구조

**공통:**
```
~/.vimrc              → vim/.vimrc
~/.config/starship.toml → starship/starship.toml
~/.tmux.conf          → tmux/.tmux.conf
~/.config/nvim/       → nvim/
```

**WSL:**
```
~/.zshrc              → zsh/.zshrc
~/.wezterm.lua        → wezterm/.wezterm.lua (Windows: 복사)
```

**Arch Linux:**
```
~/.zshrc              → zsh/.zshrc-standalone
~/.config/kitty/kitty.conf → kitty/kitty.conf
~/.config/waybar/     → waybar/{config,style.css}
~/.config/wofi/       → wofi/{config,style.css}
```

## 클립보드 자동 감지 (tmux)

tmux 설정에 `if-shell`로 플랫폼별 클립보드를 자동 선택:

| 환경 | 클립보드 도구 |
|------|-------------|
| Wayland (Arch) | `wl-copy` / `wl-paste` |
| WSL | `clip.exe` / `powershell.exe Get-Clipboard` |
| macOS | `pbcopy` / `pbpaste` |

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
| `y` (복사모드) | 복사 (시스템 클립보드) |
| `prefix+p` | 붙여넣기 |

### Neovim (leader: Space)

| 키 | 동작 |
|----|------|
| `Ctrl+n` | Neo-tree 토글 |
| `Ctrl+p` | 파일 검색 (Telescope) |
| `Ctrl+h/j/k/l` | 윈도우 이동 |
| `Shift+h/l` | 버퍼 전환 |
| `Space+fg` | Live grep |
| `Space+fb` | 버퍼 목록 |

## 테마

전체 환경에 **One Dark** 테마를 일관 적용:
- kitty / WezTerm: One Dark 컬러스킴
- tmux 상태바: `#282C34` 배경, `#61AFEF` 활성 윈도우
- Neovim: onedark.nvim (`dark` 스타일)
- waybar / wofi: One Dark 다크 테마
