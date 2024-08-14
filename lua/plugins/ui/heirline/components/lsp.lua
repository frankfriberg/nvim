local M = {}

local names = {
  tailwindcss = "tailwind",
  ["typescript-tools"] = "typescript",
}

M.LanguageServers = {
  update = { "LspAttach" },
  init = function(self)
    self.servers = vim.lsp.get_clients({ bufnr = 0 })
  end,
  provider = function(self)
    local servers = {}
    for _, server in ipairs(self.servers) do
      local name = names[server.name]
      table.insert(servers, name or server.name)
    end

    return table.concat(servers, " ")
  end,
  hl = "DiagnosticHint",
}

M.has_language_servers = function()
  return #vim.lsp.get_clients({ bufnr = 0 }) > 0
end

return M
