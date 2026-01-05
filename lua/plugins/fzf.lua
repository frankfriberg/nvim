return {
  "ibhagwan/fzf-lua",
  dependencies = { "echasnovski/mini.icons" },
  keys = require("helpers.map").lazy({
    gr = {
      function()
        require("fzf-lua").lsp_references({ ignore_current_line = true })
      end,
      desc = "Fzf References",
    },
    gI = {
      function()
        require("fzf-lua").lsp_implementations()
      end,
      desc = "Fzf Implementations",
    },
    {
      group = { "<leader>f", "Fzf" },
      f = {
        function()
          require("fzf-lua").global()
        end,
        desc = "Global Search",
      },
      e = {
        function()
          require("fzf-lua").buffers()
        end,
        desc = "Buffers",
      },
      g = {
        function()
          require("fzf-lua").live_grep_native()
        end,
        desc = "Live Grep",
      },
      r = {
        function()
          require("fzf-lua").resume()
        end,
        desc = "Resume",
      },
      v = {
        function()
          require("fzf-lua").grep_cword()
        end,
        desc = "Grep cursor",
      },
      s = {
        function()
          require("fzf-lua").lgrep_curbuf()
        end,
        desc = "Current Buffer",
      },
      d = {
        function()
          require("fzf-lua").diagnostics_document()
        end,
        desc = "Buffer Diagnostics",
      },
      w = {
        function()
          require("fzf-lua").diagnostics_workspace({
            diag_source = true,
          })
        end,
        desc = "Workspace Diagnostics",
      },
      {
        mode = "v",
        v = {
          function()
            require("fzf-lua").grep_visual()
          end,
          { desc = "Grep Visual" },
        },
      },
    },
  }),
  init = function()
    require("fzf-lua").register_ui_select(function(_, items)
      local min_h, max_h = 0.15, 0.70
      local h = (#items + 4) / vim.o.lines
      if h < min_h then
        h = min_h
      elseif h > max_h then
        h = max_h
      end
      return { winopts = { height = h, width = 0.60, row = 0.40 } }
    end)
  end,
  opts = function()
    local actions = require("fzf-lua").actions

    return {
      "hide",
      winopts = {
        border = vim.o.winborder,
        backdrop = 100,
        height = 0.5,
        width = 200,
        row = 0.5,
        col = 0.5,
        preview = {
          border = vim.o.winborder,
          horizontal = "right:50%",
        },
      },
      keymap = {
        fzf = {
          ["ctrl-q"] = "select-all+accept",
        },
      },
      defaults = {
        formatter = "path.dirname_first",
      },
      global = {
        cwd_prompt = false,
        actions = {
          ["ctrl-g"] = { actions.toggle_ignore },
          ["√"] = actions.file_vsplit,
        },
      },
      files = {
        previewer = false,
        cwd_prompt = false,
        git_icons = false,
        actions = {
          ["ctrl-g"] = { actions.toggle_ignore },
        },
        winopts = {
          width = 120,
        },
      },
      buffers = {
        previewer = false,
        actions = {
          ["ctrl-x"] = false,
          ["ctrl-d"] = { fn = actions.buf_del, reload = true },
          ["alt-v"] = actions.file_vsplit,
        },
        winopts = {
          width = 120,
        },
      },
      fzf_colors = {
        true,
        ["bg"] = "-1",
      },
    }
  end,
}
