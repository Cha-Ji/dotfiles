# LLM 환경 세팅 프롬프트

이 문서를 LLM 시스템 프롬프트나 CLAUDE.md에 포함하면, LLM이 사용자의 개발 환경을 이해하고 적절한 명령/설정을 제안할 수 있습니다.

---

## 프롬프트 (복사용)

```
## 개발 환경

크로스 플랫폼 dotfiles (WSL2, Arch Linux, macOS 지원).
플랫폼 자동 감지: install.sh, tmux 클립보드 등.

### 공통 설정

- 에디터: Neovim (Lua 설정, lazy.nvim), Vim (폴백)
- 터미널 멀티플렉서: tmux (prefix: Ctrl+a)
- 프롬프트: Starship (standalone) / Powerlevel10k (WSL oh-my-zsh)
- 테마: One Dark 전체 통일
- dotfiles: ~/dotfiles (symlink 관리, install.sh)

### Arch Linux 환경

- OS: Arch Linux, Hyprland WM, Wayland
- 터미널: kitty (One Dark, GPU 가속)
- 셸: Zsh + Starship (oh-my-zsh 미사용)
  - 플러그인: zsh-autosuggestions, zsh-syntax-highlighting (pacman)
  - 도구: fzf, fd, lazygit
- 클립보드: wl-copy / wl-paste (Wayland)
- 키 리매핑: keyd (Super+C/V/A/X/Z → Ctrl)
- 입력기: fcitx5 + hangul
- 바: waybar (One Dark)
- 런처: wofi (Super+Space)

### WSL2 환경

- OS: WSL2 (Ubuntu) on Windows
- 터미널: WezTerm (GPU 가속, WSL2 기본 도메인)
- 셸: Zsh + Oh My Zsh + Powerlevel10k
  - 플러그인: git, z, sudo, alias-finder, zsh-autosuggestions, zsh-syntax-highlighting
  - 도구: fzf, zoxide, yazi, nvm
- 클립보드: clip.exe / powershell.exe Get-Clipboard

### tmux 설정 요약

- Prefix: Ctrl+a
- 패널 분할: `|` (수평), `-` (수직)
- 패널 이동: Alt+h/j/k/l (prefix 불필요)
- 패널 리사이즈: Alt+방향키
- 복사모드: vim 스타일, `y`로 시스템 클립보드에 복사 (자동 감지)
- 팝업: Alt+y → yazi 파일매니저
- 플러그인: TPM, tmux-resurrect, tmux-continuum (15분 자동저장)

### Neovim 설정 요약

- 플러그인 매니저: lazy.nvim (lua/plugins/ 자동 스캔)
- Leader: Space, 줄 번호: 절대 + 상대
- 탭: 2칸 스페이스, 클립보드: unnamedplus

플러그인:
- neo-tree.nvim: 파일 탐색기 (Ctrl+n 토글)
- telescope.nvim: Fuzzy 파일/텍스트 검색
- nvim-treesitter: 구문 강조
- vim-fugitive: Git 통합
- gitsigns.nvim: Git diff 마크
- onedark.nvim: 테마

### 참고사항

- dotfiles 저장소: ~/dotfiles (symlink로 관리)
- tmux 클립보드는 if-shell로 플랫폼 자동 감지 (wl-copy / clip.exe / pbcopy)
- tmux 세션은 자동 복원됨 (continuum)
- Neovim 플러그인은 첫 실행 시 lazy.nvim이 자동 설치
```
