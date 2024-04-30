return {
  "altermo/ultimate-autopair.nvim",
  event = { "InsertEnter", "CmdlineEnter" },
  branch = "v0.6", --recommended as each new version will have breaking changes
  opts = {
    tabout = {
      enable = true,
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
      cmap = "<A-e>",
    },
  },
}
