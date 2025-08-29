return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "ravitemer/codecompanion-history.nvim",
    "franco-ruggeri/codecompanion-spinner.nvim",
    "Davidyz/VectorCode",
    {
      "ravitemer/mcphub.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
      },
      build = "npm install -g mcp-hub@latest",
      config = true,
    },
  },
  keys = require("helpers.map").l({
    group = { "<leader>c", "Code Companion" },
    c = {
      function()
        require("codecompanion").toggle()
      end,
      "Toggle Chat",
    },
    a = {
      function()
        require("codecompanion").actions()
      end,
      "Actions",
    },
    b = {
      function()
        require("codecompanion").inline()
      end,
      "Inline buffer command",
    },
    {
      mode = { "v" },
      i = {
        function()
          require("codecompanion").prompt()
        end,
        "Inline command",
      },
      l = {
        function()
          require("codecompanion").prompt("lsp")
        end,
        "Lsp",
      },
      a = {
        function()
          require("codecompanion").add()
        end,
        "Add to chat",
      },
    },
  }),
  opts = {
    display = {
      chat = {
        window = {
          width = 0.35,
        },
      },
    },
    extensions = {
      vectorcode = {
        opts = {
          add_tool = true,
        },
      },
      history = {
        enabled = true,
        memory = {
          index_on_startup = true,
        },
      },
      mcphub = {
        callback = "mcphub.extensions.codecompanion",
      },
      spinner = {},
    },
  },
}
