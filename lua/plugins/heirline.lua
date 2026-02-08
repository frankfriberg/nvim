return {
  "rebelot/heirline.nvim",
  event = "UiEnter",
  config = function()
    local hl = require("heirline")
    local utils = require("heirline.utils")
    local conditions = require("heirline.conditions")

    local Record = require("components.record")
    local ViMode = require("components.vimode")
    local Lsp = require("components.lsp")
    local File = require("components.file")
    local Git = require("components.git")
    local Formatters = require("components.formatters")
    local Diagnostic = require("components.diagnostic")

    local Align = { provider = "%=" }

    local Statusline = {
      Align,
      Record,
      ViMode,
      Lsp,
      Formatters,
      Git,
      Align,
    }

    local WinBar = {
      Align,
      File,
      Diagnostic,
      Align,
    }

    local function setup_colors()
      return {
        macro = utils.get_highlight("Macro").fg,
        type = utils.get_highlight("Type").fg,
        operator = utils.get_highlight("Operator").fg,
        special = utils.get_highlight("Special").fg,
        delimiter = utils.get_highlight("Delimiter").fg,
        fg = utils.get_highlight("Normal").fg,
        bg = utils.get_highlight("StatusLineNC").bg,
        warn = utils.get_highlight("DiagnosticWarn").fg,
        error = utils.get_highlight("DiagnosticError").fg,
        hint = utils.get_highlight("DiagnosticHint").fg,
        info = utils.get_highlight("DiagnosticInfo").fg,
        ok = utils.get_highlight("DiagnosticOk").fg,
        git_del = utils.get_highlight("DiffDelete").bg,
        git_add = utils.get_highlight("diffAdded").fg,
        git_change = utils.get_highlight("diffChanged").fg,
        seperator = utils.get_highlight("WinSeperator").fg,
      }
    end

    hl.setup({
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
              "snacks_lazygit",
            },
          }, args.buf)
        end,
      },
      statusline = Statusline,
      winbar = WinBar,
    })
  end,
}
