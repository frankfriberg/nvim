local git = require("helpers.git")
return {
  "stevearc/resession.nvim",
  config = function()
    local autocmd = vim.api.nvim_create_autocmd
    local resession = require("resession")

    resession.setup({
      buf_filter = function(bufnr)
        local buftype = vim.bo[bufnr].buftype
        if buftype == "help" then
          return true
        end

        if buftype ~= "" and buftype ~= "acwrite" then
          return false
        end

        if buftype == "nofile" then
          return false
        end

        if vim.api.nvim_buf_get_name(bufnr) == "" then
          return false
        end

        return vim.bo[bufnr].buflisted
      end,
    })

    local function get_session_name()
      local cwd = vim.fn.getcwd()
      local branch = git.get_current_branch()
      if vim.v.shell_error == 0 then
        return string.format("%s__%s", cwd, branch)
      else
        return cwd
      end
    end

    local function close_everything()
      local is_floating_win = vim.api.nvim_win_get_config(0).relative ~= ""
      if is_floating_win then
        -- Go to the first window, which will not be floating
        vim.cmd.wincmd({ args = { "w" }, count = 1 })
      end

      -- Collect all floating windows and their buffers to preserve them
      local floating_win_bufs = {}
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_config(win).relative ~= "" then
          local buf = vim.api.nvim_win_get_buf(win)
          floating_win_bufs[buf] = true
        end
      end

      local scratch = vim.api.nvim_create_buf(false, true)
      vim.bo[scratch].bufhidden = "wipe"
      vim.api.nvim_win_set_buf(0, scratch)
      vim.bo[scratch].buftype = ""

      -- Delete all buffers except those used by floating windows
      for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[bufnr].buflisted and vim.api.nvim_buf_is_valid(bufnr) and not floating_win_bufs[bufnr] then
          vim.api.nvim_buf_delete(bufnr, { force = true })
        end
      end

      vim.cmd.tabonly({ mods = { emsg_silent = true } })

      -- Close only non-floating windows, preserving the current one
      local current_win = vim.api.nvim_get_current_win()
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if win ~= current_win and vim.api.nvim_win_get_config(win).relative == "" then
          vim.api.nvim_win_close(win, true)
        end
      end
    end

    autocmd("VimEnter", {
      callback = function()
        if vim.fn.argc(-1) == 0 then
          resession.load(get_session_name(), { dir = "dirsession", silence_errors = true })
        end
      end,
      desc = "Load the session if nvim was started with no args",
    })

    autocmd({ "VimLeavePre", "TermOpen" }, {
      callback = function()
        resession.save(get_session_name(), { dir = "dirsession", notify = false })
      end,
      desc = "Save the session on exit or when opening a terminal",
    })

    autocmd("User", {
      pattern = "LazyGitBranchChanged",
      callback = function()
        local session_name = get_session_name()
        local session_file = require("resession.util").get_session_file(session_name, "dirsession")
        local session_data = require("resession.files").load_json_file(session_file)

        if session_data then
          resession.load(session_name, { dir = "dirsession", silence_errors = true, notify = true })
        else
          close_everything()
          resession.save(session_name, { dir = "dirsession", notify = true })
        end
      end,
    })
  end,
}
