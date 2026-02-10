return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("neo-tree").setup({
      close_if_last_window = true,
      popup_border_style = "rounded",

      default_component_configs = {
        indent = {
          with_expanders = true,
        },
        git_status = {
          symbols = {
            added     = "✚",
            modified  = "",
            deleted   = "✖",
            renamed   = "󰁕",
            untracked = "",
            ignored   = "",
            unstaged  = "󰄱",
            staged    = "",
            conflict  = "",
          },
        },
      },

      window = {
        position = "left",
        width = 30,
        mappings = {
          -- yazi 대응 키바인딩
          ["l"] = "open",           -- yazi: l로 열기
          ["h"] = "close_node",     -- yazi: h로 닫기/상위
          ["<CR>"] = "open",
          ["<BS>"] = "navigate_up", -- 상위 디렉토리
          ["H"] = "toggle_hidden",  -- yazi: zh 숨김파일 토글
          ["P"] = { "toggle_preview", config = { use_float = true } },
          ["a"] = { "add", config = { show_path = "relative" } },
          ["d"] = "delete",
          ["r"] = "rename",
          ["c"] = "copy_to_clipboard",
          ["x"] = "cut_to_clipboard",
          ["p"] = "paste_from_clipboard",
          ["q"] = "close_window",
          ["R"] = "refresh",
          ["/"] = "fuzzy_finder",
        },
      },

      filesystem = {
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_by_name = {
            "node_modules",
            ".git",
          },
        },
      },

      git_status = {
        window = {
          position = "float",
        },
      },
    })
  end,
}
