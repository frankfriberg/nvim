return {
  "stevearc/oil.nvim",
  keys = { {
    "<leader>e",
    function()
      require("oil").toggle_float()
    end,
    desc = "Open Oil",
  } },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "OilActionsPost",
      callback = function(args)
        local parse_url = function(url)
          return url:match("^.*://(.*)$")
        end

        if args.data.err then
          return
        end

        for _, action in ipairs(args.data.actions) do
          if action.type == "delete" and action.entry_type == "file" then
            local path = parse_url(action.url)
            local bufnr = vim.fn.bufnr(path)
            if bufnr == -1 then
              return
            end

            local winnr = vim.fn.win_findbuf(bufnr)[1]
            if not winnr then
              return
            end

            vim.fn.win_execute(winnr, "bfirst | bw " .. bufnr)
          end
        end
      end,
    })
  end,
  dependencies = { { "echasnovski/mini.icons", opts = {} } },
  opts = {
    keymaps = {
      ["q"] = { "actions.close", mode = "n" },
      ["<ESC>"] = { "actions.close", mode = "n" },
      ["<BS>"] = { "actions.parent", mode = "n" },
      ["<C-g>"] = { "actions.toggle_hidden", mode = "n" },
      ["<C-v>"] = { "actions.select", opts = { vertical = true } },
      ["<C-s>"] = { "actions.select", opts = { horizontal = true } },
    },
    skip_confirm_for_simple_edits = true,
    delete_to_trash = true,
    lsp_file_method = {
      autosave_changes = true,
    },
    win_options = {
      winblend = vim.o.winblend,
      number = false,
      relativenumber = false,
      statuscolumn = " ",
    },
    float = {
      padding = 2,
      max_width = 80,
      max_height = 40,
      border = vim.o.winborder,
    },
  },
}
