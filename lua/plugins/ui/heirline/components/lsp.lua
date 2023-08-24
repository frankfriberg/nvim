local conditions = require("heirline.conditions")
local Space = require("plugins.ui.heirline.components.universal").Space

local NullLs = {
  condition = function(self)
    return self.null_ls
  end,
  init = function(self)
    local null_ls = require("null-ls")
    local null_clients = {}
    local buf_ft = vim.bo.filetype

    local sources = null_ls.get_sources()
    for _, source in ipairs(sources) do
      if source._validated then
        for ft_name, ft_active in pairs(source.filetypes) do
          if ft_name == buf_ft and ft_active then
            table.insert(null_clients, source.name)
          end
        end
      end
    end

    self.clients = null_clients
  end,
  Space,
  {
    provider = function(self)
      return table.concat(self.clients, " ")
    end,
    hl = { fg = "blue" },
  }
}

local Linters = {
  condition = function(self)
    return self.lint
  end,
  init = function(self)
    local lint = require("lint")
    local buf_ft = vim.bo.filetype
    local linters = {}

    for ft_k, ft_v in pairs(lint.linters_by_ft) do
      if type(ft_v) == "table" then
        for _, linter in ipairs(ft_v) do
          if buf_ft == ft_k then
            table.insert(linters, linter)
          end
        end
      elseif type(ft_v) == "string" then
        if buf_ft == ft_k then
          table.insert(linters, ft_v)
        end
      end
    end

    self.clients = linters
  end,
  Space,
  {
    provider = function(self)
      return table.concat(self.clients, " ")
    end,
    hl = { fg = "yellow" },
  }
}

local Formatters = {
  condition = function(self)
    return self.formatter
  end,
  init = function(self)
    local formatters = {}
    local buf_ft = vim.bo.filetype

    local formatter_util = require("formatter.util")
    for _, formatter in ipairs(formatter_util.get_available_formatters_for_ft(buf_ft)) do
      if formatter then
        table.insert(formatters, formatter)
      end
    end

    self.clients = formatters
  end,
  Space,
  {
    provider = function(self)
      return table.concat(self.clients, " ")
    end,
    hl = { fg = "orange" },
  }
}

local LspClients = {
  provider = function(self)
    return table.concat(self.clients, " ")
  end,
  hl = { fg = "green" }
}

return {
  condition = conditions.lsp_attached,
  update = { "LspAttach", "LspDetach", "VimEnter", "BufReadPost", "BufNewFile" },
  provider = "󰀴 ",
  init = function(self)
    local buf_clients = vim.lsp.get_active_clients({ bufnr = 0 })
    local lsp_clients = {}

    for _, client in pairs(buf_clients) do
      if client.name ~= "copilot" and client.name ~= "null-ls" then
        table.insert(lsp_clients, client.name)
      end
    end

    local null_ls, _   = pcall(require, "null-ls")
    local lint, _      = pcall(require, "lint")
    local formatter, _ = pcall(require, "formatter")

    self.null_ls       = null_ls
    self.lint          = lint
    self.formatter     = formatter
    self.clients       = lsp_clients
  end,
  LspClients,
  NullLs,
  Linters,
  Formatters,
}
