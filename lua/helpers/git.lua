local M = {}
M.last_branch = nil

M.is_rebase = function()
  local git_dir = vim.fn.systemlist("git rev-parse --git-dir")[1]
  local rebase_merge_dir = vim.fn.isdirectory(git_dir .. "/rebase-merge")
  return rebase_merge_dir == 1
end

M.get_current_branch = function()
  local branch = vim.trim(vim.fn.system("git branch --show-current"))
  if vim.v.shell_error == 0 then
    return branch
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

  if current_branch and M.last_branch ~= current_branch then
    vim.api.nvim_exec_autocmds("User", {
      pattern = "LazyGitBranchChanged",
      data = {
        old_branch = M.last_branch,
        new_branch = current_branch,
      },
    })
    M.last_branch = current_branch
  end
end

return M
