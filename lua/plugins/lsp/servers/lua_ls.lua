return {
  update_delay = 500,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = {
          vim.env.VIMRUNTIME
        },
        maxPreload = 100000,
        checkThirdParty = false,   -- THIS IS THE IMPORTANT LINE TO ADD
        preloadFileSize = 10000,
        update_in_insert = false,
      },
    },
  },
}
