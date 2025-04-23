return {
  "echasnovski/mini.diff",
  version = "*",
  event = "VeryLazy",
  keys = {
    {
      "<leader>go",
      function()
        require("mini.diff").toggle_overlay(0)
      end,
      desc = "Toggle mini.diff overlay",
    },
  },
  opts = {
    mappings = {
      apply = "<leader>gs",
      reset = "<leader>gr",
      textobject = "<leader>gs",
    },
  },
}
