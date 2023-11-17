local conditions = require("heirline.conditions")
local LspProviders = require("plugins.ui.heirline.components.lsp")
local universal = require("plugins.ui.heirline.components.universal")
local Align, Space, Spacer, FileFlags = universal.Align, universal.Space, universal.Spacer, universal.FileFlags

local FileName = {
  provider = function(self)
    return self.filename == "" and "[No Name]" or vim.fn.fnamemodify(self.filename, ":t")
  end,
  hl = function()
    return { fg = "fg", sp = "red", underline = vim.bo.modified and true }
  end
}

local Dir = {
  provider = function()
    local path = vim.fn.expand('%:p:~:.:h')
    local display = ""
    for part in path:gmatch("[^/]+") do
      display = display .. part .. "  "
    end
    return display
  end,

local FileIcon = {
  init = function(self)
    local filename = vim.api.nvim_buf_get_name(0)
    local extension = vim.fn.fnamemodify(filename, ":e")
    self.icon, self.icon_color =
        require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
  end,
  provider = function(self)
    return self.icon and (self.icon .. " ")
  end,
  hl = function(self)
    return { fg = self.icon_color }
  end,
}

local FileType = {
  provider = function(self)
    local filename = vim.api.nvim_buf_get_name(0)
    local extension = vim.bo.filetype
    self.icon, self.icon_color =
        require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
    return extension:gsub("^%l", string.upper)
  end,
  hl = function(self)
    return { fg = self.icon_color }
  end,
  hl = "Grey"
}

return {
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(0)
  end,
  Dir,
  FileFlags,
  FileName,
  Align,
  Align,
  LspProviders,
  Spacer(conditions.lsp_attached),
  FileIcon,
  FileType,
  Space,
}
