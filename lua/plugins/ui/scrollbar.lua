return {
  "petertriho/nvim-scrollbar",
  dependencies = {
    "lewis6991/gitsigns.nvim",
  },
  opts = function()
    return {
      excluded_buftypes = {
        "nofile",
      },
      handlers = {
        cursor = true,
        diagnostic = true,
        gitsigns = true,
        handle = true,
      },
    }
  end,
}
