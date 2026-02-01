local Name = {
  provider = function(self)
    if self.filename == "" and vim.bo.buftype == "" then
      return "[No File]"
    elseif self.filename == "" then
      return vim.bo.buftype
    elseif self.filename:match("opencode") then
      return "opencode"
    else
      local directory = vim.fn.fnamemodify(self.filename, ":h:t")
      local filename = vim.fn.fnamemodify(self.filename, ":t")
      return string.format("%s/%s", directory, filename)
    end
  end,
  hl = function()
    if vim.bo.modified then
      return "macro"
    end
  end,
}

return {
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(0)
    self.icon = require("mini.icons").get("file", self.filename)
    self.filetype = vim.bo.filetype:gsub("^%l", string.upper)
  end,
  Name,
  { provider = " " },
}
