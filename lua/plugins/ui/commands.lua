return {
  "frankfriberg/commands.nvim",
  keys = {
    {
      "<leader>cm",
      function()
        require("commands").show_command_popup()
      end,
      desc = "Show command multiplexer",
    },
  },
  opts = {},
}
