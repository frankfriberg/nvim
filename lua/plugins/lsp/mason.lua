return {
  {
    "mason-org/mason.nvim",
    dependencies = {
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "mason-org/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
      "b0o/schemastore.nvim",
      "artemave/workspace-diagnostics.nvim",
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
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
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
          "copilot",
          "terraform",
          "lua_ls",
          "vtsls",
          "eslint",
          "tailwindcss",
          "jsonls",
          "tflint",
        },
      })

      require("mason-lspconfig").setup({
        automatic_enable = {
          exclude = {
            "copilot",
          },
        },
      })
    end,
  },
}
