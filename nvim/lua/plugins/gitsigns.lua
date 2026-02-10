return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("gitsigns").setup({
      signs = {
        add          = { text = "▎" },
        change       = { text = "▎" },
        delete       = { text = "" },
        topdelete    = { text = "" },
        changedelete = { text = "▎" },
      },

      current_line_blame = true,
      current_line_blame_opts = {
        delay = 300,
        virt_text_pos = "eol",
      },

      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local map = function(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end

        -- Hunk 탐색
        map("n", "]c", function()
          if vim.wo.diff then return "]c" end
          vim.schedule(function() gs.next_hunk() end)
          return "<Ignore>"
        end, "다음 변경 hunk")

        map("n", "[c", function()
          if vim.wo.diff then return "[c" end
          vim.schedule(function() gs.prev_hunk() end)
          return "<Ignore>"
        end, "이전 변경 hunk")

        -- Hunk 작업
        map("n", "<leader>hp", gs.preview_hunk, "Hunk 미리보기")
        map("n", "<leader>hs", gs.stage_hunk, "Hunk 스테이지")
        map("n", "<leader>hr", gs.reset_hunk, "Hunk 리셋")
        map("n", "<leader>hS", gs.stage_buffer, "버퍼 전체 스테이지")
        map("n", "<leader>hu", gs.undo_stage_hunk, "스테이지 취소")
        map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "라인 blame 전체")
        map("n", "<leader>hd", gs.diffthis, "Diff 보기")
      end,
    })
  end,
}
