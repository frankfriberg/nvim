return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    config = function()
      require("rose-pine").setup({
        dark_variant = "moon",
        enable = {
          legacy_highlights = false,
          migrations = false,
        },
        groups = {
          border = "text",
          panel = "base",
        },
        highlight_groups = {
          FloatBorder = { link = "Normal" },
          WhichKeyBorder = { link = "FloatBorder" },
          Cursorline = { bg = "pine", blend = 10 },
          Pmenu = { link = "Normal" },
          CurSearch = { fg = "base", bg = "love", inherit = false },
          Search = { fg = "text", bg = "love", blend = 40, inherit = false },
          Visual = { bg = "rose", blend = 30 },
          WinSeparator = { fg = "overlay" },
          VertSplit = { fg = "overlay" },
        },
      })

      vim.cmd("colorscheme rose-pine")
    end,
  },
}
