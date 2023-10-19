local M = {}

vim.g.autoformat = true

function M.enabled()
  return vim.g.autoformat
end

function M.toggle()
  vim.g.autoformat = not vim.g.autoformat
  vim.notify(vim.g.autoformat and "Enabled" or "Disabled", vim.log.levels.INFO, { title = "Autoformat", icon = "󰗠" })
end

function M.format()
  local buf        = vim.api.nvim_get_current_buf()
  local conform, _ = pcall(require, "conform")

  if vim.g.autoformat == false then
    return
  end

  if conform then
    return require("conform").format({ bufnr = buf })
  end

  local formatters = M.get_formatters(buf)
  local client_ids = vim.tbl_map(function(client)
    return client.id
  end, formatters.active)

  if #client_ids == 0 then
    return
  end

  vim.lsp.buf.format({
    bufnr = buf,
    filter = function(client)
      return vim.tbl_contains(client_ids, client.id)
    end,
  })
  vim.cmd("silent! w")
end

function M.get_formatters(bufnr)
  local ft = vim.bo[bufnr].filetype
  local null_ls = package.loaded["null-ls"] and require("null-ls.sources").get_available(ft, "NULL_LS_FORMATTING") or {}

  local ret = {
    active = {},
    available = {},
    null_ls = null_ls,
  }

  local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
  for _, client in ipairs(clients) do
    if M.supports_format(client) then
      if (#null_ls > 0 and client.name == "null-ls") or #null_ls == 0 then
        table.insert(ret.active, client)
      else
        table.insert(ret.available, client)
      end
    end
  end

  return ret
end

function M.supports_format(client)
  if client.config and client.config.capabilities and client.config.capabilities.documentFormattingProvider == false then
    return false
  end
  return client.supports_method("textDocument/formatting") or client.supports_method("textDocument/rangeFormatting")
end

function M.setup()
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("AutoFormat", {}),
    callback = function()
      if vim.g.autoformat then
        M.format()
      end
    end,
  })
end

local map = require("ff.map")

map.t({
  group = { "<leader>u", "Utils" },
  f = { M.toggle, "Toggle autoformat" },
})

return M
