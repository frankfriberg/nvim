local git = require("helpers.icons").git

local function is_git_repo()
  return vim.g.is_git_repo
end

local GitRebase = {
  condition = is_git_repo,
  provider = function()
    return vim.g.is_git_rebase and "Rebasing: "
  end,
  hl = {
    fg = "warn",
  },
}

local GitBranch = {
  condition = is_git_repo,
  update = { "BufEnter", "BufLeave", "FocusGained", "WinClosed" },
  hl = {
    fg = "ok",
  },
  {
    provider = "󰘬 ",
  },
  GitRebase,
  {
    provider = function()
      local branch_name = vim.g.branch_name
      return branch_name
    end,
  },
}

local gitStatusProvider = function(status, icon, highlight)
  return {
    condition = function(self)
      return self[status] ~= nil and self[status] > 0
    end,
    provider = function(self)
      return icon.format(" %s %s", icon, self[status])
    end,
    hl = {
      fg = highlight,
    },
  }
end

local GitAheadBehind = {
  condition = is_git_repo,
  update = { "WinNew", "WinClosed", "BufEnter" },
  init = function(self)
    local ahead_behind = vim.g.ahead_behind
    self.git_ahead = ahead_behind.ahead
    self.git_behind = ahead_behind.behind
    self.git_has_status = ahead_behind.ahead and ahead_behind.behind
  end,
  gitStatusProvider("git_ahead", git.ahead, "info"),
  gitStatusProvider("git_behind", git.behind, "hint"),
}

return {
  flexible = 1,
  {
    GitBranch,
    GitAheadBehind,
  },
  {
    GitBranch,
  },
}
