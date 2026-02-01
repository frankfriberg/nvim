return {
  "yioneko/nvim-vtsls",
  ft = { "typescript", "typescriptreact" },
  config = function()
    local map = require("helpers.map")
    local vtsls = require("vtsls")

    map.t({
      group = { "<leader>t", "TypeScript" },
      r = { vtsls.commands.remove_unused, desc = "[TS] Remove Unused" },
      R = { vtsls.commands.remove_unused_imports, desc = "[TS] Remove Unused Imports" },
      t = { vtsls.commands.restart_tsserver, desc = "[TS] Restart tsserver" },
      T = { vtsls.commands.reload_projects, desc = "[TS] Reload projects" },
      o = { vtsls.commands.organize_imports, desc = "[TS] Organize Imports" },
      s = { vtsls.commands.sort_imports, desc = "[TS] Sort Imports" },
      a = { vtsls.commands.add_missing_imports, desc = "[TS] Add Missing Imports" },
      x = { vtsls.commands.fix_all, desc = "[TS] Fix All" },
    })
  end,
}
