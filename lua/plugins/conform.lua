return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      javascript = { "prettierd" },
      typescript = { "prettierd" },
      javascriptreact = { "prettierd" },
      typescriptreact = { "prettierd" }
    },
    format_on_save = function()
      if not vim.g.autoformat then
        return
      end

      return { timeout_ms = 500, lsp_fallback = true }
    end,
  },
}
