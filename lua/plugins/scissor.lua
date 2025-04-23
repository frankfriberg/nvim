return {
  "chrisgrieser/nvim-scissors",
  keys = {
    {
      "<leader>se",
      function()
        require("scissors").editSnippet()
      end,
      desc = "Edit Snippet",
    },
    {
      "<leader>sa",
      function()
        require("scissors").addNewSnippet()
      end,
      desc = "Add New Snippet",
      mode = { "n", "x" },
    },
  },
  opts = {
    snippetDir = vim.fn.stdpath("config") .. "/snippets",
    editSnippetPopup = {
      width = 120,
    },
    backdrop = {
      enabled = false,
    },
  },
}
