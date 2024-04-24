local M = {}

M.Align = { provider = "%=" }
M.Space = { provider = " " }
M.Empty = { provider = "" }
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

return M
