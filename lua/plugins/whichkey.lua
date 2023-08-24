return {
  "folke/which-key.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    local wk = require("which-key")
    wk.setup({
      plugins = { spelling = true },
      key_labels = { ["<leader>"] = "SPC" },
    })
  end,
}
