local borders = require("plugins.ui.borders").borders

return {
  "aznhe21/actions-preview.nvim",
  opts = {
    backend = { "nui", "telescope" },
    nui = {
      layout = {
        relative = "cursor",
        anchor = "NW",
      },
      preview = {
        border = borders
      },
      select = {
        border = borders
      }
    }
  }
}
