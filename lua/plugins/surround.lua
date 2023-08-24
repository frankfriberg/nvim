return {
  "echasnovski/mini.surround",
  event = "BufEnter",
  init = function ()
    local map = require("ff.map")
    map.ng("s", "Surround")
  end,
  opts = {
    respect_selection_type = true,
  }
}
