return {
  condition = function()
    local ok, conform = pcall(require, "conform")

    local has_formatters = #conform.list_formatters_to_run(0) > 0

    return ok and has_formatters
  end,
  init = function(self)
    local conform = require("conform")
    self.formatters = conform.list_formatters_to_run(0)
  end,
  provider = function(self)
    local formatters = {}
    for _, formatter in ipairs(self.formatters) do
      table.insert(formatters, formatter.name)
    end

    return table.concat(formatters, " ") .. " "
  end,
  hl = { fg = "operator" },
}
