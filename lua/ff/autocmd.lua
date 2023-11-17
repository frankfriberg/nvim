local api = vim.api
local autocmd = api.nvim_create_autocmd
local map = require("ff.map")

local bufcheck = api.nvim_create_augroup('bufcheck', { clear = true })

-- Highlight yanks
autocmd('TextYankPost', {
  group    = bufcheck,
  pattern  = '*',
  callback = function()
    vim.highlight.on_yank({ timeout = 500 })
  end
})

-- Sync clipboards
autocmd('TextYankPost', {
  group    = bufcheck,
  pattern  = '*',
  callback = function()
    vim.fn.setreg('+', vim.fn.getreg('*'))
  end
})

-- Pager mappings for Manual
autocmd('FileType', {
  group    = bufcheck,
  pattern  = 'man',
  callback = function()
    vim.keymap.set('n', '<enter>', 'K', { buffer = true })
    vim.keymap.set('n', '<backspace>', '<c-o>', { buffer = true })
  end
})

-- Return to last edit position when opening files
autocmd('BufReadPost', {
  group    = bufcheck,
  pattern  = '*',
  callback = function()
    if vim.fn.line("'\"") > 0 and vim.fn.line("'\"") <= vim.fn.line("$") then
      vim.fn.setpos('.', vim.fn.getpos("'\""))
    end
  end
})

-- windows to close with "q"
autocmd("FileType", {
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
    map.n("q", function() vim.api.nvim_win_close(0, true) end, "Close win", { buffer = true })
  end
})

autocmd('VimResized', {
  group = bufcheck,
  pattern = '*',
  command = 'wincmd =',
  desc = 'Automatically resize windows when the host window size changes.'
})

local function git_status()
  local statuses = vim.fn.system("git status -s")
  local git_counts = {
    M = 0, A = 0, D = 0, R = 0, C = 0, U = 0, untracked = 0
  }

  for status in statuses:gmatch("(%S+)%s+(%S+)") do
    if status == "??" then
      git_counts.untracked = git_counts.untracked + 1
    elseif git_counts[status] then
      git_counts[status] = git_counts[status] + 1
    end
  end

  return git_counts
end

local function git_branch()
  local branch = vim.fn.system("git branch --show-current")
  if branch ~= "" then
    return branch:gsub("\n", "")
  else
    return branch
  end
end

local function git_ahead_behind()
  local data = vim.fn.system("git rev-list --count --left-right HEAD...@{upstream}")
  local ahead, behind = data:match("(%d+)%s+(%d+)")
  local ahead_behind = {
    ahead = tonumber(ahead),
    behind = tonumber(behind)
  }

  return ahead_behind
end

local git_events = {
  "FileType",
  "BufEnter",
  "FocusGained",
}

vim.api.nvim_create_autocmd(git_events, {
  callback = function()
    local is_git_repo, _ = vim.loop.fs_stat(vim.loop.cwd() .. "/.git")
    vim.g.is_git_repo = is_git_repo
    if is_git_repo then
      vim.g.git_status = git_status()
      vim.g.branch_name = git_branch()
      vim.g.ahead_behind = git_ahead_behind()
    end
  end
})
