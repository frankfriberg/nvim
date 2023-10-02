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
    local utils = require("heirline.utils")

    local colors = {
      fg = utils.get_highlight("Normal").fg,
      bg = utils.get_highlight("Normal").bg,
      dark_bg = utils.get_highlight("NeoTreeNormal").bg,
      bright_bg = utils.get_highlight("Folded").bg,
      bright_fg = utils.get_highlight("Folded").fg,
      red = utils.get_highlight("Red").fg,
      dark_red = utils.get_highlight("DiffDelete").bg,
      green = utils.get_highlight("GreenSign").fg,
      blue = utils.get_highlight("BlueSign").fg,
      gray = utils.get_highlight("BufferInactive").fg,
      orange = utils.get_highlight("Constant").fg,
      purple = utils.get_highlight("Statement").fg,
      cyan = utils.get_highlight("Special").fg,
      diag_warn = utils.get_highlight("DiagnosticWarn").fg,
      diag_error = utils.get_highlight("DiagnosticError").fg,
      diag_hint = utils.get_highlight("DiagnosticHint").fg,
      diag_info = utils.get_highlight("DiagnosticInfo").fg,
      git_del = utils.get_highlight("GitSignsDelete").fg,
      git_add = utils.get_highlight("GitSignsAdd").fg,
      git_change = utils.get_highlight("GitSignsChange").fg,
    }

    require("heirline").load_colors(colors)
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
