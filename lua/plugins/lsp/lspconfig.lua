return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "b0o/schemastore.nvim",

      { "folke/neodev.nvim", opts = {} },
    },
    config = function()
      local cmp_ok, cmp = pcall(require, "cmp_nvim_lsp")
      local on_attach = require("helpers.on-attach")

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = on_attach,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()

      if cmp_ok then
        capabilities = vim.tbl_deep_extend("force", capabilities, cmp.default_capabilities())
      end

      local servers = {
        lua_ls = require("plugins.lsp.servers.lua_ls"),
        eslint = require("plugins.lsp.servers.eslint"),
        tailwindcss = require("plugins.lsp.servers.tailwindcss"),
        jsonls = require("plugins.lsp.servers.jsonls"),
      }

      require("mason").setup({
        ui = {
          border = "rounded",
        },
      })

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        "stylua",
        "prettierd",
      })

      require("mason-tool-installer").setup({
        ensure_installed = ensure_installed,
      })

      require("mason-lspconfig").setup({
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
            require("lspconfig")[server_name].setup(server)
          end,
        },
      })
    end,
  },
}
