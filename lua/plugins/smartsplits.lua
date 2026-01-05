return {
  "mrjones2014/smart-splits.nvim",
  lazy = false,
  config = function()
    local smart = require("smart-splits")
    local map = require("helpers.map")

    map.t({
      c_h = { smart.move_cursor_left, desc = "[S] Move cursor left" },
      c_l = { smart.move_cursor_right, desc = "[S] Move cursor right" },
      c_k = { smart.move_cursor_up, desc = "[S] Move cursor up" },
      c_j = { smart.move_cursor_down, desc = "[S] Move cursor down" },
    })

    smart.setup()
  end,
}
