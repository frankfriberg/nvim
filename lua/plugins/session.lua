return {
  "Shatur/neovim-session-manager",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  lazy = false,
  priority = 900,
  init = function() end,
  opts = function()
    local sm_config = require("session_manager.config")
    local sm_utils = require("session_manager.utils")
    local Path = require("plenary.path")
    local path_replacer = "__"
    local colon_replacer = "++"

    local function get_branch_name()
      if vim.g.branch_name then
        return vim.g.branch_name
      end

      local branch = vim.fn.system("git branch --show-current")

      if branch ~= "" then
        return branch:gsub("\n", "")
      else
        return nil
      end
    end

    local function convert_filename_to_dir(filename)
      local filename_without_extra = filename:sub(1, (filename:find("@") or 0) - 1)
      local dir = filename_without_extra:sub(#tostring(sm_config.sessions_dir) + 2)

      dir = dir:gsub(colon_replacer, ":")
      dir = dir:gsub(path_replacer, Path.path.sep)
      return Path:new(dir)
    end

    local function convert_dir_to_filename(dir, branch)
      if not branch then
        branch = get_branch_name()
      end

      local filename = dir:gsub(":", colon_replacer)
      filename = filename:gsub(Path.path.sep, path_replacer)

      if branch then
        filename = filename .. "@" .. branch
      end

      return Path:new(sm_config.sessions_dir):joinpath(filename)
    end

    vim.api.nvim_create_autocmd({ "User" }, {
      pattern = "NeogitBranchCheckout",
      callback = function(ctx)
        local cwd = vim.loop.cwd()

        if cwd then
          local session = convert_dir_to_filename(cwd, ctx.data.branch_name)
          if session:exists() then
            sm_utils.load_session(session.filename)
          end
        end
      end,
    })

    return {
      autoload_mode = sm_config.AutoloadMode.CurrentDir,
      session_filename_to_dir = convert_filename_to_dir,
      dir_to_session_filename = convert_dir_to_filename,
      autosave_last_session = true,
      autosave_ignore_not_normal = true,
      autosave_ignore_filetypes = {
        "gitcommit",
        "gitrebase",
      },
      max_path_length = 0,
    }
  end,
}
