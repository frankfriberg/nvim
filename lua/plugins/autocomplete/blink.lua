---@diagnostic disable: missing-fields
return {
  "saghen/blink.cmp",
  lazy = false,
  build = "cargo build --release",
  dependencies = {
    "rafamadriz/friendly-snippets",
    "xzbdmw/colorful-menu.nvim",
  },
  opts = function()
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    return {
      keymap = {
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
        ["<S-CR>"] = { "accept" },
      },
      appearance = {
        nerd_font_variant = "mono",
      },
      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 0,
          window = {
            border = vim.g.border,
            winblend = vim.o.winblend,
          },
        },
        list = {
          max_items = 30,
          selection = {
            preselect = false,
          },
        },
        menu = {
          min_width = 30,
          border = vim.g.border,
          winblend = vim.o.winblend,
          draw = {
            columns = { { "kind_icon" }, { "label", gap = 1 } },
            components = {
              label = {
                text = require("colorful-menu").blink_components_text,
                highlight = require("colorful-menu").blink_components_highlight,
              },
            },
          },
        },
      },
      signature = {
        enabled = true,
        window = {
          border = vim.g.border,
          winblend = vim.o.winblend,
        },
      },
    }
  end,
}
