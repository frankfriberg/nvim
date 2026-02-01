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

M.has_language_servers = function()
  return #vim.lsp.get_clients({ bufnr = 0 }) > 0
end

M.has_formatters = function()
  local ok, conform = pcall(require, "conform")

  if not ok then
    return false
  end

  return #conform.list_formatters_to_run(0) > 0
end

return M
