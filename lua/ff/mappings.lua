local map = require("helpers.map")

map.t({
  -- Center screen for commands
  c_u = { "<C-u>zz", "Scroll up" },
  c_d = { "<C-d>zz", "Scroll down" },
  n = { "nzz", "Next search result" },
  N = { "Nzz", "Previous search result" },
  ["*"] = { "*zz", "Search next" },
  ["#"] = { "#zz", "Search previous" },

  U = { "<C-r>", "Redo undo" },
  esc = { ":nohlsearch<Bar>:echo<CR>", "" },
  {
    mode = "v",
    J = { ":move '>+1<CR>gv-gv", "Move selection up" },
    K = { ":move '<-2<CR>gv-gv", "Move selection down" },
    t_ = { ">gv", "Indent text" },
    s_tab = { "<gv", "Unindent text" },
    p = { '"_dP', "Paste over selected" },
  },
})

map.ng("<leader>")
map.ng("g")