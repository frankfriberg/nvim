return {
  "jose-elias-alvarez/null-ls.nvim",
  opts = function()
    local null_ls = require("null-ls")
    local on_attach = require("plugins.lsp.on-attach")

    local pint_formatter = {
      name = "pint",
      method = null_ls.methods.FORMATTING,
      filetypes = { "php" },
      generator = null_ls.formatter({
        command = "pint",
        args = {
          "--no-interaction",
          "--quiet",
          "$FILENAME",
        },
        to_stdin = false,
        to_temp_file = true,
      })
    }

    null_ls.register(pint_formatter)

    return {
      debounce = 500,
      on_attach = on_attach,
      sources = {
        null_ls.builtins.formatting.prettierd,
      },
    }
  end,
}
