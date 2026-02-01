-- Window width based on the offset from the center, i.e. center window
-- is 60, then next over is 20, then the rest are 10.
-- Can use more resolution if you want like { 60, 20, 20, 10, 5 }
local widths = { 60, 40, 20 }

local ensure_center_layout = function(ev)
  local state = require("mini.files").get_explorer_state()
  if state == nil then
    return
  end

  -- Compute "depth offset" - how many windows are between this and focused
  local path_this = vim.api.nvim_buf_get_name(ev.data.buf_id):match("^minifiles://%d+/(.*)$")
  local depth_this
  for i, path in ipairs(state.branch) do
    if path == path_this then
      depth_this = i
    end
  end
  if depth_this == nil then
    return
  end
  local depth_offset = depth_this - state.depth_focus

  -- Adjust config of this event's window
  local i = math.abs(depth_offset) + 1
  local win_config = vim.api.nvim_win_get_config(ev.data.win_id)
  win_config.width = i <= #widths and widths[i] or widths[#widths]

  win_config.zindex = 99
  win_config.col = math.floor(0.5 * (vim.o.columns - widths[1]))
  local sign = depth_offset == 0 and 0 or (depth_offset > 0 and 1 or -1)
  for j = 1, math.abs(depth_offset) do
    -- widths[j+1] for the negative case because we don't want to add the center window's width
    local prev_win_width = (sign == -1 and widths[j + 1]) or widths[j] or widths[#widths]
    -- Add an extra +2 each step to account for the border width
    local new_col = win_config.col + sign * (prev_win_width + 2)
    if (new_col < 0) or (new_col + win_config.width > vim.o.columns) then
      win_config.zindex = win_config.zindex - 1
      break
    end
    win_config.col = new_col
  end

  win_config.height = depth_offset == 0 and 24 or 20
  win_config.row = math.floor(0.5 * (vim.o.lines - win_config.height))
  vim.api.nvim_win_set_config(ev.data.win_id, win_config)
end

return {
  "nvim-mini/mini.files",
  version = false,
  dependencies = {
    "nvim-mini/mini.icons",
  },
  keys = require("helpers.map").lazy({
    l_e = {
      function()
        require("mini.files").open(vim.api.nvim_buf_get_name(0))
        require("mini.files").reveal_cwd()
      end,
      desc = "Open Mini Files at buffer",
    },
    l_E = {
      function()
        require("mini.files").open()
      end,
      desc = "Open Mini Files at CWD",
    },
  }),
  opts = {
    mappings = {
      go_in_plus = "<CR>",
      go_in = "<C-CR>",
      go_out = "-",
      synchronize = "<leader>w",
    },
    windows = {
      width_nofocus = 30,
    },
  },
  init = function()
    local handle_rename_move = function(args)
      local data = args.data
      if not data or not data.from or not data.to then
        return
      end

      local changes = {
        files = {
          {
            oldUri = vim.uri_from_fname(data.from),
            newUri = vim.uri_from_fname(data.to),
          },
        },
      }

      -- Send willRenameFiles requests to LSP clients
      local clients = vim.lsp.get_clients()
      for _, client in ipairs(clients) do
        if client:supports_method("workspace/willRenameFiles") then
          local resp = client:request_sync("workspace/willRenameFiles", changes, 1000, 0)
          if resp and resp.result ~= nil then
            vim.lsp.util.apply_workspace_edit(resp.result, client.offset_encoding)
          end
        end
      end

      -- Send didRenameFiles notifications
      vim.schedule(function()
        for _, client in ipairs(clients) do
          if client:supports_method("workspace/didRenameFiles") then
            client:notify("workspace/didRenameFiles", changes)
          end
        end
      end)
    end

    -- Handle create actions (including copy)
    local handle_create = function(args)
      local data = args.data
      if not data or not data.to then
        return
      end

      local changes = {
        files = {
          { uri = vim.uri_from_fname(data.to) },
        },
      }

      -- Send willCreateFiles requests to LSP clients
      local clients = vim.lsp.get_clients()
      for _, client in ipairs(clients) do
        if client:supports_method("workspace/willCreateFiles") then
          local resp = client:request_sync("workspace/willCreateFiles", changes, 1000, 0)
          if resp and resp.result ~= nil then
            vim.lsp.util.apply_workspace_edit(resp.result, client.offset_encoding)
          end
        end
      end

      -- Send didCreateFiles notifications
      vim.schedule(function()
        for _, client in ipairs(clients) do
          if client:supports_method("workspace/didCreateFiles") then
            client:notify("workspace/didCreateFiles", changes)
          end
        end
      end)
    end

    -- Handle delete actions
    local handle_delete = function(args)
      local data = args.data
      if not data or not data.from then
        return
      end

      local changes = {
        files = {
          { uri = vim.uri_from_fname(data.from) },
        },
      }

      -- Send willDeleteFiles requests to LSP clients
      local clients = vim.lsp.get_clients()
      for _, client in ipairs(clients) do
        if client:supports_method("workspace/willDeleteFiles") then
          local resp = client:request_sync("workspace/willDeleteFiles", changes, 1000, 0)
          if resp and resp.result ~= nil then
            vim.lsp.util.apply_workspace_edit(resp.result, client.offset_encoding)
          end
        end
      end

      -- Send didDeleteFiles notifications
      vim.schedule(function()
        for _, client in ipairs(clients) do
          if client:supports_method("workspace/didDeleteFiles") then
            client:notify("workspace/didDeleteFiles", changes)
          end
        end
      end)
    end

    -- Register for rename and move events
    vim.api.nvim_create_autocmd("User", {
      pattern = { "MiniFilesActionRename", "MiniFilesActionMove" },
      callback = handle_rename_move,
    })

    -- Register for create and copy events
    vim.api.nvim_create_autocmd("User", {
      pattern = { "MiniFilesActionCreate", "MiniFilesActionCopy" },
      callback = handle_create,
    })

    -- Register for delete events
    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniFilesActionDelete",
      callback = handle_delete,
    })

    vim.api.nvim_create_autocmd("User", { pattern = "MiniFilesWindowUpdate", callback = ensure_center_layout })
  end,
}
