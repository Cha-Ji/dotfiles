return {
  "nvim-treesitter/nvim-treesitter",
  tag = "v0.9.3",  -- nvim 0.9.5 호환 (v0.10+는 nvim 0.10 필요)
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "typescript", "tsx", "javascript",
        "lua", "json", "jsonc",
        "markdown", "markdown_inline",
        "bash", "html", "css",
        "vim", "vimdoc", "regex",
      },
      highlight = { enable = true },
      indent = { enable = true },
    })
  end,
}
