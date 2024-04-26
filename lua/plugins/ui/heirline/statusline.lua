local utils = require("heirline.utils")
local Git = require("plugins.ui.heirline.components.git")
local File = require("plugins.ui.heirline.components.file")
local Universal = require("plugins.ui.heirline.components.universal")

local ViMode = require("plugins.ui.heirline.components.vimode")

local MacroRec = {
  condition = function()
    return vim.fn.reg_recording() ~= "" and vim.o.cmdheight == 0
  end,
  update = { "RecordingEnter", "RecordingLeave" },
  provider = " ",
  hl = {
    fg = "warn",
  },
  utils.surround({ "[", "]" }, nil, {
    provider = function()
      return vim.fn.reg_recording()
    end,
    hl = {
      fg = "info",
    },
  }),
}

return {
  init = function(self)
    local filename = vim.api.nvim_buf_get_name(0)
    self.filename = vim.fn.fnamemodify(filename, ":t")
  end,
  MacroRec,
  ViMode,
  Universal.Spacer(),
  File.NameBlock,
  File.TypeBlock,
  Universal.Align,
  Universal.Align,
  Git,
}
