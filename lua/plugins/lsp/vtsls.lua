return {
  "yioneko/nvim-vtsls",
  ft = { "typescript", "typescriptreact" },
  config = function()
    local map = require("helpers.map")
    local vtsls = require("vtsls")

    map.t({
      group = { "<leader>t", "TypeScript" },
      r = { vtsls.commands.remove_unused, "[TS] Remove Unused" },
      R = { vtsls.commands.remove_unused_imports, "[TS] Remove Unused Imports" },
      t = { vtsls.commands.restart_tsserver, "[TS] Restart tsserver" },
      T = { vtsls.commands.reload_projects, "[TS] Reload projects" },
      o = { vtsls.commands.organize_imports, "[TS] Organize Imports" },
      s = { vtsls.commands.sort_imports, "[TS] Sort Imports" },
      a = { vtsls.commands.add_missing_imports, "[TS] Add Missing Imports" },
      x = { vtsls.commands.fix_all, "[TS] Fix All" },
    })
  end,
}
