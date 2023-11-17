local format = require("plugins.utils.format")
local conditions = require("heirline.conditions")
local utils = require("heirline.utils")
local u = require("plugins.ui.heirline.components.universal")
local custom = require("plugins.ui.icons").custom
local git = require("plugins.ui.icons").git

local function padding(self, text, number)
  local width = vim.api.nvim_win_get_width(self.winid)
  local pad = math.ceil((width - #text) / number)
  return string.rep(" ", pad) .. text .. string.rep(" ", pad)
end

local ViMode = {
  init = function(self)
    self.mode = vim.fn.mode(1)

    if not self.once then
      vim.api.nvim_create_autocmd("ModeChanged", {
        pattern = "*:*o",
        command = "redrawstatus",
      })
      self.once = true
    end
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
  Space,
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


local FileName = {
  provider = function(self)
    return self.filename ~= "" and self.filename or "[No Name]"
  end,
  hl = function()
    return { fg = "fg", sp = "red", underline = vim.bo.modified and true }
  end,
}

local FileType = {
  provider = function(self)
    local filename = vim.api.nvim_buf_get_name(0)
    local extension = vim.bo.filetype
    self.icon, self.icon_color =
        require("nvim-web-devicons").get_icon_color(filename, extension)
    return extension
  end,
  hl = function(self)
    return { fg = self.icon_color or "fg" }
  end,
}

FileNameBlock = {
  -- condition = function()
  --   local excluded = {
  --     "harpoon",
  --     "neo-tree",
  --     "keymenu",
  --     "^git.*",
  --     "fugitive",
  --     "TelescopePrompt",
  --   }
  --
  --   return not conditions.buffer_matches({
  --     buftype = { "nofile", "prompt", "help", "quickfix" },
  --     filetype = excluded
  --   })
  -- end,
  Spacer(),
  FileFlags,
  FileName,
  Diagnostics,
}

FileTypeBlock = {
  Spacer(),
  FileType,
}


local Git = {
  condition = conditions.is_git_repo,
  init = function(self)
    ---@diagnostic disable-next-line: undefined-field
    self.status_dict = vim.b.gitsigns_status_dict
    self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
  end,
  provider = function()
    return string.format("󰘬 %s", vim.g.gitsigns_head)
  end,
  hl = "Aqua",
}

local gitStatusProvider = function(status, string, highlight)
  return {
    condition = function(self)
      return self[status] ~= nil and self[status] > 0
    end,
    provider = function(self)
      return string.format("%s %s", string, self[status])
    end,
    hl = highlight,
  }
end

local GitStatus = {
  conditions = conditions.is_git_repo,
  update = { "WinNew", "WinClosed", "BufEnter" },
  init = function(self)
    vim.fn.jobstart({ "git", "status", "-s" }, {
      on_stdout = function(_, data)
        local status_output = table.concat(data, "\n")

        local git_counts = {
          M = 0, A = 0, D = 0, R = 0, C = 0, U = 0, untracked = 0
        }

        for status in status_output:gmatch("(%u+)%s+(%S+)") do
          if status == "??" then
            git_counts.untracked = git_counts.untracked + 1
          else
            git_counts[status] = git_counts[status] + 1
          end
        end

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
  condition = conditions.is_git_repo,
  update = { "WinNew", "WinClosed", "BufEnter" },
  init = function(self)
    vim.fn.jobstart({ "git", "rev-list", "--count", "--left-right", "HEAD...@{upstream}" }, {
      on_stdout = function(_, data)
        local out = vim.trim(data[1])
        local ahead, behind = out:match("(%d+)%s+(%d+)")

        if ahead then
          self.git_ahead = tonumber(ahead)
        end
        if behind then
          self.git_behind = tonumber(behind)
        end
      end,
      capture_stdout = true,
    })
  end,
  Space,
  gitStatusProvider("git_ahead", "󰳢", utils.get_highlight("Blue").fg),
  gitStatusProvider("git_behind", "󰳜", utils.get_highlight("Orange").fg),
}

local Offset = {
  condition = function(self)
    local win = vim.api.nvim_tabpage_list_wins(0)[1]
    local bufnr = vim.api.nvim_win_get_buf(win)
    self.winid = win

    if vim.bo[bufnr].filetype == "neo-tree" then
      self.title = ""
      return true
    end
  end,
  provider = function(self)
    return padding(self, self.title, 2)
  end,
  gitStatusProvider("git_ahead", git.ahead, "Blue"),
  gitStatusProvider("git_behind", git.behind, "Orange"),
}

local Status = {
  init = function(self)
    local spell = vim.opt.spell:get()
    self.autoformat = format.enabled()
    self.spelling = spell
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
      return self.autofix and custom.linting_enabled or custom.linting_disabled
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

  hl = function()
    return { bg = vim.bo.modified and "dark_red", fg = "fg" }
  end,
  Offset,
  {
    provider = "",
    hl = function()
      return {
        fg = vim.bo.modified and "dark_red" or "bg",
        bg = "bg"
      }
    end
  },
  MacroRec,
  ViMode,
  FileNameBlock,
  Align,
  Align,
  Status,
  Spacer(conditions.is_git_repo),
  Spacer(conditions.is_git_repo),
  Git,
  -- GitStatus,
  GitAheadBehind,
  {
    provider = "",
    hl = function()
      return { fg = vim.bo.modified and "dark_red" or "bg", bg = "bg" }
    end
  },
}

return {
  fallthrough = false,
  FileTypeStatusLine,
  DefaultStatusline,
}
