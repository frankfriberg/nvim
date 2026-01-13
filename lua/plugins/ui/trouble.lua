return {
  "folke/trouble.nvim",
  opts = {},
  cmd = "Trouble",
  init = function()
    vim.api.nvim_create_autocmd("QuickFixCmdPost", {
      callback = function()
        vim.cmd([[Trouble qflist open]])
      end,
    })
  end,
  keys = require("helpers.map").lazy({
    l_xx = {
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "Diagnostics (Trouble)",
    },
    l_xX = {
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      desc = "Buffer Diagnostics (Trouble)",
    },
    l_cs = {
      "<cmd>Trouble symbols toggle focus=false<cr>",
      desc = "Symbols (Trouble)",
    },
    l_cl = {
      "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
      desc = "LSP Definitions / references / ... (Trouble)",
    },
    l_xl = {
      "<cmd>Trouble loclist toggle<cr>",
      desc = "Location List (Trouble)",
    },
    l_xq = {
      "<cmd>Trouble qflist toggle<cr>",
      desc = "Quickfix List (Trouble)",
    },
  }),
}
