local M = {}
local custom = require("plugins.ui.icons").custom
local map = require("ff.map")

vim.g.autofix = true

function M.notify(message, status)
  vim.notify(
    message,
    vim.log.levels.INFO,
    { title = "Autolint", icon = status and custom.linting_enabled or custom.linting_disabled }
  )
end

function M.toggle()
  local status = vim.g.autofix
  vim.g.autofix = not status
  M.notify(status and "Enabled" or "Disabled", status)
end

function M.setup()
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("AutoLint", {}),
    callback = function()
      local lsp = vim.lsp.get_active_clients({ name = "eslint" })
      if vim.g.autofix and next(lsp) ~= nil then
        vim.cmd("EslintFixAll")
      end
    end,
  })
end

map.t({
  group = { "<leader>u", "Utils" },
  l = { M.toggle, "Toggle autolint" }
})

return M
