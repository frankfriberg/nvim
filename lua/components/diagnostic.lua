return {
  update = { "DiagnosticChanged", "BufEnter", "ModeChanged", "CursorMoved" },
  init = function(self)
    self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
    self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
  end,
  {
    condition = function(self)
      return self.errors > 0
    end,
    provider = function(self)
      return string.format("%s%s ", "e", self.errors)
    end,
    hl = { fg = "error" },
  },
  {
    condition = function(self)
      return self.warnings > 0
    end,
    provider = function(self)
      return string.format("%s%s ", "w", self.warnings)
    end,
    hl = { fg = "warn" },
  },
  {
    condition = function(self)
      return self.info > 0
    end,
    provider = function(self)
      return string.format("%s%s ", "i", self.info)
    end,
    hl = { fg = "info" },
  },
  {
    condition = function(self)
      return self.hints > 0
    end,
    provider = function(self)
      return string.format("%s%s ", "h", self.hints)
    end,
    hl = { fg = "hint" },
  },
}
