return {
  "olimorris/codecompanion.nvim",
  config = true,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  init = function()
    local map = require("helpers.map")

    map.t({
      group = { "<leader>c", "Code Companion" },
      c = { "<cmd>CodeCompanionChat Toggle<cr>", "Toggle Chat" },
      a = { "<cmd>CodeCompanionActions<cr>", "Actions" },
      v = { "<cmd>CodeCompanionChat Add<cr>", "Add to chat" },
      i = {
        function()
          vim.ui.input({ prompt = "Enter a message: ", relative = "cursor" }, function(input)
            if not input then
              return
            end

            vim.cmd("CodeCompanion " .. input)
          end)
        end,
        "Inline command",
      },
    })
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
