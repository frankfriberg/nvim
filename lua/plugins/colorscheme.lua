return {
  "rebelot/kanagawa.nvim",
  priority = 1000,
  opts = {
    transparent = true,
    colors = {
      theme = {
        all = {
          ui = {
            bg_gutter = "none",
          },
        },
      },
    },
  },
  init = function()
    vim.cmd("colorscheme kanagawa")
  end,
}
