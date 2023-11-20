return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "sindrets/diffview.nvim",
    "ibhagwan/fzf-lua",
  },
  init = function()
    local map = require("ff.map")
    map.t({ t_g = { "<cmd>Neogit kind=split_above<cr>", "NeoGit" } })
    vim.api.nvim_create_autocmd("User", {
      pattern = "NeogitCommitComplete",
      callback = function()
        for _, buf in ipairs(vim.fn.getbufinfo({ bufloaded = 1 })) do
          local bufname = buf.name

          if string.match(bufname, "NeogitConsole") then
            vim.api.nvim_buf_call(bufnr, function()
              vim.cmd("bdelete!")
            end)
          end
        end
      end
    })
  end,
  opts = {
    signs = {
      item = { "", "" },
      section = { "", "" },
    },
    disable_insert_on_commit = "auto",
  }
}
