return {
  "mfussenegger/nvim-lint",
  enabled = false,
  config = function()
    local lint = require("lint")
    lint.linters_by_ft = {
      javascript = {
        "eslint"
      },
      typescript = {
        "eslint"
      },
      javascriptreact = {
        "eslint"
      },
      typescriptreact = {
        "eslint"
      }
    }

    vim.api.nvim_create_autocmd({ "InsertLeave", "BufWritePost", "TextChanged" }, {
      callback = function()
        lint.try_lint()
      end,
    })
  end
}
