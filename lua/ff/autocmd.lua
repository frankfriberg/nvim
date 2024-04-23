local api = vim.api
local autocmd = api.nvim_create_autocmd
local map = require("ff.map")

local bufcheck = api.nvim_create_augroup("bufcheck", { clear = true })

autocmd("TextYankPost", {
  desc = "Highlight yanks",
  group = bufcheck,
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ timeout = 500 })
  end,
})

autocmd("TextYankPost", {
  desc = "Sync system clipboard",
  group = bufcheck,
  pattern = "*",
  callback = function()
    vim.fn.setreg("+", vim.fn.getreg("*"))
  end,
})

autocmd("FileType", {
  desc = "Pager mappings for Manual",
  group = bufcheck,
  pattern = "man",
  callback = function()
    vim.keymap.set("n", "<enter>", "K", { buffer = true })
    vim.keymap.set("n", "<backspace>", "<c-o>", { buffer = true })
  end,
})

autocmd("BufReadPost", {
  desc = "Return to last edit position",
  group = bufcheck,
  pattern = "*",
  callback = function()
    if vim.fn.line("'\"") > 0 and vim.fn.line("'\"") <= vim.fn.line("$") then
      vim.fn.setpos(".", vim.fn.getpos("'\""))
    end
  end,
})

autocmd("FileType", {
  desc = "Close windows with q",
  group = bufcheck,
  pattern = {
    "Gitcommit",
    "git",
    "man",
    "help",
    "startuptime",
    "qf",
    "lspinfo",
    "fugitive",
    "fugitiveblame",
    "neotest-summary",
    "neotest-console",
  },
  callback = function()
    map.n("q", function()
      vim.api.nvim_win_close(0, true)
    end, "Close win", { buffer = true })
  end,
})
