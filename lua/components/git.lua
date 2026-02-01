return {
  update = {
    "BufEnter",
    "BufLeave",
    "FocusGained",
    "WinClosed",
    "WinLeave",
    "WinEnter",
  },
  condition = function()
    return vim.g.is_git_repo
  end,
  {
    condition = function()
      return vim.g.is_git_rebase
    end,
    provider = "rebasing: ",
    hl = {
      bold = true,
    },
  },
  { provider = vim.g.branch_name },
  hl = function()
    return {
      fg = vim.g.is_git_rebase and "warn" or "ok",
    }
  end,
}
