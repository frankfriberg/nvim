local ok, conform = pcall(require, "conform")

if not ok then
  return
end

local M = {}

M.Formatters = {
  init = function(self)
    self.formatters = conform.list_formatters_to_run(0)
  end,
  provider = function(self)
    local formatters = {}
    for _, formatter in ipairs(self.formatters) do
      table.insert(formatters, formatter.name)
    end

    return table.concat(formatters, " ")
  end,
  hl = "DiagnosticInfo",
}

M.has_formatters = function()
  return #conform.list_formatters_to_run(0) > 0
end

return M
