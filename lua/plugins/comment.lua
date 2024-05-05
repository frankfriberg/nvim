return {
  "echasnovski/mini.comment",
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
  },
  opts = function()
    ---@diagnostic disable-next-line: missing-fields
    require("ts_context_commentstring").setup({
      enable_autocmd = false,
    })

    return {
      options = {
        custom_commentstring = function()
          return require("ts_context_commentstring").calculate_commentstring() or vim.bo.commentstring
        end,
        ignore_blank_line = true,
      },
    }
  end,
}
