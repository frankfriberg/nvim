local M = {}
local last_branch = nil

M.is_rebase = function()
  local git_dir = vim.fn.systemlist("git rev-parse --git-dir")[1]
  local rebase_merge_dir = vim.fn.isdirectory(git_dir .. "/rebase-merge")
  return rebase_merge_dir == 1
end

M.get_current_branch = function()
  local result =
    vim.fn.systemlist("git symbolic-ref --short HEAD 2>/dev/null || git name-rev --name-only --always HEAD")
  if vim.v.shell_error == 0 then
    return vim.trim(result[1])
  else
    return nil
  end
end

M.current_branch = function()
  local branch = vim.fn.system("git branch --show-current")
  if vim.g.is_git_rebase then
    return vim.fn.systemlist("git log --format=%B -n 1 HEAD | cat")[1]
  end

  if branch ~= "" then
    return branch:gsub("\n", "")
  else
    return branch
  end
end

M.ahead_behind = function()
  local data = vim.fn.system("git rev-list --count --left-right HEAD...@{upstream}")
  local ahead, behind = data:match("(%d+)%s+(%d+)")
  local ahead_behind = {
    ahead = tonumber(ahead),
    behind = tonumber(behind),
  }

  return ahead_behind
end

M.changed = function()
  local current_branch = M.get_current_branch()

  if current_branch and last_branch ~= current_branch then
    vim.api.nvim_exec_autocmds("User", {
      pattern = "LazyGitBranchChanged",
      data = {
        old_branch = last_branch,
        new_branch = current_branch,
      },
    })
    last_branch = current_branch
  end
end

last_branch = M.get_current_branch()

return M
