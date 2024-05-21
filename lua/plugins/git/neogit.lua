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
          neogit.open({ kind = "split_above" })
        end,
        "NeoGit",
      },
    })

    vim.api.nvim_create_autocmd("WinClosed", {
      callback = function()
        local current_win = vim.fn.expand("<afile>") + 0
        local current_buf = vim.api.nvim_win_get_buf(current_win)
        local filetype = vim.api.nvim_get_option_value("filetype", { buf = current_buf })
        local neogit_filetype = string.match(filetype, "^Neogit")

        if neogit_filetype and not filetype ~= "NeogitStatus" and neogit.status.is_open() then
          neogit.status:focus()
        end
      end,
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "NeogitCommitMessage",
      callback = function()
        map.n("<CR>", ":wq <CR>", "Finish commit")
      end,
    })
  end,
  opts = {
    signs = {
      item = { "", "" },
      section = { "", "" },
    },
    disable_insert_on_commit = "auto",
    integrations = {
      diffview = true,
      telescope = false,
      fzf_lua = false,
    },
  },
}
