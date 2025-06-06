local Universal = require("plugins.ui.heirline.components.universal")

local mode_icons = {
  normal = "󰬕 ",
  op = "󰬖 ",
  visual = "󰬝 ",
  select = "󰬚 ",
  insert = "󰬐 ",
  replace = "󰬙 ",
  command = "󰬊 ",
  terminal = "󰬛 ",
}

return {
  update = { "ModeChanged", "RecordingEnter", "RecordingLeave" },
  init = function(self)
    self.mode = vim.fn.mode(1)
  end,
  static = {
    mode_name = {
      n = "normal",
      no = "op",
      nov = "op",
      noV = "op",
      ["no"] = "op",
      niI = "normal",
      niR = "normal",
      niV = "normal",
      nt = "normal",
      v = "visual",
      V = "visual_lines",
      [""] = "visual_block",
      s = "select",
      S = "select",
      [""] = "block",
      i = "insert",
      ic = "insert",
      ix = "insert",
      R = "replace",
      Rc = "replace",
      Rv = "v_replace",
      Rx = "replace",
      c = "command",
      cv = "command",
      ce = "command",
      r = "enter",
      rm = "more",
      ["r?"] = "confirm",
      ["!"] = "shell",
      t = "terminal",
      ["null"] = "none",
    },
    mode_label = {
      normal = mode_icons.normal .. "Normal",
      op = mode_icons.op .. "Op",
      visual = mode_icons.visual .. "Visual",
      visual_lines = mode_icons.visual .. "Visual Lines",
      visual_block = mode_icons.visual .. "Visual Block",
      select = mode_icons.select .. "Select",
      block = "Block",
      insert = mode_icons.insert .. "Insert",
      replace = "Replace",
      v_replace = "V-Replace",
      command = "Command",
      enter = "Enter",
      more = "More",
      confirm = "Confirm",
      shell = "Shell",
      terminal = "Terminal",
      none = "None",
    },
    mode_colors = {
      n = "info",
      i = "warn",
      v = "hint",
      V = "hint",
      ["\22"] = "hint",
      c = "hint",
      s = "hint",
      S = "hint",
      ["\19"] = "hint",
      R = "ok",
      r = "ok",
      ["!"] = "error",
      t = "error",
    },
  },
  provider = function(self)
    return self.mode_label[self.mode_name[self.mode]]
  end,
  hl = function(self)
    local mode = self.mode:sub(1, 1)
    return {
      fg = self.mode_colors[mode],
    }
  end,
  Universal.Spacer(),
}
