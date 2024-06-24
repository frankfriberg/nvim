local conditions = require("heirline.conditions")
local File = require("plugins.ui.heirline.components.file")
local Universal = require("plugins.ui.heirline.components.universal")

local DiagnosticItem = function(severity, next, icon, hl)
  return {
    condition = function(self)
      return self[severity] > 0
    end,
    Universal.Space,
    {
      provider = function(self)
        return string.format("%s %s", icon, self[severity])
      end,
    },
    hl = hl,
    {
      provider = function(self)
        local next_diag = 0

        for _, v in ipairs(next) do
          next_diag = next_diag + self[v]
        end

        return next ~= nil and next_diag > 0 and Universal.RightSpacerChar or Universal.RightEndChar
      end,
      hl = {
        bg = hl.fg,
        fg = hl.bg,
      },
    },
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
  DiagnosticItem("errors", { "warnings", "hints", "info" }, "󰬌", { bg = "error", fg = "bg" }),
  DiagnosticItem("warnings", { "hints", "info" }, "󰬞", { bg = "warn", fg = "bg" }),
  DiagnosticItem("hints", { "info" }, "󰬐", { bg = "hint", fg = "bg" }),
  DiagnosticItem("info", nil, "󰬏", { bg = "info", fg = "bg" }),
}

local WinbarFile = {
  update = { "DiagnosticChanged", "BufEnter" },
  Universal.Align,
  Universal.LeftEnd,
  {
    File.NameBlock,
    File.TypeBlock,
    hl = { fg = "bg", bg = "file" },
  },
  {
    provider = function()
      return conditions.has_diagnostics() and Universal.RightSpacerChar or Universal.RightEndChar
    end,
  },
  Diagnostics,
  Universal.Align,
  hl = "Normal",
}

return {
  WinbarFile,
}
