return {
  "kevinhwang91/nvim-hlslens",
  keys = {
    {
      "n",
      function()
        vim.cmd("normal! " .. vim.v.count1 .. "nzz")
        require("hlslens").start()
      end,
      "Search next",
    },
    {
      "N",
      function()
        vim.cmd("normal! " .. vim.v.count1 .. "Nzz")
        require("hlslens").start()
      end,
      "Search previous",
    },
    {
      "*",
      "*zz<Cmd>lua require('hlslens').start()<CR>",
      "Search current word forward",
    },
    {
      "#",
      "#zz<Cmd>lua require('hlslens').start()<CR>",
      "Search current word forward",
    },
    {
      "g*",
      "g*zz<Cmd>lua require('hlslens').start()<CR>",
      "Search current word forward globally",
    },
    {
      "g#",
      "g#zz<Cmd>lua require('hlslens').start()<CR>",
      "Search current word forward globally",
    },
  },
  opts = {
    calm_down = true,
  },
}
