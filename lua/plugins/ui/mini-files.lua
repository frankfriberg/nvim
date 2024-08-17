return {
  "echasnovski/mini.files",
  init = function()
    local map = require("helpers.map")

    map.t({
      ["<leader>e"] = {
        function()
          MiniFiles.open(vim.api.nvim_buf_get_name(0))
        end,
        "MiniFiles Open Current File",
      },
      l_s_tab = {
        function()
          MiniFiles.open()
        end,
        "MiniFiles Open",
      },
    })

    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniFilesActionDelete",
      callback = function(args)
        local remove_ok, mini_remove = pcall(require, "mini.bufremove")
        local deleted_file = args.data.from

        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          local buf_name = vim.api.nvim_buf_get_name(buf)
          if buf_name == deleted_file then
            return remove_ok and mini_remove.delete(buf) or vim.api.nvim_buf_delete(buf, { force = true })
          end
        end
      end,
    })

    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniFilesWindowOpen",
      callback = function(args)
        local win_id = args.data.win_id

        -- Customize window-local settings
        vim.api.nvim_win_set_config(win_id, { border = "rounded" })
      end,
    })

    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniFilesBufferCreate",
      callback = function(args)
        map.n("<C-w>c", "q", "Close mini files", { buffer = args.data.buf_id, remap = true })
      end,
    })

    local function lsp_notify(data, method)
      local clients = vim.lsp.get_clients({ method = method })
      for _, client in pairs(clients) do
        client.notify(method, {
          files = {
            oldUri = data.from,
            newUri = data.to,
          },
        })
      end
    end

    vim.api.nvim_create_autocmd("User", {
      pattern = { "MiniFilesActionRename", "MiniFilesActionMove" },
      callback = function(data)
        lsp_notify(data, "workspace/didRenameFiles")
      end,
    })

    vim.api.nvim_create_autocmd("User", {
      pattern = { "MiniFilesActionCreate", "MiniFilesActionCopy" },
      callback = function(data)
        lsp_notify(data, "workspace/didCreateFiles")
      end,
    })

    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniFilesActionDelete",
      callback = function(data)
        lsp_notify(data, "workspace/didDeleteFiles")
      end,
    })
  end,
  opts = {
    content = {
      filter = function(fs_entry)
        return not vim.startswith(fs_entry.name, ".DS_Store")
      end,
    },
  },
}
