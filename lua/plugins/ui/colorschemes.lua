return {
  {
    "f-person/auto-dark-mode.nvim",
    opts = {
      update_interval = 500,
      set_dark_mode = function()
        vim.api.nvim_set_option_value("background", "dark", { scope = "global" })
      end,
      set_light_mode = function()
        vim.api.nvim_set_option_value("background", "light", { scope = "global" })
      end,
    },
  },
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
        },
      })

      vim.cmd("colorscheme rose-pine")
    end,
  },
}
