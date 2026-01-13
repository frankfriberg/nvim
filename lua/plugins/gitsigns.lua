return {
  "lewis6991/gitsigns.nvim",
  event = "VeryLazy",
  opts = {
    word_diff = false,
    numhl = true,
    on_attach = function()
      local gs = require("gitsigns")
      local map = require("helpers.map")

      local ok = pcall(require, "scrollbar.handlers.gitsigns")

      if ok then
        require("scrollbar.handlers.gitsigns").setup()
      end

      map.t({
        -- Navigation
        ["]h"] = {
          function()
            if vim.wo.diff then
              vim.cmd.normal({ "]c", bang = true })
            else
              gs.nav_hunk("next")
            end
          end,
          desc = "Next git hunk",
        },
        ["[h"] = {
          function()
            if vim.wo.diff then
              vim.cmd.normal({ "[c", bang = true })
            else
              gs.nav_hunk("prev")
            end
          end,
          desc = "Prev git hunk",
        },
        ih = {
          mode = { "o", "x" },
          gs.select_hunk,
          desc = "Select hunk",
        },
        -- Actions
        {
          group = { "<leader>g", "Git" },
          s = {
            gs.stage_hunk,
            desc = "Stage hunk",
          },
          r = {
            gs.reset_hunk,
            desc = "Reset hunk",
          },
          S = {
            gs.stage_buffer,
            desc = "Stage buffer",
          },
          R = {
            gs.reset_buffer,
            desc = "Reset buffer",
          },
          p = {
            gs.preview_hunk,
            desc = "Preview hunk",
          },
          i = {
            gs.preview_hunk_inline,
            desc = "Preview hunk inline",
          },
          B = {
            gs.blame,
            desc = "Blame",
          },
          b = {
            function()
              require("gitsigns").blame_line({ full = true })
            end,
            desc = "Blame line",
          },
          w = {
            gs.toggle_word_diff,
            desc = "Toggle word diff",
          },
          {
            mode = "v",
            s = {
              function()
                require("gitsigns").stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
              end,
              desc = "Stage hunk (visual)",
            },
            r = {
              function()
                require("gitsigns").reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
              end,
              desc = "Reset hunk (visual)",
            },
          },
        },
      })
    end,
  },
}
