---@diagnostic disable: missing-fields
return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
    "windwp/nvim-ts-autotag"
  },
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "typescript", "javascript", "lua"
      },
      highlight = {
        enable = true
      },
      indent = {
        enable = true
      },
      auto_install = true,
      context_commentstring = {
        enable = true,
        enable_autocmd = false,
      },
    })
  end,
}
