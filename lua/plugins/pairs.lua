return {
  'altermo/ultimate-autopair.nvim',
  event = { 'InsertEnter', 'CmdlineEnter' },
  opts = {
    tabout = {
      enable = true
    },
    fastwarp = {
      enable = true,
      map = "<C-e>",
      rmap = "<C-E>",
      cmap = "<C-e>",
      rcmap = "<C-E>",
    },
    close = {
      enable = true,
      map = "<A-e>",
      cmap = "<A-e>"
    }
  }
}
