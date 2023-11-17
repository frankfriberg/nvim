return {
  "sindrets/diffview.nvim",
  event = "BufRead",
  opts = function()
    local actions = require("diffview.actions")

    return {
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
      },
      keymaps = {
        view = {
          { "n", "q", actions.close,         { desc = "Close Diffview" } },
          { "n", "K", actions.prev_conflict, { desc = "Jump to the previous conflict" } },
          { "n", "J", actions.next_conflict, { desc = "Jump to the next conflict" } },
        }
      }
    }
  end
}
