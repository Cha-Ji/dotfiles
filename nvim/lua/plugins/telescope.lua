return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    { "<C-p>", "<cmd>Telescope find_files<CR>", desc = "파일 검색" },
    { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "텍스트 검색 (live grep)" },
    { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "버퍼 목록" },
    { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "도움말 검색" },
    { "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "최근 파일" },
    { "<leader>fs", "<cmd>Telescope git_status<CR>", desc = "Git 변경 파일" },
  },
  config = function()
    require("telescope").setup({
      defaults = {
        file_ignore_patterns = { "node_modules", ".git/", "dist/" },
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = { preview_width = 0.55 },
        },
      },
    })
  end,
}
