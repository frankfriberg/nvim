local Universal = require("plugins.ui.heirline.components.universal")
local git = require("helpers.icons").git

local GitRebase = {
  provider = function()
    return vim.g.is_git_rebase and "Rebasing: "
  end,
  hl = {
    bold = true,
  },
}

local GitBranch = {
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

local gitStatusProvider = function(status, icon)
  return {
    condition = function(self)
      return self[status] ~= nil and self[status] > 0
    end,
    provider = function(self)
      return icon.format(" %s %s", icon, self[status])
    end,
  }
end

local GitAheadBehind = {
  init = function(self)
    local ahead_behind = vim.g.ahead_behind
    self.git_ahead = ahead_behind.ahead
    self.git_behind = ahead_behind.behind
    self.git_has_status = ahead_behind.ahead and ahead_behind.behind
  end,
  gitStatusProvider("git_ahead", git.ahead),
  gitStatusProvider("git_behind", git.behind),
}

return {
  update = {
    "BufEnter",
    "BufLeave",
    "FocusGained",
    "WinClosed",
    "WinLeave",
    "WinEnter",
  },
  condition = Universal.is_git_repo,
  Universal.Space,
  GitBranch,
  GitAheadBehind,
  {
    Universal.RightEnd,
    hl = function()
      return {
        fg = vim.g.is_git_rebase and "warn" or "ok",
        bg = "bg",
      }
    end,
  },
  hl = function()
    return {
      fg = "bg",
      bg = vim.g.is_git_rebase and "warn" or "ok",
    }
  end,
}
