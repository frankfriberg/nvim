return {
  "zbirenbaum/copilot-cmp",
  dependencies = {
    {
      "zbirenbaum/copilot.lua",
      opts = {
        suggestion = { enabled = false },
        panel = { enabled = false },
      },
    },
  },
  cmd = "Copilot",
  event = "InsertEnter",
  init = function()
    vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { link = "@constant" })
  end,
  config = true,
}
