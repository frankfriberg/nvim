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
        group = { "<leader>q", "Buffer Delete" },
        a = { snacks.bufdelete.all, "Delete All Buffers" },
        o = { snacks.bufdelete.other, "Delete Other Buffers" },
        q = {
          function()
            local bd = snacks.bufdelete.delete
            if vim.bo.modified then
              local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
              if choice == 1 then -- Yes
                vim.cmd.write()
                bd()
              elseif choice == 2 then -- No
                bd({ 0, true })
              end
            else
              bd()
            end
          end,
          "Delete Buffer",
        },
      },
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
