return {
  "zbirenbaum/copilot-cmp",
  dependencies = {
    {
      "zbirenbaum/copilot.lua",
      opts = {
        suggestion = { enabled = false },
        panel = { enabled = false },
      }
    }

  },
  cmd = "Copilot",
  event = "InsertEnter",
  config = true,
}
