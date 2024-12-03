---@diagnostic disable: missing-fields
return {
  "saghen/blink.cmp",
  lazy = false,
  build = "cargo build --release",
  dependencies = "rafamadriz/friendly-snippets",
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      preset = "default",
      ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      ["<S-CR>"] = { "accept" },
    },
    nerd_font_variant = "mono",
    highlight = {
      use_nvim_cmp_as_default = true,
    },
    sources = {
      completion = {
        enabled_providers = { "lsp", "path", "buffer" },
      },
      providers = {
        path = {
          name = "Path",
          module = "blink.cmp.sources.path",
          score_offset = 3,
          opts = {
            trailing_slash = false,
            label_trailing_slash = true,
            get_cwd = function(context)
              return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
            end,
            show_hidden_files_by_default = false,
            fallback_for = { "lsp" },
          },
        },
      },
    },
    completion = {
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 0,
        window = {
          border = "rounded",
          winblend = vim.o.winblend,
        },
      },
      signature = {
        enabled = true,
        window = {
          border = "rounded",
          winblend = vim.o.winblend,
        },
      },
      menu = {
        border = "rounded",
        min_width = 30,
        columns = { { "kind_icon" }, { "label", "label_description" }, { "label_detail" } },
        padding = 0,
        draw = {
          components = {
            label_detail = {
              width = { max = 30 },
              text = function(ctx)
                return ctx.label_detail
              end,
              highlight = "Comment",
            },
          },
        },
      },
    },
  },
}
