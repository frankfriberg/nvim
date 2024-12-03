return {
  "nmac427/guess-indent.nvim",
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      desc = "Guess indentation when changing the file type",
      callback = function(args)
        require("guess-indent").set_from_buffer(args.buf, true, true)
      end,
    })
  end,
  config = true,
}
