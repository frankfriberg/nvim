---@diagnostic disable: missing-fields
return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "typescript",
        "javascript",
        "lua",
        "sql",
        "gitcommit",
        "git_config",
        "git_rebase",
        "gitignore",
      },
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
      },
      auto_install = true,
      textobjects = {
        move = {
          enable = true,
          goto_next_start = {
            ["Lf"] = "@function.outer",
            ["Lc"] = "@class.outer",
          },
          goto_next_end = {
            ["LF"] = "@function.outer",
            ["LC"] = "@class.outer",
          },
          goto_previous_start = {
            ["Hf"] = "@function.outer",
            ["Hc"] = "@class.outer",
          },
          goto_previous_end = {
            ["HF"] = "@function.outer",
            ["HC"] = "@class.outer",
          },
        },
      },
    })
  end,
}
