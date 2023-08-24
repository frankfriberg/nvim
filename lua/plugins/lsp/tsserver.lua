local _ = {}

local m = require("ff.map")

_.setup = function(on_attach, capabilities)
  local ts = require("typescript")
  ts.setup({
    server = {
      settings = {
        completions = {
          completeFunctionCalls = true
        }
      },
      on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false

        m.t({
          group = { "<leader>t", "TypeScript" },
          r = { ts.actions.removeUnused, "[TS] Remove Unused" },
          o = { ts.actions.removeUnused, "[TS] Organize Imports" },
          a = { ts.actions.addMissingImports, "[TS] Add Missing Imports" },
          x = { ts.actions.fixAll, "[TS] Fix All" },
          n = { "<CMD>TypescriptRenameFile<CR>", "[TS] Rename File" },
        })
        on_attach(client, bufnr)
      end,
      capabilities = capabilities,
    },
  })
end

return _
