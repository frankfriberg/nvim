return {
  "lewis6991/gitsigns.nvim",
  event = "VeryLazy",
  keys = {
    -- Navigation
    {
      "]c",
      function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          require("gitsigns").nav_hunk("next")
        end
      end,
      mode = "n",
      desc = "Next git hunk",
    },
    {
      "[c",
      function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          require("gitsigns").nav_hunk("prev")
        end
      end,
      mode = "n",
      desc = "Prev git hunk",
    },

    -- Actions
    {
      "<leader>gs",
      function()
        require("gitsigns").stage_hunk()
      end,
      mode = "n",
      desc = "Stage hunk",
    },
    {
      "<leader>gr",
      function()
        require("gitsigns").reset_hunk()
      end,
      mode = "n",
      desc = "Reset hunk",
    },
    {
      "<leader>gs",
      function()
        require("gitsigns").stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end,
      mode = "v",
      desc = "Stage hunk (visual)",
    },
    {
      "<leader>gr",
      function()
        require("gitsigns").reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end,
      mode = "v",
      desc = "Reset hunk (visual)",
    },
    {
      "<leader>gS",
      function()
        require("gitsigns").stage_buffer()
      end,
      mode = "n",
      desc = "Stage buffer",
    },
    {
      "<leader>gR",
      function()
        require("gitsigns").reset_buffer()
      end,
      mode = "n",
      desc = "Reset buffer",
    },
    {
      "<leader>gp",
      function()
        require("gitsigns").preview_hunk()
      end,
      mode = "n",
      desc = "Preview hunk",
    },
    {
      "<leader>gi",
      function()
        require("gitsigns").preview_hunk_inline()
      end,
      mode = "n",
      desc = "Preview hunk inline",
    },
    {
      "<leader>gb",
      function()
        require("gitsigns").blame_line({ full = true })
      end,
    },
  },
  opts = {
    word_diff = false,
    numhl = true,
  },
}
