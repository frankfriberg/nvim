-- Diagnostic configuration.
vim.diagnostic.config({
  float = {
    border = "rounded",
    source = "if_many",
    header = false,
    scope = "cursor",
    focusable = true,
  },
  update_in_insert = true,
  signs = false,
  severity_sort = true,
})
