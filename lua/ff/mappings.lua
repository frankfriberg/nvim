local map = require("helpers.map")

map.t({
  -- Center screen for commands
  -- c_u = { "<C-u>zz", "Scroll up" },
  -- c_d = { "<C-d>zz", "Scroll down" },
  n = { "nzz", "Next search result" },
  N = { "Nzz", "Previous search result" },
  ["*"] = { "*zz", "Search next" },
  ["#"] = { "#zz", "Search previous" },
  l_w = { ":silent! wa <CR>", "Write all buffer" },
  l_Q = { ":silent! %bd <CR>", "Quit all buffers" },
  U = { "<C-r>", "Redo undo" },
  esc = { ":nohlsearch<Bar>:echo<CR>", "" },
  vv = { "V", "Visual line mode" },
  l_d = { vim.diagnostic.open_float, "Open Diagnostic float" },
  {
    mode = "v",
    J = { ":move '>+1<CR>gv-gv", "Move selection up" },
    K = { ":move '<-2<CR>gv-gv", "Move selection down" },
    t_ = { ">gv", "Indent text" },
    s_tab = { "<gv", "Unindent text" },
    p = { '"_dP', "Paste over selected" },
  },
})

map.group("n", "<leader>")
map.group("n", "g")
