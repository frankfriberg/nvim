---@diagnostic disable: missing-fields
return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    -- "nvim-neotest/neotest-jest",
    "marilari88/neotest-vitest",
    "nvim-treesitter/nvim-treesitter",
  },
  keys = require("helpers.map").lazy({
    group = { "<leader>n", "Neotest" },
    t = {
      function()
        return require("neotest").run.run()
      end,
      desc = "Run the nearest test",
    },
    f = {
      function()
        return require("neotest").run.run(vim.fn.expand("%"))
      end,
      desc = "Run current file",
    },
    a = {
      function()
        return require("neotest").run.run(vim.loop.cwd())
      end,
      desc = "Run all tests",
    },
    w = {
      function()
        return require("neotest").run.run({ jestCommand = "jest --watch" })
      end,
      desc = "Run test in watch mode",
    },
    s = {
      function()
        return require("neotest").summary.toggle()
      end,
      desc = "Show the summary",
    },
    o = {
      function()
        return require("neotest").output()
      end,
      desc = "Show the output panel",
    },
  }),
  config = function()
    require("neotest").setup({
      status = { virtual_text = true },
      output = { open_on_run = true },
      adapters = {
        require("neotest-vitest"),
        -- require("neotest-jest")({
        --   jestCommand = "npm test --",
        --   env = { CI = true },
        --   cwd = function()
        --     return vim.fn.getcwd()
        --   end,
        -- }),
      },
    })
  end,
}
