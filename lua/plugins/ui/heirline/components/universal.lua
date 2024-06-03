local M = {}

M.Align = { provider = "%=" }
M.Space = { provider = " " }
M.Empty = { provider = "" }
M.LeftEnd = { provider = "" }
M.RightEnd = { provider = "" }
M.RightSpacer = { provider = "▉" }
M.LeftSpacer = { provider = "🮋" }

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

M.is_git_repo = function()
  return vim.g.is_git_repo
end

return M
