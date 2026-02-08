return {
  update = { "RecordingEnter", "RecordingLeave" },
  condition = function()
    return vim.fn.reg_recording() ~= ""
  end,
  provider = function()
    local label = vim.fn.reg_recording()
    return string.format("r[%s] ", label)
  end,
  hl = {
    fg = "hint",
  },
}
