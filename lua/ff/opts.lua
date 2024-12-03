vim.g.mapleader = " "
vim.g.border = "rounded"

vim.opt.clipboard = "unnamedplus" -- Use system clipboard
vim.opt.showmode = false -- Don't show mode
vim.opt.tabstop = 2 -- Number of spaces tabs count for
vim.opt.softtabstop = 2 -- Number of spaces tabs count for
vim.opt.shiftwidth = 2 -- Size of an indent
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.swapfile = false -- No swap file
vim.opt.backup = false -- No backup file
vim.opt.scrolloff = 10 -- Lines above and below cursor before scrolling
vim.opt.cmdheight = 0 -- Height of the command bar
vim.opt.laststatus = 3 -- Always show status line
vim.opt.wrap = false -- Don't wrap lines
vim.opt.undofile = true -- Save undo files
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir" -- Directory for undo files
vim.opt.updatetime = 500 -- Time before CursorHold autocommands are triggered
vim.opt.timeout = true -- Enable timeout of mappings
vim.opt.timeoutlen = 300 -- Time to wait for a mapped sequence to complete
vim.opt.signcolumn = "yes" -- Always show sign column
vim.opt.fillchars:append(",eob: ") -- Hide ~ from window
vim.opt.breakindent = true -- Break line at indent
vim.opt.smartcase = true
vim.opt.winblend = 5 -- Blend background of windows
vim.opt.pumblend = 5 -- Blend background of pumenu
