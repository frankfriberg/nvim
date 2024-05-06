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
      local branch = vim.trim(vim.fn.system("git branch --show-current"))
      if vim.v.shell_error == 0 then
        return name .. branch
      else
        return name
      end
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

    autocmd("User", {
      pattern = "NeogitStatusRefreshed",
      callback = function()
        resession.save(get_session_name(), { dir = "dirsession", notify = false })
      end,
    })

    autocmd({ "User" }, {
      pattern = "NeogitBranchCheckout",
      callback = function(ctx)
        require("neogit").close()

        local name = vim.fn.getcwd()
        local session_name = name .. ctx.data.branch_name
        local session_file = require("resession.util").get_session_file(session_name, "dirsession")
        local session_data = require("resession.files").load_json_file(session_file)

        if session_data then
          resession.load(session_name, { dir = "dirsession", silence_errors = true })
        else
          local scratch = vim.api.nvim_create_buf(false, true)
          vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = scratch })
          vim.api.nvim_win_set_buf(0, scratch)
          vim.api.nvim_set_option_value("buftype", "", { buf = scratch })
          for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
            if vim.bo[bufnr].buflisted then
              vim.api.nvim_buf_delete(bufnr, { force = true })
            end
          end

          resession.save(session_name, { dir = "dirsession", notify = false })
        end
      end,
    })
  end,
}
