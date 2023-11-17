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
  {
    condition = function()
      return vim.bo.modifiable
    end,
    provider = " ",
    hl = function()
      return { fg = vim.bo.modified and "red" or "green" }
    end
  },
  {
    condition = function()
      return not vim.bo.modifiable or vim.bo.readonly
    end,
    provider = "󰍁 ",
    hl = "Orange",
  },
}

return M
