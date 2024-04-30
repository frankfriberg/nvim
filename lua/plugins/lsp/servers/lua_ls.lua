return {
  update_delay = 500,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = {
          vim.env.VIMRUNTIME,
        },
        maxPreload = 100000,
        checkThirdParty = false,
        preloadFileSize = 10000,
      },
    },
  },
}
