local map = require("helpers.map")
local bufdelete = require("helpers.bufdelete")

map.t({
  l_w = { ":silent! wa <CR>", desc = "Write all buffer" },
  l_q = {
    function()
      bufdelete.smart_buffer_close()
    end,
    desc = "Quit buffer",
  },
  l_Q = { ":silent! %bd <CR>", desc = "Quit all buffers" },
  U = { "<C-r>", desc = "Redo undo", remap = true },
  esc = { ":nohlsearch<Bar>:echo<CR>", desc = "" },
  vv = { "V", desc = "Visual line mode", remap = true },
  l_d = { vim.diagnostic.open_float, desc = "Open Diagnostic float" },
  [","] = { "]", desc = "Next Forward", remap = true },
  m = { "[", desc = "Next Backward", remap = true },
  c_j = { "<C-n>", desc = "Next menu item", remap = true },
  c_k = { "<C-p>", desc = "Previous menu item", remap = true },
  {
    mode = "v",
    J = { ":move '>+1<CR>gv-gv", desc = "Move selection up" },
    K = { ":move '<-2<CR>gv-gv", desc = "Move selection down" },
    t_ = { ">gv", desc = "Indent text", remap = true },
    s_tab = { "<gv", desc = "Unindent text", remap = true },
    p = { '"_dP', desc = "Paste over selected" },
  },
  {
    mode = "t",
    c_h = { "<C-\\><C-n><C-w>h", desc = "Move to left window from terminal" },
    c_l = { "<C-\\><C-n><C-w>l", desc = "Move to right window from terminal" },
  },
  -- Alt-J and Alt-K to move lines up and down in normal mode
  ["‹"] = { "<cmd>cnext<CR>", desc = "Next quickfix item" },
  ["∆"] = { "<cmd>cprev<CR>", desc = "Previous quickfix item" },
})
