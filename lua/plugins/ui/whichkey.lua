return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    win = {
      width = { min = 30, max = 60 },
      height = { min = 4, max = 0.75 },
      padding = { 0, 1 },
      row = 0,
      col = 0.5,
      border = "rounded",
      title = true,
      title_pos = "left",
      wo = {
        winblend = vim.o.winblend,
      },
    },
    layout = {
      width = { min = 30 },
    },
  },
}
