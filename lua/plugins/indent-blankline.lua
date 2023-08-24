return {
  "lukas-reineke/indent-blankline.nvim",
  lazy = true,
  event = "BufEnter",
  opts = {
    space_char_blankline = " ",
    show_current_context = true,
    show_trailing_blankline_indent = false,
  },
  config = function(_, opts)
    require("indent_blankline").setup(opts)
  end
}
