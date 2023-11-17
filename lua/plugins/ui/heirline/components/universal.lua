local M = {}

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

M.FileType = {
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
