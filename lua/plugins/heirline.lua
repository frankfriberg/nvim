return {
  "rebelot/heirline.nvim",
  event = "VeryLazy",
  lazy = true,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "lewis6991/gitsigns.nvim",
    "moll/vim-bbye",
  },
  opts = function()
    local conditions = require("heirline.conditions")
    local statusLines = require("plugins.ui.heirline.statusline")
    local winbar = require("plugins.ui.heirline.winbar")
    -- local tabline = require("plugins.ui.heirline.tabline")
    return {
      statusline = statusLines,
      winbar = winbar,
      -- tabline = tabline,
      opts = {
        disable_winbar_cb = function(args)
          return conditions.buffer_matches({
            buftype = { "nofile", "prompt", "help", "quickfix", "terminal" },
            filetype = { "^git.*", "fugitive", "Trouble", "dashboard" },
          }, args.buf)
        end,
      },
    }
  end,
}
