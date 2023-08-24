return {
  dir = "~/.config/nvim/dev/neverforest-nvim",
  priority = 1000,
  lazy = false,
  config = function()
    local n = require("neverforest")
    -- local h = n.colorscheme

    -- local function addUnderline(name)
    --   local current_def = h[h[name].link]
    --   local new_def = vim.tbl_extend('force', {}, current_def, { underline = true })
    --
    --   vim.api.nvim_set_hl(0, name .. "Underlined", new_def)
    -- end
    --
    -- addUnderline("NeoTreeGitAdded")
    -- addUnderline("NeoTreeGitConflict")
    -- addUnderline("NeoTreeGitDeleted")
    -- addUnderline("NeoTreeGitIgnored")
    -- addUnderline("NeoTreeGitModified")
    -- addUnderline("NeoTreeGitUnstaged")
    -- addUnderline("NeoTreeGitUntracked")
    -- addUnderline("NeoTreeGitStaged")

    n.load()
  end,
}
