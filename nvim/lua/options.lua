local opt = vim.opt

-- ── 줄 번호 ──
opt.number = true
opt.relativenumber = true

-- ── 인덴트 ──
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

-- ── 검색 ──
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.incsearch = true

-- ── UI ──
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = false
opt.showmode = false

-- ── 분할 ──
opt.splitbelow = true
opt.splitright = true

-- ── 클립보드 (WSL2 → clip.exe 연동) ──
opt.clipboard = "unnamedplus"

-- ── 기타 ──
opt.undofile = true
opt.updatetime = 250
opt.timeoutlen = 300
opt.swapfile = false
opt.backup = false

-- ── Leader 키 ──
vim.g.mapleader = " "
vim.g.maplocalleader = " "
