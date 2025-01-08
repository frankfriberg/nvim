return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
  },
  init = function()
    local map = require("helpers.map")
    local neogit = require("neogit")

    map.t({
      s_tab = {
        function()
          if neogit.status.is_open() then
            neogit.close()
          else
            neogit.open()
          end
        end,
        "NeoGit",
      },
    })
  end,
  opts = {
    signs = {
      item = { "", "" },
      section = { "", "" },
    },
    kind = "floating",
    fetch_after_checkout = true,
    auto_show_console_on = "error",
    process_spinner = false,
    integrations = {
      diffview = true,
      telescope = false,
      fzf_lua = true,
    },
    commit_editor = {
      staged_diff_split_kind = "vsplit",
    },
    popup = {
      kind = "split_above_all",
    },
    mappings = {
      commit_editor = {
        ["<CR>"] = "Submit",
      },
      rebase_editor = {
        ["<CR>"] = "Submit",
      },
    },
  },
}
