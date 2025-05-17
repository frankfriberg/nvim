local git = require("helpers.git")

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  init = function()
    local map = require("helpers.map")
    local snacks = require("snacks")

    map.t({
      {
        l_gg = {
          function()
            snacks.lazygit()
          end,
          "LazyGit",
        },
      },
    })

    vim.api.nvim_create_autocmd("BufLeave", {
      callback = function()
        local buf_id = vim.api.nvim_win_get_buf(0)
        local buf_type = vim.bo[buf_id].filetype
        if buf_type == "snacks_lazygit" then
          snacks.lazygit.open()
        end
      end,
    })
  end,
  opts = {
    lazygit = {
      enabled = true,
      win = {
        on_close = git.changed,
        backdrop = false,
        border = "rounded",
        title = " LazyGit ",
        title_pos = "center",
        bo = {
          filetype = "snacks_lazygit",
        },
      },
    },
    scope = { enabled = true },
    indent = {
      animate = {
        enabled = false,
      },
    },
  },
}
