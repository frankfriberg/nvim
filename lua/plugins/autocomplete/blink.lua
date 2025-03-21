---@diagnostic disable: missing-fields
return {
  "saghen/blink.cmp",
  lazy = false,
  -- build = "cargo build --release",
  version = "*",
  dependencies = {
    "xzbdmw/colorful-menu.nvim",
    "fang2hou/blink-copilot",
    {
      "L3MON4D3/LuaSnip",
      version = "v2.*",
      build = "make install_jsregexp",
      dependencies = {
        "rafamadriz/friendly-snippets",
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
          require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })

          local extends = {
            typescript = { "tsdoc" },
            javascript = { "jsdoc" },
            lua = { "luadoc" },
            python = { "pydoc" },
            rust = { "rustdoc" },
            cs = { "csharpdoc" },
            java = { "javadoc" },
            c = { "cdoc" },
            cpp = { "cppdoc" },
            php = { "phpdoc" },
            kotlin = { "kdoc" },
            ruby = { "rdoc" },
            sh = { "shelldoc" },
          }
          -- friendly-snippets - enable standardized comments snippets
          for ft, snips in pairs(extends) do
            require("luasnip").filetype_extend(ft, snips)
          end
        end,
      },
      opts = { history = true, delete_check_events = "TextChanged" },
    },
  },
  opts = function()
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    return {
      keymap = {
        preset = "super-tab",
      },
      snippets = { preset = "luasnip" },
      sources = {
        default = {
          "lsp",
          "snippets",
          "copilot",
          "path",
        },
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-copilot",
            score_offset = 100,
            async = true,
          },
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
            border = vim.g.border,
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
