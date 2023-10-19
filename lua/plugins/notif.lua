return {
  "frankfriberg/notif.nvim",
  dir = "~/Development/notif.nvim",
  config = function()
    local notif = require("notif")
    notif.setup({
      max_width = 200
    });
    vim.notify = notif.notify
  end
}
