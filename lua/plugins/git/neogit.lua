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
        local filetype = vim.api.nvim_buf_get_option(current_buf, "filetype")
        local neogit_filetype = string.match(filetype, "^Neogit")

        if neogit_filetype and not filetype ~= "NeogitStatus" and neogit.status.status_buffer then
          neogit.status.status_buffer:focus()
        end
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
