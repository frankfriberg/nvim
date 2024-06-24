local M = {}

M.RightSpacerChar = "▉"
M.LeftSpacerChar = "🮋"
M.LeftEndChar = ""
M.RightEndChar = ""

M.Align = { provider = "%=" }
M.Space = { provider = " " }
M.Empty = { provider = "" }
M.LeftEnd = { provider = M.LeftEndChar }
M.RightEnd = { provider = M.RightEndChar }
M.RightSpacer = { provider = M.RightSpacerChar }
M.LeftSpacer = { provider = M.LeftSpacerChar }

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
