return {
  "levouh/tint.nvim",
  event = "BufEnter",
  opts = function()
    return {
      highlight_ignore_patterns = { "WinSeparator", "Status.*" },
      tint_background_colors = true,
      transforms = {
        require("tint.transforms").tint_with_threshold(-25, "#2d353b", 150),
        require("tint.transforms").saturate(0.8),
      }
    }
  end
}
