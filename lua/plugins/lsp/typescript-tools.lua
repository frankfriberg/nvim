return {
  "pmizio/typescript-tools.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "neovim/nvim-lspconfig"
  },
  config = function()
    local m = require("ff.map")
    local cmp_ok, cmp = pcall(require, "cmp_nvim_lsp")

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    if cmp_ok then
      capabilities = vim.tbl_deep_extend('force', capabilities, cmp.default_capabilities())
    end

    require("typescript-tools").setup({
      on_attach = function(client)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false

        m.t({
          group = { "<leader>t", "TypeScript" },
          r = { "<CMD>TSToolsRemoveUnused<CR>", "[TS] Remove Unused" },
          R = { "<CMD>TSToolsRemoveUnusedImports<CR>", "[TS] Remove Unused Imports" },
          o = { "<CMD>TSToolsOrganizeImports<CR>", "[TS] Organize Imports" },
          s = { "<CMD>TSToolsSortImports<CR>", "[TS] Sort Imports" },
          a = { "<CMD>TSToolsAddMissingImports<CR>", "[TS] Add Missing Imports" },
          x = { "<CMD>TSToolsFixAll<CR>", "[TS] Fix All" },
        })

        m.n("gs", "<CMD>TSToolsGoToSourceDefinition<CR>", "[TS] Go To Source Definition")
      end,
      capabilities,
      settings = {
        publish_diagnostic_on = "change",
        preferences = {
          importModuleSpecifier = "non-relative",
        }
      }
    })
  end
}
