return {
  "tpope/vim-fugitive",
  cmd = { "G", "Git" },
  init = function ()
    local map = require("ff.map")
    map.t({
      group = { "<leader>G", "Git" },
      g = { "<cmd>G<cr>", "Fugitive" },
      p = { "<cmd>G push<cr>", "Git Push" },
      P = { "<cmd>G pull<cr>", "Git Pull" },
      s = { "<cmd>Gstatus<cr>", "Git Status" },
      b = { "<cmd>G blame<cr>", "Git Blame" },
      d = { "<cmd>DiffviewOpen<cr>", "Diffview Open" },
    })
    
  end
}
