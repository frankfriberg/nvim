return {
  "NickvanDyke/opencode.nvim",
  dependencies = { "folke/snacks.nvim" },
  opts = {
    provider_id = "github-copilot",
    model_id = "claude-sonnet-4",
  },
  keys = {
    {
      "<leader>ot",
      function()
        require("snacks.terminal").toggle("opencode", { win = { position = "right" } })
      end,
      desc = "Toggle opencode",
    },
    {
      "<leader>oa",
      function()
        require("opencode").ask()
      end,
      desc = "Ask opencode",
      mode = { "n", "v" },
    },
    {
      "<leader>oA",
      function()
        require("opencode").ask("@file ")
      end,
      desc = "Ask opencode about current file",
      mode = { "n", "v" },
    },
    {
      "<leader>on",
      function()
        require("opencode").create_session()
      end,
      desc = "New session",
    },
    {
      "<leader>oe",
      function()
        require("opencode").prompt("Explain @cursor and its context")
      end,
      desc = "Explain code near cursor",
    },
    {
      "<leader>or",
      function()
        require("opencode").prompt("Review @file for correctness and readability")
      end,
      desc = "Review file",
    },
    {
      "<leader>of",
      function()
        require("opencode").prompt("Fix these @diagnostics")
      end,
      desc = "Fix errors",
    },
    {
      "<leader>oo",
      function()
        require("opencode").prompt("Optimize @selection for performance and readability")
      end,
      desc = "Optimize selection",
      mode = "v",
    },
    {
      "<leader>od",
      function()
        require("opencode").prompt("Add documentation comments for @selection")
      end,
      desc = "Document selection",
      mode = "v",
    },
    {
      "<leader>ot",
      function()
        require("opencode").prompt("Add tests for @selection")
      end,
      desc = "Test selection",
      mode = "v",
    },
  },
  config = true,
}
