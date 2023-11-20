return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "sindrets/diffview.nvim",
    "ibhagwan/fzf-lua",
  },
  init = function()
    local map = require("ff.map")
    map.t({ t_g = { "<cmd>Neogit kind=split_above<cr>", "NeoGit" } })
  end,
  opts = {
    signs = {
      item = { "", "" },
      section = { "", "" },
    },
    disable_insert_on_commit = "auto",
  }
}
