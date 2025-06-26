local js_formatters = { "prettierd", "biome-check" }

return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      javascript = js_formatters,
      typescript = js_formatters,
      javascriptreact = js_formatters,
      typescriptreact = js_formatters,
      css = js_formatters,
      json = { "prettierd", "biome-check", "fixjson" },
      lua = { "stylua" },
      sh = { "shfmt" },
      [".conf"] = { "shfmt" },
    },
    formatters = {
      ["biome-check"] = {
        require_cwd = true,
      },
      prettierd = {
        condition = function(_, ctx)
          return vim.fs.find("biome.json", { upward = true, path = ctx.dirname })[1] == nil
        end,
      },
    },
    format_on_save = {
      lsp_format = "fallback",
      timeout_ms = 500,
    },
  },
}
