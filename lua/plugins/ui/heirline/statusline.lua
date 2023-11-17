local conditions = require("heirline.conditions")
local utils = require("heirline.utils")
local U = require("plugins.ui.heirline.components.universal")
local custom = require("plugins.ui.icons").custom
local git = require("plugins.ui.icons").git

local function is_excluded()
  local excluded = {
    "neo-tree",
    "keymenu",
    "^git.*",
    "TelescopePrompt",
  }
  return conditions.buffer_matches({
    buftype = { "nofile", "prompt", "help", "quickfix" },
    filetype = excluded
  })
end

local function is_git_repo()
  return vim.g.is_git_repo
end

local ViMode = {
  update = { "ModeChanged" },
  init = function(self)
    self.mode = vim.fn.mode(1)
  end,
  static = {
    mode_name = {
      n        = 'normal',
      no       = 'op',
      nov      = 'op',
      noV      = 'op',
      ["no"]  = 'op',
      niI      = 'normal',
      niR      = 'normal',
      niV      = 'normal',
      nt       = 'normal',
      v        = "visual",
      V        = 'visual_lines',
      [""]    = 'visual_block',
      s        = "select",
      S        = 'select',
      [""]    = "block",
      i        = 'insert',
      ic       = 'insert',
      ix       = 'insert',
      R        = 'replace',
      Rc       = 'replace',
      Rv       = 'v_replace',
      Rx       = 'replace',
      c        = 'command',
      cv       = 'command',
      ce       = 'command',
      r        = 'enter',
      rm       = 'more',
      ["r?"]   = 'confirm',
      ["!"]    = 'shell',
      t        = 'terminal',
      ["null"] = 'none',
    },
    mode_label = {
      normal       = '󰰓 Normal',
      op           = '󰲞 Op',
      visual       = '󰰫 Visual',
      visual_lines = '󰰫 Visual Lines',
      visual_block = '󰰫 Visual Block',
      select       = '󰰢 Select',
      block        = '󰯯 Block',
      insert       = '󰰄 Insert',
      replace      = '󰰟 Replace',
      v_replace    = '󰰟 V-Replace',
      command      = '󰯲 Command',
      enter        = '󰯸 Enter',
      more         = 'More',
      confirm      = 'Confirm',
      shell        = 'Shell',
      terminal     = 'Terminal',
      none         = 'None'
    },
    mode_colors = {
      n = "Fg",
      i = "Orange",
      v = "Blue",
      V = "Blue",
      ["\22"] = "Blue",
      c = "Green",
      s = "Purple",
      S = "Purple",
      ["\19"] = "Purple",
      R = "Yellow",
      r = "Yellow",
      ["!"] = "Red",
      t = "Red",
    },
  },
  provider = function(self)
    return "%2(" .. self.mode_label[self.mode_name[self.mode]] .. "%)"
  end,
  hl = function(self)
    local mode = self.mode:sub(1, 1) -- get only the first mode character
    return self.mode_colors[mode]
  end,
}

local SimpleDiag = function(self, diag)
  if (diag <= 10) then
    return self.numbers[diag]
  else
    return "󰐙 "
  end
end

local Diagnostics = {
  condition = conditions.has_diagnostics,
  static = {
    error_icon = vim.fn.sign_getdefined("DiagnosticSignError")[1].text,
    warn_icon = vim.fn.sign_getdefined("DiagnosticSignWarn")[1].text,
    info_icon = vim.fn.sign_getdefined("DiagnosticSignInfo")[1].text,
    hint_icon = vim.fn.sign_getdefined("DiagnosticSignHint")[1].text,
    numbers = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 ", "󰲭 ", "󰲯 ", "󰲱 ", "󰿭 " }
  },
  init = function(self)
    self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
    self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
  end,
  update = { "DiagnosticChanged", "BufWrite", "BufEnter" },
  U.Space,
  {
    provider = function(self)
      return self.errors > 0 and SimpleDiag(self, self.errors)
    end,
    hl = "DiagnosticSignError",
  },
  {
    provider = function(self)
      return self.warnings > 0 and SimpleDiag(self, self.warnings)
    end,
    hl = "DiagnosticSignWarn",
  },
  {
    provider = function(self)
      return self.info > 0 and SimpleDiag(self, self.info)
    end,
    hl = "DiagnosticSignInfo",
  },
  {
    provider = function(self)
      return self.hints > 0 and SimpleDiag(self, self.hints)
    end,
    hl = "DiagnosticSignHint",
  },
}

