return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
    },
  },
  config = function()
    local m = require("helpers.map")
    local telescope = require("telescope")
    local builtin = require("telescope.builtin")
    local actions = require("telescope.actions")

    local function get_selected_text()
      local a_orig = vim.fn.getreg("a")
      local mode = vim.fn.mode()
      if mode ~= "v" and mode ~= "V" then
        vim.cmd([[normal! gv]])
      end
      vim.cmd([[normal! "aygv]])
      local text = vim.fn.getreg("a")
      vim.fn.setreg("a", a_orig)
      return text
    end

    m.t({
      ["<leader><tab>"] = { builtin.buffers, "[T] Buffers" },
      c_f = { builtin.find_files, "[T] Find files" },
      c_g = { builtin.live_grep, "[T] Live grep" },
      c_p = { builtin.resume, "[T] Resume" },
      c_c = { builtin.grep_string, "[T] Grep cursor" },
      c_q = { builtin.quickfix, "[T] Quickfix" },
      {
        mode = "v",
        c_c = {
          function()
            local text = get_selected_text()
            builtin.grep_string({ search = text })
          end,
          "[T] Grep cursor",
        },
      },
    })

    telescope.setup({
      defaults = {
        file_ignore_patterns = { "vendor", "node_modules", "%.git$" },
        selection_caret = "",
        entry_prefix = "",
        prompt_prefix = "",
        dynamic_preview_title = true,
        mappings = {
          i = {
            ["<Tab>"] = "move_selection_worse",
            ["<S-Tab>"] = "move_selection_better",
            ["<C-k>"] = actions.cycle_history_next,
            ["<C-j>"] = actions.cycle_history_prev,
            ["<C-a>"] = actions.toggle_selection,
            ["<esc>"] = actions.close,
          },
        },
        layout_strategy = "flex",
      },
      pickers = {
        find_files = {
          hidden = true,
        },
        buffers = {
          ignore_current_buffer = true,
          sort_mru = true,
        },
      },
    })

    require("telescope").load_extension("fzf")
  end,
}
