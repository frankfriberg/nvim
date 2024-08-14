local M = {}

M.RightSpacerChar = "▉"
M.LeftSpacerChar = "🮋"
M.LeftEndChar = ""
M.RightEndChar = ""
M.Seperator = " | "

M.Align = { provider = "%=" }
M.Space = { provider = " " }
M.Empty = { provider = "" }
M.LeftEnd = { provider = M.LeftEndChar }
M.RightEnd = { provider = M.RightEndChar }
M.RightSpacer = { provider = M.RightSpacerChar }
M.LeftSpacer = { provider = M.LeftSpacerChar }

M.Spacer = function(condition)
  return {
    condition = condition or nil,
    provider = M.Seperator,
    hl = "Normal",
  }
end

M.is_git_repo = function()
  return vim.g.is_git_repo
end

return M
