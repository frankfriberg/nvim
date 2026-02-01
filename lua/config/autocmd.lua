local api = vim.api
local autocmd = api.nvim_create_autocmd
local map = require("helpers.map")
local git = require("helpers.git")

local bufcheck = api.nvim_create_augroup("bufcheck", { clear = true })

local on_attach = require("helpers.on-attach")

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
  callback = on_attach,
})

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
    map.t({
      ["<enter>"] = { "K", desc = "Manual page", buffer = true, remap = true },
      ["<backspace>"] = { "<c-o>", desc = "Go back", buffer = true, remap = true },
    })
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
  },
  callback = function()
    map.t({
      q = {
        function()
          vim.api.nvim_win_close(0, true)
        end,
        desc = "Close window",
        buffer = true,
      },
    })
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
    end
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
