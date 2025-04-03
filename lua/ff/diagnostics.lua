-- Diagnostic configuration.
vim.diagnostic.config({
  float = {
    source = "if_many",
    scope = "cursor",
    focusable = true,
  },
  jump = {
    float = true,
  },
  update_in_insert = true,
  signs = false,
  severity_sort = true,
  virtual_text = true,
  virtual_lines = false,
})
