local map = vim.keymap.set

-- ── Neo-tree ──
map("n", "<C-n>", "<cmd>Neotree toggle<CR>", { desc = "파일트리 토글" })
map("n", "<leader>nf", "<cmd>Neotree reveal<CR>", { desc = "현재 파일 위치로 포커스" })
map("n", "<leader>ng", "<cmd>Neotree git_status<CR>", { desc = "Git 상태 보기" })

-- ── 윈도우 이동 (neo-tree ↔ 편집기) ──
map("n", "<C-h>", "<C-w>h", { desc = "왼쪽 윈도우" })
map("n", "<C-j>", "<C-w>j", { desc = "아래 윈도우" })
map("n", "<C-k>", "<C-w>k", { desc = "위 윈도우" })
map("n", "<C-l>", "<C-w>l", { desc = "오른쪽 윈도우" })

-- ── 윈도우 리사이즈 ──
map("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "높이 증가" })
map("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "높이 감소" })
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "너비 감소" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "너비 증가" })

-- ── 버퍼 이동 ──
map("n", "<S-l>", "<cmd>bnext<CR>", { desc = "다음 버퍼" })
map("n", "<S-h>", "<cmd>bprev<CR>", { desc = "이전 버퍼" })

-- ── 비주얼 모드 인덴트 유지 ──
map("v", "<", "<gv", { desc = "인덴트 감소" })
map("v", ">", ">gv", { desc = "인덴트 증가" })

-- ── Esc로 검색 하이라이트 끄기 ──
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "검색 하이라이트 끄기" })
