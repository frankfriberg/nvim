return {
  "olimorris/persisted.nvim",
  opts = {
    use_git_branch = true,
    should_autosave = function()
      if vim.bo.filetype == "alpha" then
        return false
      end
      return true
    end,
    on_autoload_no_session = function()
      vim.notify("No existing session to load.")
    end,
  },
  init = function()
    local p = require("persisted")
    local map = require("ff.map")

    -- local selectSession = vim.ui.select(p.list(), {
    --   prompt = "Select session",
    -- }, function(selection)
    --   if selection == nil then
    --     return
    --   end
    --   p.load(selection.value)
    -- end)

    map.t({
      group = { "<leader>s", "Sessions" },
      r = { p.load, "[S] Restore session" },
      d = { p.stop, "[S] Don't save current session" },
    })
  end,
  config = true
}
