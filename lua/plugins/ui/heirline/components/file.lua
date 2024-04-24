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
  -- {
  --   condition = function()
  --     return vim.bo.modifiable
  --   end,
  --   provider = " ",
  --   hl = function()
  --     return vim.bo.modified and "Red" or "Green"
  --   end
  -- },
  {
    condition = function()
      return not vim.bo.modifiable or vim.bo.readonly
    end,
    provider = "󰍁 ",
    hl = { fg = "diag_error" },
  },
}

M.Icon = {
  init = function(self)
    local extension = vim.bo.filetype
    self.icon, self.icon_color = devicons.get_icon_color_by_filetype(extension)
  end,
  provider = function(self)
    return self.icon and (self.icon .. " ")
  end,
  hl = function(self)
    return { fg = self.icon_color }
  end,
}

M.Type = {
  init = function(self)
    local extension = vim.bo.filetype
    self.icon, self.icon_color = devicons.get_icon_color_by_filetype(extension)
    self.filetype = extension:gsub("^%l", string.upper)
  end,
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
    return self.filename == "" and "[No Name]" or vim.fn.fnamemodify(self.filename, ":t")
  end,
  hl = function()
    return vim.bo.modified and "DiagnosticUnderlineError" or "Normal"
  end,
}

M.NameBlock = {
  condition = function()
    return not is_excluded()
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
