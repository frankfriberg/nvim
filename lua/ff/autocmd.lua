local api = vim.api
local autocmd = api.nvim_create_autocmd
local map = require("helpers.map")
local git = require("helpers.git")

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
    map.n("<enter>", "K", "Manual page", { buffer = true })
    map.n("<backspace>", "<c-o>", "Manual page", { buffer = true })
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

autocmd({
  "FileType",
  "BufEnter",
  "FocusGained",
}, {
  desc = "Update git status",
  callback = function()
    local is_git_repo, _ = vim.loop.fs_stat(vim.loop.cwd() .. "/.git")
    vim.g.is_git_repo = is_git_repo
    if is_git_repo then
      vim.g.is_git_rebase = git.is_rebase()
      vim.g.branch_name = git.current_branch()
      vim.g.ahead_behind = git.ahead_behind()
    end
  end,
})

autocmd("CursorHold", {
  desc = "Show diagnostics under cursor",
  callback = function()
    for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
      if vim.api.nvim_win_get_config(winid).zindex then
        return
      end
    end
    vim.diagnostic.open_float()
  end,
})

autocmd("WinLeave", {
  desc = "Disable cursorline in unfocused window",
  callback = function()
    vim.wo.cursorline = false
  end,
})

autocmd({ "WinEnter", "VimEnter" }, {
  desc = "Enable cursorline for focused window",
  callback = function()
    vim.wo.cursorline = true
  end,
})

autocmd({ "VimResized" }, {
  desc = "Balance windows when vim is resized",
  command = "wincmd =",
})
