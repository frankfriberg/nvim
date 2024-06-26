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

local StatusLineFile = {
  utils.surround(
    {
      Universal.LeftSpacer.provider,
      Universal.is_git_repo() and Universal.RightSpacer.provider or Universal.RightEnd.provider,
    },
    "file",
    {
      File.NameBlock,
      File.TypeBlock,
      hl = { fg = "bg", bg = "file" },
    }
  ),
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
}
