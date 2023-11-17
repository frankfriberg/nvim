local map = require("ff.map")
local custom = require("plugins.ui.icons").custom

map.t({
  group = { "<leader>u", "Utils" },
  s = { function()
    vim.o.spell = not vim.o.spell
    vim.notify(
      vim.o.spell and "Enabled" or "Disabled",
      vim.log.levels.INFO,
      {
        title = "Spellcheck",
        icon = vim.o.spell and custom.spellcheck_enabled or custom.spellcheck_disabled,
      }
    )
  end, "Toggle spellcheck" },
})
