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
    local winBar = require("plugins.ui.heirline.winbar")
    return {
      statusline = statusLines,
      winbar = winBar,
      opts = {
        disable_winbar_cb = function(args)
          return conditions.buffer_matches({
            buftype = { "nofile", "prompt", "help", "quickfix" },
            filetype = { "^git.*", "fugitive", "Trouble", "dashboard" },
          }, args.buf)
        end,
      },
    }
  end,
}
