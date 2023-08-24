local _ = {}

_.setup = function(on_attach, capabilities)
  require("neodev").setup()
  require("lspconfig").lua_ls.setup({
    on_attach = on_attach,
    update_delay = 500,
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          library = {
            vim.api.nvim_get_runtime_file("", true),
          },
          maxPreload = 100000,
          checkThirdParty = false, -- THIS IS THE IMPORTANT LINE TO ADD
          preloadFileSize = 10000,
          update_in_insert = false,
        },
        format = {
          enable = true,
          defaultConfig = {
            indent_style = "space",
            indent_size = "2",
            max_line_length = 120
          }
        },
      },
    },
    capabilities = capabilities,
  })
end

return _
