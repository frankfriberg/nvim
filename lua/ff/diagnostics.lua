local map = require("helpers.map")

-- Diagnostic configuration.
vim.diagnostic.config({
  float = {
    source = "if_many",
    scope = "cursor",
    focusable = true,
  },
  jump = {
    float = true,
  },
  update_in_insert = true,
  signs = false,
  severity_sort = true,
  virtual_text = true,
  virtual_lines = false,
})

local diagnostic_goto = function(next, severity)
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    vim.diagnostic.jump({ severity = severity, count = next and 1 or -1 })
  end
end

map.t({
  ["]d"] = { diagnostic_goto(true), desc = "Next Diagnostic" },
  ["[d"] = { diagnostic_goto(false), desc = "Prev Diagnostic" },
  ["]e"] = { diagnostic_goto(true, "ERROR"), desc = "Next Error" },
  ["[e"] = { diagnostic_goto(false, "ERROR"), desc = "Prev Error" },
  ["]w"] = { diagnostic_goto(true, "WARN"), desc = "Next Warning" },
  ["[w"] = { diagnostic_goto(false, "WARN"), desc = "Prev Warning" },
})
