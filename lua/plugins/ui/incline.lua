return {
  "b0o/incline.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  opts = function()
    local devicons = require("nvim-web-devicons")

    return {
      highlight = {
        groups = {
          InclineNormal = {
            default = true,
            group = "Normal",
          },
          InclineNormalNC = {
            default = true,
            group = "Normal",
          },
        },
      },
      render = function(props)
        local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
        if filename == "" then
          filename = "[No Name]"
        end

        local ft_icon, ft_color = devicons.get_icon_color(filename)
        local modified = vim.bo[props.buf].modified
        return {
          ft_icon and { " ", ft_icon, " ", guifg = ft_color } or "",
          { filename, gui = modified and "undercurl" or "bold" },
          guibg = "none",
        }
      end,
    }
  end,
}