FileNameBlock = {
  condition = function()
    return not is_excluded()
  end,
  U.FileFlags,
  U.FileIcon,
  U.FileName,
  Diagnostics,
}

FileTypeBlock = {
  condition = is_excluded,
  U.FileType,
}


local Git = {
  condition = is_git_repo,
  update = { "WinNew", "WinClosed", "BufEnter", "FocusGained" },
  provider = function()
    ---@diagnostic disable-next-line: undefined-field
    local branch_name = vim.g.branch_name
    local editor_width = vim.o.columns
    local maxLength = math.floor(editor_width * 0.25)
    if not conditions.width_percent_below(#branch_name, maxLength) then
      branch_name = string.sub(branch_name, 1, 20) .. "..."
    end
    return string.format("󰘬 %s", branch_name)
  end,
  hl = "Aqua",
}

local gitStatusProvider = function(status, icon, highlight)
  return {
    condition = function(self)
      return self[status] ~= nil and self[status] > 0
    end,
    provider = function(self)
      return icon.format(" %s %s", icon, self[status])
    end,
    hl = highlight,
  }
end

local GitStatus = {
  condition = is_git_repo,
  update = { "BufEnter" },
  init = function(self)
    local git_counts = vim.g.git_status
    self.git_added = git_counts.A
    self.git_conflict = git_counts.C
    self.git_deleted = git_counts.D
    self.git_modified = git_counts.M
    self.git_untracked = git_counts.untracked
  end,
  gitStatusProvider("git_added", git.added, "Blue"),
  gitStatusProvider("git_conflict", git.conflict, "Blue"),
  gitStatusProvider("git_deleted", git.deleted, "Blue"),
  gitStatusProvider("git_modified", git.modified, "Orange"),
  gitStatusProvider("git_untracked", git.untracked, "Purple"),
}

local GitAheadBehind = {
  condition = is_git_repo,
  update = { "WinNew", "WinClosed", "BufEnter" },
  init = function(self)
    local ahead_behind = vim.g.ahead_behind
    self.git_ahead = ahead_behind.ahead
    self.git_behind = ahead_behind.behind
    self.git_has_status = ahead_behind.ahead and ahead_behind.behind
  end,
  gitStatusProvider("git_ahead", git.ahead, "Blue"),
  gitStatusProvider("git_behind", git.behind, "Orange"),
}

local Status = {
  init = function(self)
    local spell = vim.opt.spell:get()
    self.autoformat = vim.g.autoformat
    self.spelling = spell
    self.autofix = vim.g.autofix
  end,
  {
    provider = function(self)
      return self.spelling and custom.spellcheck_enabled or custom.spellcheck_disabled
    end,
    hl = "Blue"
  },
  {
    provider = function(self)
      return self.autoformat and custom.format_enabled or custom.format_disabled
    end,
    hl = "Green"
  },
  {
    provider = function(self)
      return self.autofix and custom.linting_enabled or custom.linting_disabled
    end,
    hl = "Yellow"
  }
}

local MacroRec = {
  condition = function()
    return vim.fn.reg_recording() ~= "" and vim.o.cmdheight == 0
  end,
  update = { "RecordingEnter", "RecordingLeave" },
  provider = " ",
  hl = "OrangeBold",
  utils.surround({ "[", "]" }, nil, {
    provider = function()
      return vim.fn.reg_recording()
    end,
    hl = "GreenBold",
  }),
}

return {
  init = function(self)
    local filename = vim.api.nvim_buf_get_name(0)
    self.filename = vim.fn.fnamemodify(filename, ":t")
  end,
  MacroRec,
  ViMode,
  U.Spacer(),
  FileNameBlock,
  FileTypeBlock,
  U.Align,
  U.Align,
  Status,
  U.Spacer(is_git_repo),
  Git,
  GitStatus,
  GitAheadBehind,
}
