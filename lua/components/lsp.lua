return {
  update = { "LspAttach", "LspDetach", "BufEnter" },
  init = function(self)
    self.servers = vim.lsp.get_clients({ bufnr = 0 })
  end,
  condition = function()
    return #vim.lsp.get_clients({ bufnr = 0 }) > 0
  end,
  provider = function(self)
    local servers = {}
    for _, server in ipairs(self.servers) do
      table.insert(servers, server.name)
    end

    return table.concat(servers, " ") .. " "
  end,
  hl = { fg = "hint" },
}
