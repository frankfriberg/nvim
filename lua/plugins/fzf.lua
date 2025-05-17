return {
  "ibhagwan/fzf-lua",
  dependencies = { "echasnovski/mini.icons" },
  init = function()
    local map = require("helpers.map")
    local fzf = require("fzf-lua")

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

    map.t({
      {
        mode = "n",
        gr = {
          function()
            fzf.lsp_references({ ignore_current_line = true })
          end,
          "Fzf References",
        },
        gI = { fzf.lsp_implementations, "Fzf Implementations" },
        fe = {
          function()
            fzf.buffers({ winopts = { width = 120 } })
          end,
          "Fzf Buffers",
        },
        ff = {
          function()
            fzf.files({ winopts = { width = 120 } })
          end,
          "Fzf Files",
        },
        fg = { fzf.live_grep_native, "Fzf Live Grep" },
        fp = { fzf.resume, "Fzf Resume" },
        fc = { fzf.grep_cword, "Fzf Grep cursor" },
        fs = { fzf.lgrep_curbuf, "Fzf Current Buffer" },
      },
      {
        mode = "v",
        fc = { fzf.grep_visual, "Fzf Grep cursor" },
      },
    })
  end,
  opts = function()
    local actions = require("fzf-lua").actions

    return {
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
      files = {
        previewer = false,
        cwd_prompt = false,
        git_icons = false,
        actions = {
          ["ctrl-g"] = { actions.toggle_ignore },
        },
      },
      buffers = {
        previewer = false,
        actions = {
          ["ctrl-x"] = false,
          ["ctrl-d"] = { actions.buf_del, actions.resume },
        },
      },
      fzf_colors = {
        true,
        ["bg"] = "-1",
      },
    }
  end,
}
