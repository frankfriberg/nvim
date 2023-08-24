local M = {}

M.volar = function(on_attach, capabilities)
  require("lspconfig").volar.setup({
    on_attach = function(client, bufnr)
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
      on_attach(client, bufnr)
    end,
    capabilities,
  })
end

M.vuels = function(on_attach, capabilities)
  require("lspconfig").vuels.setup({
    on_attach,
    capabilities,
    init_options = {
      config = {
        css = {},
        emmet = {},
        html = {
          suggest = {},
        },
        javascript = {
          format = {},
        },
        stylusSupremacy = {},
        typescript = {
          format = {},
        },
        vetur = {
          completion = {
            autoImport = true,
            tagCasing = "PascalCase",
            useScaffoldSnippets = false,
          },
          format = {
            defaultFormatter = {
              js = "prettier",
              ts = "prettier",
            },
            defaultFormatterOptions = {},
            scriptInitialIndent = false,
            styleInitialIndent = false,
          },
          useWorkspaceDependencies = true,
          validation = {
            script = true,
            style = false,
            template = true,
          },
        },
      },
    },
  })
end

return M
