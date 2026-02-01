local highlights = {
  Statusline = { bg = "none" },
  Pmenu = { bg = "none" },
  PmenuThumb = { link = "Cursor" },
  PmenuSel = { link = "CursorLine" },
  BlinkCmpMenuBorder = { link = "FloatBorder" },
  MiniFilesTitle = { link = "FloatTitle" },
  MiniFilesTitleFocused = { link = "FloatTitle" },
  NormalFloat = { bg = "none" },
  FloatBorder = { bg = "none" },
  FloatTitle = { bg = "none" },
}

for key, value in pairs(highlights) do
  vim.api.nvim_set_hl(0, key, value)
end
