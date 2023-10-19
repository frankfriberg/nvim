return {
  "williamboman/mason.nvim",
  event = "BufReadPre",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
    "hrsh7th/cmp-nvim-lsp",
    "jose-elias-alvarez/typescript.nvim",
    "folke/neodev.nvim",
    "b0o/schemastore.nvim",
    {
      "pmizio/typescript-tools.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
    }
  },
  opts = {
    autoformat = true,
  },
  config = function(_, opts)
    local on_attach = require("plugins.lsp.on-attach")
    local servers = {
      "lua_ls",
      "tsserver",
      "tailwindcss",
      "bashls",
      "jsonls",
      "html",
      "taplo",
      "marksman",
    }

    require("plugins.utils.format").setup(opts)

    vim.lsp.handlers["textDocument/publishDiagnostics"] =
        vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, { update_in_insert = false })

    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = servers,
      automatic_installation = true,
    })

    local cmp = require("cmp_nvim_lsp")

    local capabilities = cmp.default_capabilities() or vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true

    require("mason-lspconfig").setup_handlers({
      function(server_name)
        require("lspconfig")[server_name].setup({ on_attach, capabilities })
      end,
      ["tsserver"] = function()
        require("plugins.lsp.typescript-tools").setup(on_attach, capabilities)
      end,
      ["lua_ls"] = function()
        require("plugins.lsp.lua_ls").setup(on_attach, capabilities)
      end,
      ["jsonls"] = function()
        require("plugins.lsp.jsonls").setup(on_attach, capabilities)
      end,
      ["html"] = function()
        require("plugins.lsp.html").setup(on_attach, capabilities)
      end,
      ["bashls"] = function()
        require("lspconfig").bashls.setup({
          filetypes = { "sh", "bash", "zsh" },
          on_attach,
          capabilities,
        })
      end,
      ["tailwindcss"] = function()
        require("lspconfig").tailwindcss.setup({
          filetypes = { "html", "markdown", "css", "scss", "javascript", "javascriptreact", "typescript",
            "typescriptreact", "vue", "svelte" },
          on_attach,
          capabilities
        })
      end,
      ["volar"] = function()
        require("plugins.lsp.vue").volar(on_attach, capabilities)
      end,
      ["vuels"] = function()
        require("plugins.lsp.vue").vuels(on_attach, capabilities)
      end
    })
  end,
}
