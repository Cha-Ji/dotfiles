local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- ── 기본 셸: WSL2 zsh 바로 진입 ──
config.default_domain = 'WSL:Ubuntu'

-- ── 폰트 ──
config.font = wezterm.font('MesloLGLDZ Nerd Font')
config.font_size = 11.0

-- ── 테마 (One Dark 계열) ──
config.color_scheme = 'OneDark (base16)'

-- ── 윈도우 ──
config.window_background_opacity = 0.95
config.window_padding = { left = 4, right = 4, top = 4, bottom = 4 }
config.initial_rows = 40
config.initial_cols = 140

-- ── 탭바 ──
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true

-- ── 스크롤 ──
config.scrollback_lines = 10000

-- ── GPU 가속 ──
config.front_end = 'WebGpu'

-- ── 런처 메뉴 (Ctrl+Shift+L) ──
config.launch_menu = {
  { label = 'WSL2 (Ubuntu)', args = { 'wsl.exe', '--distribution', 'Ubuntu' } },
  { label = 'PowerShell', args = { 'powershell.exe' } },
  { label = 'CMD', args = { 'cmd.exe' } },
}

-- ── 키바인딩 (탭 관리 위주, 분할은 tmux에 위임) ──
config.keys = {
  -- 새 탭
  { key = 't', mods = 'CTRL|SHIFT', action = wezterm.action.SpawnTab 'CurrentPaneDomain' },
  -- 탭 이동
  { key = 'LeftArrow', mods = 'CTRL|SHIFT', action = wezterm.action.ActivateTabRelative(-1) },
  { key = 'RightArrow', mods = 'CTRL|SHIFT', action = wezterm.action.ActivateTabRelative(1) },
  -- 탭 번호로 이동
  { key = '1', mods = 'ALT', action = wezterm.action.ActivateTab(0) },
  { key = '2', mods = 'ALT', action = wezterm.action.ActivateTab(1) },
  { key = '3', mods = 'ALT', action = wezterm.action.ActivateTab(2) },
  { key = '4', mods = 'ALT', action = wezterm.action.ActivateTab(3) },
  { key = '5', mods = 'ALT', action = wezterm.action.ActivateTab(4) },
  -- 런처 메뉴
  { key = 'l', mods = 'CTRL|SHIFT', action = wezterm.action.ShowLauncher },
  -- 폰트 크기 조절
  { key = '=', mods = 'CTRL', action = wezterm.action.IncreaseFontSize },
  { key = '-', mods = 'CTRL', action = wezterm.action.DecreaseFontSize },
  { key = '0', mods = 'CTRL', action = wezterm.action.ResetFontSize },
}

return config
