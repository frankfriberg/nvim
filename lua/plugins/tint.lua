return {
  "levouh/tint.nvim",
  event = "BufEnter",
  enabled = false,
  opts = function()
    return {
      highlight_ignore_patterns = { "WinSeparator", "Status.*" },
      tint_background_colors = true,
      transforms = {
        require("tint.transforms").tint_with_threshold(-25, "#2d353b", 150),
        require("tint.transforms").saturate(0.8),
      },
      window_ignore_function = function(winid)
        local bufid = vim.api.nvim_win_get_buf(winid)
        local buftype = vim.api.nvim_buf_get_option(bufid, "buftype")
        local floating = vim.api.nvim_win_get_config(winid).relative ~= ""

        -- Do not tint `terminal` or floating windows, tint everything else
        return buftype == "terminal" or floating
      end
    }
  end
}
