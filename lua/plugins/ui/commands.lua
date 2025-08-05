return {
  "frankfriberg/command.nvim",
  keys = {
    {
      "<leader>cm",
      function()
        require("command").show_command_popup()
      end,
      desc = "Show command multiplexer",
    },
  },
  opts = {},
}
