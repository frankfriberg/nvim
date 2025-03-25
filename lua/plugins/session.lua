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
      local name = vim.fn.getcwd()
      local branch = git.get_current_branch()
      if vim.v.shell_error == 0 then
        return name .. branch
      else
        return name
      end
    end

    local function close_everything()
      local is_floating_win = vim.api.nvim_win_get_config(0).relative ~= ""
      if is_floating_win then
        -- Go to the first window, which will not be floating
        vim.cmd.wincmd({ args = { "w" }, count = 1 })
      end

      local scratch = vim.api.nvim_create_buf(false, true)
      vim.bo[scratch].bufhidden = "wipe"
      vim.api.nvim_win_set_buf(0, scratch)
      vim.bo[scratch].buftype = ""
      for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[bufnr].buflisted then
          vim.api.nvim_buf_delete(bufnr, { force = true })
        end
      end
      vim.cmd.tabonly({ mods = { emsg_silent = true } })
      vim.cmd.only({ mods = { emsg_silent = true } })
    end

    autocmd("VimEnter", {
      callback = function()
        -- Only load the session if nvim was started with no args
        if vim.fn.argc(-1) == 0 then
          resession.load(get_session_name(), { dir = "dirsession", silence_errors = true })
        end
      end,
    })

    autocmd("VimLeavePre", {
      callback = function()
        resession.save(get_session_name(), { dir = "dirsession", notify = false })
      end,
    })

    vim.api.nvim_create_autocmd("BufWritePost", {
      pattern = ".git/HEAD",
      callback = function()
        -- Your action here
        vim.notify("Git branch changed!")
        -- You can also call any Neovim commands or functions here
      end,
    })

    autocmd("User", {
      pattern = "LazyGitBranchChanged",
      callback = function(event)
        vim.notify("Loading session for " .. event.data.new_branch, vim.log.levels.INFO, {
          title = "resession.nvim",
        })

        local name = get_session_name()
        local session_name = name .. event.data.new_branch
        local session_file = require("resession.util").get_session_file(session_name, "dirsession")
        local session_data = require("resession.files").load_json_file(session_file)

        if session_data then
          resession.load(session_name, { dir = "dirsession", silence_errors = true })
        else
          close_everything()

          resession.save(session_name, { dir = "dirsession", notify = false })
        end
      end,
    })
  end,
}
