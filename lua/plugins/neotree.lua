return {
  "nvim-neo-tree/neo-tree.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  opts = function()
    local m = require("ff.map")
    local utils = require("neo-tree.utils")
    local highlights = require("neo-tree.ui.highlights")
    local events = require("neo-tree.events")
    local cmds = require("neo-tree.sources.filesystem.commands")
    local inputs = require("neo-tree.ui.inputs")

    m.n("<leader>e", ":Neotree reveal <cr>", "Neotree reveal")

    local function on_file_remove(args)
      local ts_clients = vim.lsp.get_active_clients({ name = "tsserver" })
      for _, ts_client in ipairs(ts_clients) do
        ts_client.request("workspace/executeCommand", {
          command = "_typescript.applyRenameFile",
          arguments = {
            {
              sourceUri = vim.uri_from_fname(args.source),
              targetUri = vim.uri_from_fname(args.destination),
            },
          },
        })
      end
    end

    local addUnderline = function(name, color)
      local current_def = vim.api.nvim_get_hl(0, { name = name, link = false })
      if color then
        color = vim.api.nvim_get_hl(0, { name = color, link = false }).fg
      else
        color = vim.api.nvim_get_hl(0, { name = "Red" }).fg
      end
      local new_def = vim.tbl_extend('force', current_def, { underline = true, sp = color })
      vim.api.nvim_set_hl(0, name .. "Underlined", new_def)

      return name .. "Underlined"
    end

    local function trash(state)
      local tree = state.tree
      local node = tree:get_node()
      if node.type == "message" then
        return
      end
      local _, name = utils.split_path(node.path)
      local msg = string.format("Are you sure you want to trash '%s'?", name)
      inputs.confirm(msg, function(confirmed)
        if not confirmed then
          return
        end
        vim.api.nvim_command("silent !trash -F " .. node.path)
        cmds.refresh(state)
      end)
    end

    return {
      open_files_do_not_replace_types = { "terminal", "Trouble", "qf", "edgy" },
      popup_border_style = "rounded",
      follow_current_file = true,
      filesystem = {
        window = {
          mappings = {
            ["d"] = trash,
          },
        },
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
          never_show = {
            ".DS_Store",
            "thumbs.db"
          },
        },
        components = {
          opened = function(config, node, state)
            local opened_buffers = state.opened_buffers or {}
            if opened_buffers[node.path] and opened_buffers[node.path].loaded then
              return {
                text = "",
                highlight = config.highlight or "NeoTreeDirectoryIcon"
              }
            end

            return {}
          end,
          name = function(config, node, state)
            local opened_buffers = state.opened_buffers or {}
            local highlight = config.highlight or highlights.FILE_NAME
            if node.type == "directory" then
              highlight = highlights.DIRECTORY_NAME
            end
            if node:get_depth() == 1 then
              highlight = highlights.ROOT_NAME
            else
              if config.use_git_status_colors == nil or config.use_git_status_colors then
                local git_status = state.components.git_status({}, node, state)
                if git_status and git_status.highlight then
                  if opened_buffers[node.path] and opened_buffers[node.path].modified then
                    highlight = addUnderline(git_status.highlight)
                  else
                    highlight = git_status.highlight
                  end
                elseif opened_buffers[node.path] and opened_buffers[node.path].modified then
                  highlight = addUnderline(highlight)
                end
              end
            end
            return {
              text = node.name,
              highlight = highlight,
            }
          end
        },
        renderers = {
          file = {
            { "indent" },
            { "icon" },
            {
              "container",
              content = {
                { "name",          zindex = 10 },
                { "opened",        zindex = 10 },
                { "diagnostics",   align = "right", zindex = 20 },
                { "git_status",    align = "right", zindex = 20 },
              }
            }
          },
        },
      },
      event_handlers = {
        {
          event = events.FILE_DELETED,
          handler = on_file_remove,
        },
        {
          event = events.FILE_RENAMED,
          handler = on_file_remove,
        },
        {
          event = events.FILE_OPENED,
          handler = function()
            require("neo-tree.sources.manager").close_all()
          end,
        },
      },
      default_component_configs = {
        modified = {
          symbol = ""
        },
        indent = {
          with_expanders = true,
          expander_collapsed = "",
          expander_expanded = "",
        },
        icon = {
          folder_closed = "󰉋",
          folder_open = "󰝰",
          folder_empty = "󱧊",
        },
        git_status = {
          symbols = {
            added = "󰐕",
            deleted = "󰍴",
            modified = "󰇼",
            renamed = "󰁔",
            untracked = "*",
            ignored = "",
            unstaged = "",
            staged = "",
            conflict = "󰦒",
          },
        },
      },
    }
  end,
}
