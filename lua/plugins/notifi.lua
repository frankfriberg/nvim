return {
  dir = "~/dev/notif.nvim",
  config = function()
    local notif = require("notif")
    notif.setup();
    vim.notify = notif.notify
  end
}
