return {
  "neanias/everforest-nvim",
  version = false,
  lazy = false,
  priority = 1000,
  config = function()
    require("everforest").setup({
      transparent_background_level = 2,
      on_highlights = function(hl)
        hl.NeoTreeDirectoryIcon = { link = "Green" }
        hl.NeoTreeFloatBorder = { link = "FloatBorder" }
        hl.VertSplit = { link = "Fg" }
        hl.NormalFloat = { link = "Normal" }
        hl.FloatBorder = { link = "Normal" }
        hl.FloatTitle = { link = "Normal" }
        hl.TelescopeBorder = { link = "FloatBorder" }
      end
    })
  end
}
