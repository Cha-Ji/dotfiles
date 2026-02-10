-- ── lazy.nvim 부트스트랩 ──
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ── 기본 설정 로드 ──
require("options")
require("keymaps")

-- ── 플러그인 로드 (lua/plugins/ 디렉토리 자동 스캔) ──
require("lazy").setup("plugins", {
  checker = { enabled = false },
  change_detection = { notify = false },
})
