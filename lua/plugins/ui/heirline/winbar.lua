local conditions = require("heirline.conditions")
local File = require("plugins.ui.heirline.components.file")
local Universal = require("plugins.ui.heirline.components.universal")
local Formatters = require("plugins.ui.heirline.components.formatters")
local Servers = require("plugins.ui.heirline.components.lsp")

local DiagnosticItem = function(severity, next, icon, hl)
  return {
    condition = function(self)
      return self[severity] > 0
    end,
    {
      provider = function(self)
        return string.format("%s %s", icon, self[severity])
      end,
    },
    {
      condition = function(self)
        if next == nil then
          return false
        end

        for _, sibling in ipairs(next) do
          if self[sibling] > 0 then
            return true
          end
        end

        return false
      end,
      Universal.Space,
    },
    hl = hl,
  }
end

local Diagnostics = {
  condition = conditions.has_diagnostics,
  init = function(self)
    self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
    self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
  end,
  DiagnosticItem("errors", { "warnings", "hints", "info" }, "󰬌", { fg = "error" }),
  DiagnosticItem("warnings", { "hints", "info" }, "󰬞", { fg = "warn" }),
  DiagnosticItem("hints", { "info" }, "󰬐", { fg = "hint" }),
  DiagnosticItem("info", nil, "󰬏", { fg = "info" }),
}

local Winbar = {
  update = { "DiagnosticChanged", "BufEnter", "ModeChanged", "TextChanged", "BufWrite" },
  Universal.Align,
  {
    File.NameBlock,
    File.TypeBlock,
  },
  Universal.Spacer(conditions.has_diagnostics),
  Diagnostics,
  Universal.Spacer(Formatters.has_formatters),
  Formatters.Formatters,
  Universal.Spacer(Servers.has_language_servers),
  Servers.LanguageServers,
  Universal.Align,
  hl = "Normal",
}

return {
  Winbar,
}
