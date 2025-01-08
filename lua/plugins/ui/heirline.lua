return {
  "rebelot/heirline.nvim",
  event = "UiEnter",
  dependencies = {
    "echasnovski/mini.icons",
  },
  opts = function()
    local statuslines = require("plugins.ui.heirline.statusline")
    local winbar = require("plugins.ui.heirline.winbar")
    local utils = require("heirline.utils")
    local conditions = require("heirline.conditions")

    local function setup_colors()
      return {
        fg = utils.get_highlight("Normal").fg,
        background = utils.get_highlight("Normal").bg,
        warn = utils.get_highlight("DiagnosticWarn").fg,
        error = utils.get_highlight("DiagnosticError").fg,
        hint = utils.get_highlight("DiagnosticHint").fg,
        info = utils.get_highlight("DiagnosticInfo").fg,
        ok = utils.get_highlight("DiagnosticOk").fg,
        git_del = utils.get_highlight("DiffDelete").bg,
        git_add = utils.get_highlight("diffAdded").fg,
        git_change = utils.get_highlight("diffChanged").fg,
      }
    end

    vim.api.nvim_create_augroup("Heirline", { clear = true })
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        utils.on_colorscheme(setup_colors)
      end,
      group = "Heirline",
    })

    return {
      opts = {
        colors = setup_colors(),
        disable_winbar_cb = function(args)
          return conditions.buffer_matches({
            buftype = { "nofile", "prompt", "help", "quickfix" },
            filetype = {
              "^git.*",
              "fugitive",
              "Trouble",
              "dashboard",
              "NeogitCommitMessage",
              "NeogitRebaseTodo",
              "oil",
              "fzf",
            },
          }, args.buf)
        end,
      },
      statusline = statuslines,
      winbar = winbar,
    }
  end,
}
