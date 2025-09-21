return {
  "ibhagwan/fzf-lua",
  dependencies = { "echasnovski/mini.icons" },
  keys = require("helpers.map").l({
    gr = {
      function()
        require("fzf-lua").lsp_references({ ignore_current_line = true })
      end,
      "Fzf References",
    },
    gI = {
      function()
        require("fzf-lua").lsp_implementations()
      end,
      "Fzf Implementations",
    },
    {
      group = { "<leader>f", "Fzf" },
      f = {
        function()
          require("fzf-lua").global()
        end,
        "Global Search",
      },
      e = {
        function()
          require("fzf-lua").buffers()
        end,
        "Buffers",
      },
      g = {
        function()
          require("fzf-lua").live_grep_native()
        end,
        "Live Grep",
      },
      r = {
        function()
          require("fzf-lua").resume()
        end,
        "Resume",
      },
      c = {
        function()
          require("fzf-lua").grep_cword()
        end,
        "Grep cursor",
      },
      s = {
        function()
          require("fzf-lua").lgrep_curbuf()
        end,
        "Current Buffer",
      },
      d = {
        function()
          require("fzf-lua").diagnostics_document()
        end,
        "Buffer Diagnostics",
      },
      w = {
        function()
          require("fzf-lua").diagnostics_workspace()
        end,
        "Workspace Diagnostics",
      },
      {
        mode = "v",
        v = {
          function()
            require("fzf-lua").grep_visual()
          end,
          "Grep Visual",
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
      defaults = {
        formatter = "path.dirname_first",
      },
      global = {
        cwd_prompt = false,
        actions = {
          ["ctrl-g"] = { actions.toggle_ignore },
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
          width = 50,
        },
      },
      buffers = {
        previewer = false,
        actions = {
          ["ctrl-x"] = false,
          ["ctrl-d"] = { actions.buf_del, actions.resume },
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
