---@diagnostic disable: missing-fields
return {
  "saghen/blink.cmp",
  lazy = false,
  version = "*",
  dependencies = {
    "xzbdmw/colorful-menu.nvim",
    "fang2hou/blink-copilot",
  },
  opts = function()
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    return {
      keymap = {
        preset = "super-tab",
        ["<Tab>"] = {
          function(cmp)
            if cmp.snippet_active() then
              return cmp.accept()
            else
              return cmp.select_and_accept()
            end
          end,
          "snippet_forward",
          "fallback",
        },
      },
      sources = {
        default = {
          "lsp",
          "snippets",
          "copilot",
          "path",
        },
        providers = {
          snippets = {
            opts = {
              search_paths = { vim.fn.stdpath("config") .. "/snippets" },
            },
          },
          copilot = {
            name = "copilot",
            module = "blink-copilot",
            score_offset = 100,
            async = true,
          },
        },
        per_filetype = {
          codecompanion = { "codecompanion" },
        },
      },
      completion = {
        ghost_text = {
          enabled = true,
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 0,
          window = {
            winblend = vim.o.winblend,
          },
        },
        list = {
          selection = {
            preselect = function()
              return not require("blink.cmp").snippet_active({ direction = 1 })
            end,
          },
          max_items = 30,
        },
        menu = {
          min_width = 30,
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
      cmdline = {
        keymap = { preset = "inherit" },
        completion = { menu = { auto_show = true } },
      },
      signature = {
        enabled = true,
        trigger = {
          show_on_insert = true,
        },
        window = {
          winblend = vim.o.winblend,
        },
      },
    }
  end,
}
