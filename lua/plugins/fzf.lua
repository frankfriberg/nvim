return {
  "ibhagwan/fzf-lua",
  dependencies = { "echasnovski/mini.icons" },
  init = function()
    local map = require("helpers.map")
    local fzf = require("fzf-lua")

    map.t({
      {
        mode = "n",
        gd = {
          function()
            fzf.lsp_definitions({ jump_to_single_result = true })
          end,
          "Fzf Definition",
        },
        gr = {
          function()
            fzf.lsp_references({ jump_to_single_result = true, ignore_current_line = true })
          end,
          "Fzf References",
        },
        gI = { fzf.lsp_implementations, "Fzf Implementations" },
        ["<leader><tab>"] = {
          function()
            fzf.buffers({ winopts = { width = 120 } })
          end,
          "Fzf Buffers",
        },
        c_f = {
          function()
            fzf.files({ winopts = { width = 120 } })
          end,
          "Fzf Files",
        },
        c_g = { fzf.live_grep_native, "Fzf Live Grep" },
        c_p = { fzf.resume, "Fzf Resume" },
        c_c = { fzf.grep_cword, "Fzf Grep cursor" },
        c_q = { fzf.quickfix, "Fzf Quickfix" },
      },
      {
        mode = "v",
        c_c = { fzf.grep_visual, "Fzf Grep cursor" },
      },
    })
  end,
  opts = function()
    local actions = require("fzf-lua").actions

    return {
      winopts = {
        border = vim.g.border,
        backdrop = 100,
        height = 0.5,
        width = 200,
        row = 0.5,
        col = 0.5,
        preview = {
          border = vim.g.border,
          horizontal = "right:50%",
        },
        on_create = function()
          vim.keymap.set("t", "<Tab>", "<Down>", { silent = true, buffer = true })
          vim.keymap.set("t", "<S-Tab>", "<Up>", { silent = true, buffer = true })
        end,
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
