return {
  "neanias/everforest-nvim",
  version = false,
  lazy = false,
  priority = 1000,
  config = function()
    require("everforest").setup({
      transparent_background_level = 2,
      on_highlights = function (hl, palette)
        hl.NeoTreeDirectoryIcon = { link = "Green" }
        hl.TelescopeBorder = { link = "Fg"}
        hl.VertSplit = { link = "Fg" }
      end
    })
  end
}
