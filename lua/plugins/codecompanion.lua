return {
  "olimorris/codecompanion.nvim",
  config = true,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  keys = {
    {
      "<leader>cc",
      "<cmd>CodeCompanionChat Toggle<cr>",
      desc = "Toggle Chat",
    },
    { "<leader>ca", "<cmd>CodeCompanionActions<cr>", desc = "Actions" },
    {
      "<leader>cb",
      ":CodeCompanion #buffer ",
      desc = "Inline buffer command",
    },
    {
      mode = { "v" },
      "<leader>ci",
      ":CodeCompanion ",
      desc = "Inline command",
    },
    {
      mode = { "v" },
      "<leader>ca",
      "<cmd>CodeCompanionChat Add<cr>",
      desc = "Add to chat",
    },
  },
  init = function()
  end,
  opts = {
    adapters = {
      copilot = function()
        return require("codecompanion.adapters").extend("copilot", {
          schema = {
            model = {
              default = "claude-3.7-sonnet",
            },
          },
        })
      end,
    },
    strategies = {
      chat = {
        adapter = "copilot",
      },
      inline = {
        adapter = "copilot",
      },
    },
  },
}
