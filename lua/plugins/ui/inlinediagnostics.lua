return {
  "rachartier/tiny-inline-diagnostic.nvim",
  event = "VeryLazy",
  priority = 1000,
  init = function()
    vim.diagnostic.config({ virtual_text = false })
  end,
  opts = {
    preset = "nonerdfont",
    options = {
      show_source = true,
      multilines = true,
      multiple_diag_under_cursor = true,
    },
  },
}
