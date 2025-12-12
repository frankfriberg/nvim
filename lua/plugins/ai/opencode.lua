return {
  "NickvanDyke/opencode.nvim",
  dependencies = {
    "folke/snacks.nvim",
  },
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      desc = "Opencode keymaps",
      pattern = "opencode",
      callback = function()
        require("helpers.map").t({
          c_d = {
            function()
              require("opencode").command("session.half.page.downScroll")
            end,
            "Scroll down half page",
            { buffer = true },
          },
          c_u = {
            function()
              require("opencode").command("session.half.page.upScroll")
            end,
            "Scroll up half page",
            { buffer = true },
          },
        })
      end,
    })
  end,
  keys = require("helpers.map").lazy({
    group = { "<leader>o", "Opencode" },
    a = {
      function()
        require("opencode").ask("@this: ", { submit = true })
      end,
      "Ask",
    },
    s = {
      function()
        require("opencode").select()
      end,
      "Select prompt",
    },
    t = {
      function()
        require("opencode").toggle()
      end,
      "Toggle",
    },
    c = {
      function()
        require("opencode").command("session.interrupt")
      end,
      "Cancel",
    },
    u = {
      function()
        require("opencode").command("session.undo")
      end,
      "Undo",
    },
    {
      mode = "v",
      a = {
        function()
          require("opencode").ask("@this: ", { submit = true })
        end,
        "Ask",
      },
      A = {
        function()
          require("opencode").prompt("@this")
        end,
        "Add to prompt",
      },
    },
  }),
}
