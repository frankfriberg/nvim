local api = vim.api
local autocmd = api.nvim_create_autocmd
local map = require("ff.map")

local bufcheck = api.nvim_create_augroup('bufcheck', { clear = true })

-- Highlight yanks
autocmd('TextYankPost', {
  group    = bufcheck,
  pattern  = '*',
  callback = function() vim.highlight.on_yank { timeout = 500 } end
})

-- Sync clipboards because I'm easily confused
autocmd('TextYankPost', {
  group    = bufcheck,
  pattern  = '*',
  callback = function()
    vim.fn.setreg('+', vim.fn.getreg('*'))
  end
})

-- Start terminal in insert mode
autocmd('TermOpen', {
  group   = bufcheck,
  pattern = '*',
  command = 'startinsert | set winfixheight'
})

-- Start git messages in insert mode
autocmd('FileType', {
  group   = bufcheck,
  pattern = { 'gitcommit', 'gitrebase', },
  command = 'startinsert | 1'
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
  pattern = { "Gitcommit", "git", "man", "help", "startuptime", "qf", "lspinfo", "fugitive", "fugitiveblame" },
  callback = function()
    map.n("q", function() vim.api.nvim_win_close(0, true) end, { buffer = true })
  end
})

autocmd('VimResized', {
  group = bufcheck,
  pattern = '*',
  command = 'wincmd =',
  desc = 'Automatically resize windows when the host window size changes.'
})

autocmd('FocusLost', {
  group = bufcheck,
  pattern = '*',
  callback = function(_)
    require("tint").toggle()
  end
})

autocmd('FocusGained', {
  group = bufcheck,
  pattern = '*',
  callback = function(_)
    require("tint").toggle()
  end
})

local function branch_name()
  local branch = vim.fn.system("git branch --show-current 2> /dev/null | tr -d '\n'")
  if branch ~= "" then
    return branch
  else
    return ""
  end
end

vim.api.nvim_create_autocmd({ "FileType", "BufEnter", "FocusGained" }, {
  callback = function()
    vim.b.branch_name = branch_name()
  end
})
