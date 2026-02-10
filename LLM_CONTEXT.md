# LLM 환경 세팅 프롬프트

이 문서를 LLM 시스템 프롬프트나 CLAUDE.md에 포함하면, LLM이 사용자의 개발 환경을 이해하고 적절한 명령/설정을 제안할 수 있습니다.

---

## 프롬프트 (복사용)

```
## 개발 환경

- OS: WSL2 (Ubuntu) on Windows
- 셸: Zsh + Oh My Zsh + Powerlevel10k
- 터미널 멀티플렉서: tmux
- 에디터: Neovim (Lua 설정)
- 테마: One Dark (tmux, nvim 통일)

### tmux 설정 요약

- 마우스 활성화, base-index 1
- 패널 분할: `|` (수평), `-` (수직)
- 패널 이동: Alt+h/j/k/l (prefix 불필요)
- 패널 리사이즈: Alt+방향키
- 복사모드: vim 스타일, `y`로 Windows 클립보드에 복사 (clip.exe)
- 붙여넣기: prefix+p (powershell.exe Get-Clipboard)
- 팝업: Alt+y → yazi 파일매니저
- 플러그인: TPM, tmux-resurrect, tmux-continuum (15분 자동저장)
- 윈도우 이름 자동변경 꺼짐 (allow-rename off)

### Neovim 설정 요약

- 플러그인 매니저: lazy.nvim (lua/plugins/ 자동 스캔)
- Leader: Space
- 줄 번호: 절대 + 상대 (relativenumber)
- 탭: 2칸 스페이스, smartindent
- 검색: ignorecase + smartcase
- 클립보드: unnamedplus (WSL2 clip.exe 연동)
- Undo: 파일 저장 (undofile)
- 스왑/백업 파일 비활성화

플러그인:
- neo-tree.nvim: 파일 탐색기 (Ctrl+n 토글)
- telescope.nvim: Fuzzy 파일/텍스트 검색
- nvim-treesitter: 구문 강조
- vim-fugitive: Git 통합
- gitsigns.nvim: Git diff 마크
- onedark.nvim: 테마

키바인딩:
- Ctrl+n: Neo-tree 토글
- Ctrl+h/j/k/l: 윈도우 이동
- Ctrl+방향키: 윈도우 리사이즈
- Shift+h/l: 버퍼 전환
- </>  (visual): 인덴트 유지

### 참고사항

- WSL2 환경이므로 클립보드는 clip.exe / powershell.exe 경유
- dotfiles 저장소: ~/dotfiles (symlink로 관리)
- tmux 세션은 자동 복원됨 (continuum)
- Neovim 플러그인은 첫 실행 시 lazy.nvim이 자동 설치
```
