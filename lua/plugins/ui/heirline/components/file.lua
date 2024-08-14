local M = {}
local conditions = require("heirline.conditions")
local icons = require("mini.icons")

local function is_excluded()
  local excluded = {
    "neo-tree",
    "keymenu",
    "^git.*",
  }
  return conditions.buffer_matches({
    buftype = { "nofile", "prompt", "help", "quickfix" },
    filetype = excluded,
  })
end

local excluded_icons = {
  TelescopePrompt = "",
  NeogitStatus = "",
  minifiles = "󰉋",
}

M.Flags = {
  condition = function()
    return not is_excluded and (not vim.bo.modifiable or vim.bo.readonly)
  end,
  provider = "󰍁 ",
}

M.Icon = {
  provider = function(self)
    if is_excluded() and excluded_icons[vim.bo.filetype] then
      return excluded_icons[vim.bo.filetype] .. " "
    else
      return self.icon and (self.icon .. " ")
    end
  end,
}

M.Type = {
  provider = function(self)
    return self.filetype
  end,
}

M.Name = {
  provider = function(self)
    if is_excluded() then
      return vim.bo.filetype
    elseif self.filename == "" and vim.bo.buftype == "" then
      return "[No File]"
    elseif self.filename == "" then
      return vim.bo.buftype
    else
      local directory = vim.fn.fnamemodify(self.filename, ":h:t")
      local filename = vim.fn.fnamemodify(self.filename, ":t")
      return string.format("%s/%s", directory, filename)
    end
  end,
}

M.NameBlock = {
  condition = not is_excluded,
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(0)
    self.icon = icons.get("file", self.filename)
    self.filetype = vim.bo.filetype:gsub("^%l", string.upper)
  end,
  M.Icon,
  M.Flags,
  M.Name,
}

M.TypeBlock = {
  condition = is_excluded,
  M.Type,
}

return M
