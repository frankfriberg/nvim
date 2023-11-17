return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  lazy = true,
  event = "BufEnter",
  opts = {
    indent = {
      char = "▏",
    },
    scope = {
      show_start = false,
      highlight = { "Title" }
    }
  },
  config = true,
}
