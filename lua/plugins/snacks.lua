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
          desc = "Delete Buffer",
        },
      },
    })
  end,
  opts = {
    lazygit = {
      enabled = true,
      win = {
        backdrop = false,
        border = "rounded",
        title = " LazyGit ",
        title_pos = "center",
        bo = {
          filetype = "snacks_lazygit",
        },
      },
    },
    indent = {
      animate = {
        enabled = false,
      },
      enabled = true,
      indent = {
        char = "▏",
      },
      scope = {
        char = "▏",
      },
    },
    scroll = {
      enabled = true,
      animate = {
        duration = {
          total = 100,
        },
        easing = "inExpo",
      },
    },
    picker = {
      enabled = false,
    },
  },
}
