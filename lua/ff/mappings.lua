local map = require("helpers.map")
local bufdelete = require("helpers.bufdelete")

map.t({
  -- Center screen for commands
  -- c_u = { "<C-u>zz", "Scroll up" },
  -- c_d = { "<C-d>zz", "Scroll down" },
  l_w = { ":silent! wa <CR>", "Write all buffer" },
  l_q = {
    function()
      bufdelete.smart_buffer_close()
    end,
    "Quit buffer",
  },
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
  c_j = { "<C-n>", "Next menu item" },
  c_k = { "<C-p>", "Previous menu item" },
  {
    mode = "t",
    c_h = { "<C-\\><C-n><C-w>h", "Move to left window from terminal" },
    c_j = { "<C-\\><C-n><C-w>j", "Move to below window from terminal" },
    c_k = { "<C-\\><C-n><C-w>k", "Move to above window from terminal" },
    c_l = { "<C-\\><C-n><C-w>l", "Move to right window from terminal" },
  },
})

map.group("n", "<leader>")
map.group("n", "g")
