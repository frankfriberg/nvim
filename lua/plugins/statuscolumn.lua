return {
  "luukvbaal/statuscol.nvim",
  config = function()
    local builtin = require "statuscol.builtin"

    require("statuscol").setup {
      ft_ignore = { "dasboard", "neo-tree", "fugitive", "Gitcommit" },
      relculright = true,
      segments = {
        { text = { builtin.lnumfunc } },
        { text = { "%s", builtin.foldfunc } },
      },
    }
  end,
}
