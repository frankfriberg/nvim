local M = {}
local conditions = require("heirline.conditions")
local devicons = require("nvim-web-devicons")
local Universal = require("plugins.ui.heirline.components.universal")

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
  },
}

M.Icon = {
  provider = function(self)
    return self.icon and (self.icon .. " ")
  end,
}

M.Type = {
  hl = function(self)
    return { fg = self.icon_color }
  end,
  provider = function(self)
    return self.filetype
  end,
}

M.Name = {
  provider = function(self)
    local name = self.filename == "" and vim.bo.buftype or vim.fn.fnamemodify(self.filename, ":t")
    local parent = vim.fn.fnamemodify(self.filename, self.filename == "" and ":t" or ":p:h:t")
    return string.format("%s/%s", parent, name)
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
  {
    Universal.LeftSpacer,
    hl = {
      fg = "file",
      bg = "bg",
    },
  },
  M.Flags,
  M.Icon,
  M.Name,
  {
    Universal.is_git_repo() and Universal.RightSpacer or Universal.RightEnd,
    hl = {
      fg = "file",
      bg = "bg",
    },
  },
  hl = function()
    return { fg = "bg", bg = "file" }
  end,
}

M.TypeBlock = {
  condition = is_excluded,
  M.Type,
}

return M
