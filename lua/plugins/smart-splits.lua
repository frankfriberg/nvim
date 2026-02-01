return {
  "mrjones2014/smart-splits.nvim",
  lazy = false,
  keys = require("helpers.map").lazy({
    {
      c_h = {
        function()
          require("smart-splits").move_cursor_left()
        end,
        desc = "[S] Move cursor left",
      },
      c_l = {
        function()
          require("smart-splits").move_cursor_right()
        end,
        desc = "[S] Move cursor right",
      },
      c_k = {
        function()
          require("smart-splits").move_cursor_up()
        end,
        desc = "[S] Move cursor up",
      },
      c_j = {
        function()
          require("smart-splits").move_cursor_down()
        end,
        desc = "[S] Move cursor down",
      },
    },
  }),
  opts = {},
}
