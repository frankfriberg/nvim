local utils = require("heirline.utils")

local function BufferName(name, bufnr)
  for _, buf_hndl in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf_hndl) and buf_hndl ~= bufnr then
      local buf_name = vim.api.nvim_buf_get_name(buf_hndl)
      local filename = vim.fn.fnamemodify(buf_name, ":t")
      local active_name = vim.fn.fnamemodify(name, ":t")
      if filename == active_name then
        return vim.fn.fnamemodify(buf_name, ":p:h:t") .. "/" .. filename
        -- return string.match(vim.fn.fnamemodify(name, ":p:h:t"), "./(.)") .. "/" .. active_name
      end
    end
  end

  return vim.fn.fnamemodify(name, ":t")
end

local Space = { provider = " " }

local BufferFileName = {
  provider = function(self)
    local filename = self.filename
    filename = filename == "" and "[No Name]" or BufferName(filename, self.bufnr)
    return filename
  end,
  hl = function(self)
    if self.is_active then
      return "Fg"
    else
      return "Fg"
    end
  end,
}

local BufferFileFlags = {
  {
    provider = function(self)
      if vim.api.nvim_buf_get_option(self.bufnr, "modified") then
        return " "
      else
        return "  "
      end
    end,
    hl = "Red",
  },
  {
    condition = function(self)
      return not vim.api.nvim_buf_get_option(self.bufnr, "modifiable")
          or vim.api.nvim_buf_get_option(self.bufnr, "readonly")
    end,
    provider = function()
      return " "
    end,
    hl = "Orange",
  },
}

local BufferFileIcon = {
  init = function(self)
    local filename = self.filename
    local extension = vim.fn.fnamemodify(filename, ":e")
    self.icon, self.icon_color =
        require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
  end,
  provider = function(self)
    if vim.api.nvim_buf_get_option(self.bufnr, "buftype") == "terminal" then
      return ""
    else
      return self.icon and (self.icon .. " ")
    end
  end,
  hl = function(self)
    if vim.api.nvim_buf_get_option(self.bufnr, "buftype") == "terminal" then
      return "Orange"
    elseif self.is_active then
      return "Fg"
    else
      return { fg = self.icon_color }
    end
  end,
}

local BufferSpacer = {
  provider = "🮇",
  hl = function(self)
    if self.is_active then
      return { fg = "bg", bg = "bg" }
    else
      return { fg = "bg", bg = "dark_bg" }
    end
  end,
}

local BufferlineFileNameBlock = {
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(self.bufnr)
  end,
  hl = function(self)
    if self.is_active then
      return "Fg"
    else
      return "FloatShadow"
    end
  end,
  -- Space,
  Space,
  Space,
  BufferFileIcon,
  BufferFileName,
  BufferFileFlags,
  Space,
  -- BufferSpacer,
}

local BufferLine = utils.make_buflist(
  BufferlineFileNameBlock,
  { provider = "←", hl = { fg = "green", bg = "bg" } },
  { provider = "→", hl = { fg = "green", bg = "bg" } }
)

return BufferLine
