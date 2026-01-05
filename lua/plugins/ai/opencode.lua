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
            desc = "Scroll down half page",
            buffer = true,
          },
          c_u = {
            function()
              require("opencode").command("session.half.page.upScroll")
            end,
            desc = "Scroll up half page",
            buffer = true,
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
      desc = "Ask",
    },
    s = {
      function()
        require("opencode").select()
      end,
      desc = "Select prompt",
    },
    t = {
      function()
        require("opencode").toggle()
      end,
      desc = "Toggle",
    },
    c = {
      function()
        require("opencode").command("session.interrupt")
      end,
      desc = "Cancel",
    },
    u = {
      function()
        require("opencode").command("session.undo")
      end,
      desc = "Undo",
    },
    l = {
      function()
        return require("opencode").operator("@this ") .. "_"
      end,
      desc = "Add line to prompt",
      expr = true,
    },
    {
      mode = { "v", "x" },
      a = {
        function()
          require("opencode").ask("@this: ", { submit = true })
        end,
        desc = "Ask",
      },
      A = {
        function()
          return require("opencode").operator("@this")
        end,
        desc = "Add range to prompt",
        expr = true,
      },
    },
  }),
}
