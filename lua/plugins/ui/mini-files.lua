return {
  "echasnovski/mini.files",
  init = function()
    local m = require("helpers.map")

    m.t({
      l_e = {
        function()
          MiniFiles.open(vim.api.nvim_buf_get_name(0))
        end,
        "MiniFiles Open Current File",
      },
      l_E = {
        function()
          MiniFiles.open()
        end,
        "MiniFiles Open",
      },
    })

    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniFilesWindowOpen",
      callback = function(args)
        local win_id = args.data.win_id

        -- Customize window-local settings
        vim.api.nvim_win_set_config(win_id, { border = "rounded" })
      end,
    })

    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniFilesBufferCreate",
      callback = function(args)
        vim.keymap.set("n", "<C-w>c", "q", { buffer = args.data.buf_id, remap = true })
      end,
    })
  end,
  config = true,
}
