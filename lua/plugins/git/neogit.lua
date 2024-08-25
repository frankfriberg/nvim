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

    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "NeogitCommitMessage", "NeogitRebaseTodo" },
      callback = function()
        map.n("<CR>", ":wq <CR>", "Finish commit", { buffer = true })
      end,
    })
  end,
  opts = {
    signs = {
      item = { "", "" },
      section = { "", "" },
    },
    kind = "split_above",
    disable_insert_on_commit = "auto",
    integrations = {
      diffview = true,
      telescope = false,
      fzf_lua = false,
    },
    popup = {
      kind = "split_above",
    },
  },
}
