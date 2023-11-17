local _ = {}

local m = require("ff.map")

_.setup = function(on_attach, capabilities)
  require("typescript-tools").setup({
    on_attach = function(client, bufnr)
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

      on_attach(client, bufnr)
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

return _
