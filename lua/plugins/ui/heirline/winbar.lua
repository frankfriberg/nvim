local conditions = require("heirline.conditions")
local LspProviders = require("plugins.ui.heirline.components.lsp")
local U = require("plugins.ui.heirline.components.universal")

local Dir = {
  provider = function()
    local path = vim.fn.expand('%:p:~:.:h')
    local display = ""
    for part in path:gmatch("[^/]+") do
      display = display .. part .. "  "
    end
    return display
  end,
  hl = "Grey"
}

return {
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(0)
  end,
  Dir,
  U.FileFlags,
  U.FileIcon,
  U.FileName,
  U.Align,
  U.Align,
  LspProviders,
  U.Spacer(conditions.lsp_attached),
  U.FileIcon,
  U.FileType,
  U.Space,
}
