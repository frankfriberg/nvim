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
      local float_bg = "surface"
      require("rose-pine").setup({
        dark_variant = "moon",
        enable = {
          legacy_highlights = false,
          migrations = false,
        },
        highlight_groups = {
          NormalFloat = { bg = float_bg },
          FloatBorder = { fg = "text" },
          Cursorline = { bg = "pine", blend = 10 },
          StatusLine = { bg = "none" },
          StatusLineNC = { bg = "none" },
          StatusLineTerm = { bg = "none" },
          StatusLineTermNC = { bg = "none" },
          Pmenu = { bg = float_bg },
        },
      })

      vim.cmd("colorscheme rose-pine")
    end,
  },
}
