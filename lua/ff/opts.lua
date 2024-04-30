vim.g.mapleader = " "

vim.o.clipboard = "unnamedplus" -- Use system clipboard
vim.o.showmode = false -- Don't show mode
vim.o.tabstop = 2 -- Number of spaces tabs count for
vim.o.softtabstop = 2 -- Number of spaces tabs count for
vim.o.shiftwidth = 2 -- Size of an indent
vim.o.expandtab = true -- Use spaces instead of tabs
vim.o.swapfile = false -- No swap file
vim.o.backup = false -- No backup file
vim.o.scrolloff = 10 -- Lines above and below cursor before scrolling
vim.o.cursorline = true -- Highlight current line
vim.o.cmdheight = 0 -- Height of the command bar
vim.o.laststatus = 3 -- Always show status line
vim.o.wrap = false -- Don't wrap lines
vim.o.undofile = true -- Save undo files
vim.o.undodir = os.getenv("HOME") .. "/.vim/undodir" -- Directory for undo files
vim.o.updatetime = 50 -- Time before CursorHold autocommands are triggered
vim.o.timeout = true -- Enable timeout of mappings
vim.o.timeoutlen = 300 -- Time to wait for a mapped sequence to complete
vim.o.signcolumn = "yes" -- Always show sign column
