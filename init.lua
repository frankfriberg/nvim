require("ff.opts")
require("ff.mappings")
require("ff.autocmd")
require("ff.diagnostics")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  ui = {
    border = vim.o.winborder,
    backdrop = 100,
    title = " Lazy ",
    size = { width = 0.5, height = 0.7 },
    pills = false,
  },
  change_detection = {
    notify = false,
  },
  dev = {
    patterns = { "frankfriberg" },
  },
})
