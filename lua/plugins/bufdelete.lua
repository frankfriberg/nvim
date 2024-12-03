return {

  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  keys = {
    {
      "<leader>qq",
      function()
        local bd = require("snacks").bufdelete.delete
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
    {
      "<leader>qa",
      function()
        require("snacks").bufdelete.all()
      end,
      desc = "Delete All Buffers",
    },
    {
      "<leader>qo",
      function()
        require("snacks").bufdelete.other()
      end,
      desc = "Delete Other Buffers",
    },
  },
}
