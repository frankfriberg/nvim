---@diagnostic disable: missing-fields
return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "frankfriberg/neotest-jest",
    "nvim-treesitter/nvim-treesitter",
  },
  event = "BufEnter",
  config = function()
    local neotest = require("neotest")
    local map = require("helpers.map")

    map.t({
      group = { "<leader>n", "Neotest" },
      t = {
        function()
          return neotest.run.run()
        end,
        "[Test] Run the nearest test",
      },
      f = {
        function()
          return neotest.run.run(vim.fn.expand("%"))
        end,
        "[Test] Run current file",
      },
      a = {
        function()
          return neotest.run.run(vim.loop.cwd())
        end,
        "[Test] Run all tests",
      },
      w = {
        function()
          return neotest.run.run({ jestCommand = "jest --watch" })
        end,
        "[Test] Run test in watch mode",
      },
      s = {
        function()
          return neotest.summary.toggle()
        end,
        "[Test] Show the summary",
      },
      o = {
        function()
          return neotest.output()
        end,
        "[Test] Show the output panel",
      },
    })

    neotest.setup({
      status = { virtual_text = true },
      output = { open_on_run = true },
      adapters = {
        require("neotest-jest")({
          jestCommand = "npm test --",
          env = { CI = true },
          cwd = function()
            return vim.fn.getcwd()
          end,
        }),
      },
    })
  end,
}
