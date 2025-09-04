return {
  {
    "mason-org/mason.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "mason-org/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "b0o/schemastore.nvim",
    },
    config = function()
      local on_attach = require("helpers.on-attach")

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = on_attach,
      })

      require("mason").setup({
        ui = {
          backdrop = 100,
          width = 0.5,
          height = 0.7,
        },
      })

      require("mason-tool-installer").setup({
        ensure_installed = {
          "stylua",
          "prettierd",
          "fixjson",
          "stylua",
          "shfmt",
          "actionlint",
        },
      })

      require("mason-lspconfig").setup({
        automatic_enable = {
          exclude = {
            "copilot",
          },
        },
        ensure_installed = {
          "copilot",
          "vtsls",
          "lua_ls",
          "eslint",
          "tailwindcss",
          "jsonls",
        },
      })
    end,
  },
}
