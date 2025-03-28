local Git = require("plugins.ui.heirline.components.git")
local File = require("plugins.ui.heirline.components.file")
local Universal = require("plugins.ui.heirline.components.universal")

local ViMode = require("plugins.ui.heirline.components.vimode")

local MacroRec = {
  condition = function()
    return vim.fn.reg_recording() ~= "" and vim.o.cmdheight == 0
  end,
  update = { "RecordingEnter", "RecordingLeave" },
  provider = function()
    local label = vim.fn.reg_recording()
    return string.format("%s [%s]", "", label)
  end,
  hl = {
    fg = "hint",
  },
  Universal.Spacer(),
}

local StatusLineFile = {
  File.NameBlock,
  File.TypeBlock,
  Universal.Spacer(Universal.is_git_repo),
}

return {
  init = function(self)
    local filename = vim.api.nvim_buf_get_name(0)
    self.filename = vim.fn.fnamemodify(filename, ":t")
  end,
  Universal.Align,
  MacroRec,
  ViMode,
  StatusLineFile,
  Git,
  Universal.Align,
  hl = {
    bg = "bg",
    fg = "fg",
  },
}
