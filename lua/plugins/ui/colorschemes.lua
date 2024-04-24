return {
  {
    "f-person/auto-dark-mode.nvim",
    opts = {
      update_interval = 1000,
      set_dark_mode = function()
        vim.api.nvim_set_option("background", "dark")
      end,
      set_light_mode = function()
        vim.api.nvim_set_option("background", "light")
      end,
    },
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    opts = {
      dark_variant = "moon",
      highlight_groups = {
        Normal = { bg = "none" },
      },
    },
  },
}
