return {
  "lewis6991/gitsigns.nvim",
  event = "BufEnter",
  opts = {
    attach_to_untracked = false,
    signcolumn = false,
    numhl = true,
    on_attach = function()
      local gs = package.loaded.gitsigns
      local map = require("helpers.map")

      map.t({
        group = { "<leader>g", "GitSigns" },
        u = { gs.undo_stage_hunk, "[Git] Undo stage hunk" },
        p = { gs.preview_hunk, "[Git] Preview hunk" },
        t = { gs.toggle_current_line_blame, "[Git] Toggle current line blame" },
        d = { gs.diffthis, "[Git] Diff current line" },
        x = { gs.toggle_deleted, "[Git] Toggle deleted" },
        l = { gs.next_hunk, "[Git] Next hunk" },
        h = { gs.prev_hunk, "[Git] Previous hunk" },
        D = {
          function()
            gs.diffthis("~")
          end,
          "[Git] Diff",
        },
        S = { gs.stage_buffer, "[Git] Stage buffer" },
        s = { gs.stage_hunk, "[Git] Stage hunk" },
        r = { gs.reset_hunk, "[Git] Reset hunk" },
        R = { gs.reset_buffer, "[Git] Reset buffer" },
        {
          mode = "v",
          s = {
            function()
              gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
            end,
            "[Git] Stage hunk range",
          },
          r = {
            function()
              gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
            end,
            "[Git] Reset hunk range",
          },
        },
      })
    end,
  },
}
