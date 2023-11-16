return {
  "Shatur/neovim-session-manager",
  opts = {
    autoload_mode = false,
    autosave_ignore_filetypes = {
      'gitcommit',
      'gitrebase',
    },
    autosave_ignore_buftypes = { "nofile" },
  }
}
