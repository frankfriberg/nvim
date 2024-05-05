local M = {}
local conditions = require("heirline.conditions")
local devicons = require("nvim-web-devicons")

local function is_excluded()
  local excluded = {
    "neo-tree",
    "keymenu",
    "^git.*",
    "TelescopePrompt",
  }
  return conditions.buffer_matches({
    buftype = { "nofile", "prompt", "help", "quickfix" },
    filetype = excluded,
  })
end

M.Flags = {
  {
    condition = function()
      return not vim.bo.modifiable or vim.bo.readonly
    end,
    provider = "󰍁 ",
    hl = { fg = "error" },
  },
}

M.Icon = {
  provider = function(self)
    return self.icon and (self.icon .. " ")
  end,
  hl = function(self)
    return { fg = self.icon_color }
  end,
}

M.Type = {
  hl = function(self)
    return { fg = self.icon_color }
  end,
  flexible = 1,
  {
    provider = function(self)
      return self.filetype
    end,
  },
  {
    provider = "",
  },
}

M.Name = {
  provider = function(self)
    local name = self.filename == "" and "[No Name]" or vim.fn.fnamemodify(self.filename, ":t")
    local parent = vim.fn.fnamemodify(self.filename, ":p:h:t")
    return string.format("%s/%s", parent, name)
  end,
  hl = function()
    return vim.bo.modified and "DiagnosticUnderlineError" or "Normal"
  end,
}

M.NameBlock = {
  condition = not is_excluded,
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(0)
    self.extension = vim.bo.filetype
    self.icon, self.icon_color = devicons.get_icon_color_by_filetype(self.extension)
    self.filetype = self.extension:gsub("^%l", string.upper)
  end,
  M.Flags,
  M.Icon,
  M.Name,
}

M.TypeBlock = {
  condition = is_excluded,
  M.Type,
}

return M
