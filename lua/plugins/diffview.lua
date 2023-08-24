return {
  "sindrets/diffview.nvim",
  event = "BufRead",
  opts = {
    view = {
      merge_tool = {
        layout = "diff3_mixed"
      }
    },
    file_panel = {
      listing_style = "list",
      win_config = {
        width = 50
      }
    }
  }
}
