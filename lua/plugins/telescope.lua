return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-media-files.nvim",
  },
  config = function()
    local telescope = require("telescope")
    local tb = require("telescope.builtin")
    local ta = require("telescope.actions")

    local function buf_vtext()
      local a_orig = vim.fn.getreg('a')
      local mode = vim.fn.mode()
      if mode ~= 'v' and mode ~= 'V' then
        vim.cmd([[normal! gv]])
      end
      vim.cmd([[normal! "aygv]])
      local text = vim.fn.getreg('a')
      vim.fn.setreg('a', a_orig)
      return text
    end

    local map = require("ff.map")

    local pickers = {
      {
        name = tb.find_files,
      },
      {
        name = tb.find_files,
        opts = {
          hidden = true,
          prompt_title = "Find Files [Hidden]",
        }
      },
      {
        name = tb.live_grep,
      },
      {
        name = tb.live_grep,
        opts = {
          hidden = true,
          prompt_title = "Live Grep [Hidden]",
        }
      },
      {
        name = tb.oldfiles,
      },
      index = 1
    }

    pickers.cycle = function(index, clear)
      local picker = pickers[index]
      local options = picker.opts or {}
      if clear == nil then
        options.default_text = require("telescope.actions.state").get_current_line()
      end
      picker.name(options)
    end

    pickers.next = function()
      if pickers.index >= #pickers then
        pickers.index = 1
      else
        pickers.index = pickers.index + 1
      end
      pickers.cycle(pickers.index, false)
    end

    pickers.prev = function()
      if pickers.index == 1 then
        pickers.index = #pickers
      else
        pickers.index = pickers.index - 1
      end
      pickers.cycle(pickers.index, false)
    end


    map.t({
      ["<leader><tab>"] = { tb.buffers, "[T] Buffers" },
      c_f = { function() pickers.cycle(1, true) end, "[T] Find files" },
      c_g = { function() pickers.cycle(3, true) end, "[T] Live grep" },
      c_p = { tb.resume, "[T] Resume" },
      c_c = { tb.grep_string, "[T] Grep cursor" },
      c_b = { tb.git_branches, "[T] Git branches" },
      {
        mode = "v",
        c_c = { function()
          local text = buf_vtext()
          tb.grep_string({ search = text })
        end, "[T] Grep cursor" }
      }
    })

    telescope.setup({
      defaults = {
        file_ignore_patterns = { "vendor" },
        selection_caret = "",
        entry_prefix = "",
        prompt_prefix = "",
        mappings = {
          i = {
            ["<Tab>"] = "move_selection_worse",
            ["<S-Tab>"] = "move_selection_better",
            ["<C-l>"] = pickers.next,
            ["<C-h>"] = pickers.prev,
            ["<C-k>"] = ta.cycle_history_next,
            ["<C-j>"] = ta.cycle_history_prev,
            ["<C-u>"] = false,
            ["<esc>"] = ta.close,
          },
        },
        path_display = { "smart" },
        layout_strategy = "flex",
        layout_config = {
          cursor = {
            height = 0.3,
            preview_cutoff = 40,
            preview_width = 0.5,
            width = 100
          },
          horizontal = {
            preview_width = 0.55,
            width = 0.7,
            height = 0.7
          },
        },
      },
      pickers = {
        git_branches = {
          mappings = {
            i = { ["cr"] = ta.git_switch_branch }
          }
        },
        lsp_references = {
          theme = "dropdown",
          path_display = function(_, path)
            local tail = require("telescope.utils").path_tail(path)
            return vim.fn.fnamemodify(path, ":p:h:t") .. "/" .. tail
          end,
        },
        buffers = {
          theme = "dropdown",
          previewer = false,
          sort_mru = true,
          ignore_current_buffer = true,
          mappings = {
            i = {
              ["<C-d>"] = "delete_buffer"
            }
          }
        },
        oldfiles = {
          theme = "dropdown",
          previewer = false,
          sort_mru = true,
        }
      },
      extensions = {
        media_files = {
          filetypes = { "png", "webp", "jpg", "jpeg" },
          find_cmd = "rg",
        },
      },
      dynamic_preview_title = true,
    })

    telescope.load_extension("media_files")
  end,
}
