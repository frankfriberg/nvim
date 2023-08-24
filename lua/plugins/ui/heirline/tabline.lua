local utils = require("heirline.utils")
local BufferLine = require("plugins.ui.bufferline")

local function padding(self, text, number)
  local width = vim.api.nvim_win_get_width(self.winid)
  local pad = math.ceil((width - #text) / number)
  return string.rep(" ", pad) .. text .. string.rep(" ", pad)
end

local Tabpage = {
  provider = function(self)
    return "%" .. self.tabnr .. "T " .. self.tabpage .. " %T"
  end,
  hl = function(self)
    if self.is_active then
      return { fg = "fg" }
    else
      return { fg = "red", bg = "dark_bg" }
    end
  end,
}

local TabPages = {
  { provider = "%=" },
  utils.make_tablist(Tabpage),
}

local TabLineOffset = {
  condition = function(self)
    local win = vim.api.nvim_tabpage_list_wins(0)[1]
    local bufnr = vim.api.nvim_win_get_buf(win)
    self.winid = win

    if vim.bo[bufnr].filetype == "neo-tree" then
      self.title = ""
      return true
    end
  end,
  provider = function(self)
    return padding(self, self.title, 2)
  end,
  hl = {
    bg = "dark_bg"
  },
}

return { TabLineOffset, BufferLine, TabPages }
