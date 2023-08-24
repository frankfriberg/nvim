local border = require("plugins.ui.borders").borders
return {
  "rcarriga/nvim-notify",
  opts = {
    max_width = 100,
    render = function(bufnr, notif, highlights)
      local base = require("notify.render.base")
      local namespace = base.namespace()
      local icon = notif.icon
      local title = notif.title[1]

      local prefix
      if type(title) == "string" and #title > 0 then
        prefix = string.format(" %s %s:", icon, title)
      else
        prefix = string.format(" %s ", icon)
      end
      notif.message[1] = string.format("%s %s", prefix, notif.message[1])

      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, notif.message)

      local icon_length = vim.str_utfindex(icon)
      local prefix_length = vim.str_utfindex(prefix)

      vim.api.nvim_buf_set_extmark(bufnr, namespace, 0, 0, {
        hl_group = highlights.icon,
        end_col = icon_length + 1,
        priority = 50,
      })
      vim.api.nvim_buf_set_extmark(bufnr, namespace, 0, icon_length + 1, {
        hl_group = highlights.title,
        end_col = prefix_length + 1,
        priority = 50,
      })
      vim.api.nvim_buf_set_extmark(bufnr, namespace, 0, prefix_length + 1, {
        hl_group = highlights.body,
        end_line = #notif.message,
        priority = 50,
      })
    end,
    stages = {
      function(state)
        local stages_util = require("notify.stages.util")

        local next_height = state.message.height + 2
        local next_row = stages_util.available_slot(state.open_windows, next_height, stages_util.DIRECTION.TOP_DOWN)
        if not next_row then
          return nil
        end
        return {
          relative = "editor",
          anchor = "NE",
          width = 1,
          height = state.message.height,
          col = vim.opt.columns:get() - 2,
          row = next_row,
          border = border,
          style = "minimal",
        }
      end,
      function(state)
        return {
          width = { state.message.width, frequency = 2 },
          col = { vim.opt.columns:get() - 2 },
        }
      end,
      function()
        return {
          col = { vim.opt.columns:get() - 2 },
          time = true,
        }
      end,
      function()
        return {
          width = {
            1,
            frequency = 2.5,
            damping = 0.9,
            complete = function(cur_width)
              return cur_width < 2
            end,
          },
          col = { vim.opt.columns:get() - 2 },
        }
      end
    }

  },
}
