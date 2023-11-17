---@diagnostic disable: missing-fields
return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lua",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",

    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",

    "rafamadriz/friendly-snippets",

    "js-everts/cmp-tailwind-colors"
  },
  init = function()
    -- Limit number of options for completion
    vim.o.pumheight = 10
    vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { link = "Green" })
  end,
  config = function()
    local cmp = require('cmp')
    local kinds = require("plugins.ui.icons").symbol_kinds
    require("luasnip.loaders.from_vscode").lazy_load()

    cmp.setup({
      enable_alpha = true,
      experimental = {
        ghost_text = false,
      },
      snippet = {
        expand = function(args) require('luasnip').lsp_expand(args.body) end,
      },
      window = {
        completion = {
          col_offset = -4,
          side_padding = 0,
          border = "rounded",
          winhighlight = "Normal:NormalFloat,CursorLine:TelescopeSelectionCaret"
        },
        documentation = cmp.config.window.bordered(),
      },
      view = {
        entries = "custom",
      },
      formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, item)
          if item.kind == "Color" then
            item = require("cmp-tailwind-colors").format(entry, item)

            if item.kind ~= "Color" then
              item.menu = "Color"
              return item
            end
          end

          item.menu = item.kind
          item.kind = " " .. kinds[item.kind]
          if entry.completion_item.detail ~= nil and entry.completion_item.detail ~= "" then
            item.menu = entry.completion_item.detail
          else
            item.menu = ({
              copilot = "[Copilot]",
              path = "[Path]",
              nvim_lsp = "[LSP]",
              luasnip = "[Snippet]",
              buffer = "[Buffer]",
              treesitter = "[TreeSitter]"
            })[entry.source.name]
          end
          return item
        end,
      },
      preselect = cmp.PreselectMode.None,
      confirm_opts = {
        behavior = cmp.ConfirmBehavior.Replace,
        select = false,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-n>"] = cmp.mapping.scroll_docs(-4),
        ["<C-p>"] = cmp.mapping.scroll_docs(4),
        ["<C-CR>"] = cmp.mapping.complete(),
        ["<S-CR>"] = cmp.mapping.confirm(),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      sources = cmp.config.sources(
        {
          { name = 'nvim_lsp' },
          { name = "copilot" },
          { name = 'luasnip' },
          { name = "nvim_lua" },
        }, {
          { name = 'buffer' },
        }
      ),
    })

    -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline({ '/', '?' }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' }
      }
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = 'path' }
      }, {
        { name = 'cmdline' }
      })
    })
  end
}
