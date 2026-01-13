return {
  "petertriho/nvim-scrollbar",
  dependencies = {
    "lewis6991/gitsigns.nvim",
  },
  events = "VeryLazy",
  opts = {
    handlers = {
      gitsign = true,
    },
  },
}
