return {
  {
    "NStefan002/visual-surround.nvim",
    event = "VeryLazy",
    opts = {
      enable_wrapped_deletion = true,
    },
  },
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    opts = {
      keymaps = {
        insert = "<C-g>s",
        insert_line = "<C-g>S",
        normal = "s",
        normal_cur = "ss",
        normal_line = "S",
        normal_cur_line = "SS",
        visual = "S",
        visual_line = "gS",
        delete = "sd",
        change = "sd",
        change_line = "Sc",
      },
    },
  },
}
