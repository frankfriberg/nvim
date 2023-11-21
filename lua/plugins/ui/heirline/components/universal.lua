local M = {}
local devicons = require("nvim-web-devicons")

M.Align = { provider = "%=" }
M.Space = { provider = " " }
M.Spacer = function(condition)
  if condition then
    return {
      condition = condition,
      provider = " · ",
    }
  else
    return {
      provider = " · ",
    }
  end
end

M.FileFlags = {
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
    hl = "Orange",
  },
}

M.FileIcon = {
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

M.FileType = {
  provider = function(self)
    local extension = vim.bo.filetype
    self.icon, self.icon_color = devicons.get_icon_color_by_filetype(extension)
    return extension:gsub("^%l", string.upper)
  end,
  hl = function(self)
    return { fg = self.icon_color }
  end,
}

M.FileName = {
  provider = function(self)
    return self.filename == "" and "[No Name]" or vim.fn.fnamemodify(self.filename, ":t")
  end,
  hl = function()
    return vim.bo.modified and "DiagnosticUnderlineError" or "Fg"
  end
}

return M
