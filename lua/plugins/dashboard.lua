return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  config = function()
    local dashboard = require("alpha.themes.dashboard")

    vim.api.nvim_create_augroup("alpha_on_empty", { clear = true })
    vim.api.nvim_create_autocmd("User", {
      pattern = "BDeletePost*",
      group = "alpha_on_empty",
      callback = function(event)
        local fallback_name = vim.api.nvim_buf_get_name(event.buf)
        local fallback_ft = vim.api.nvim_buf_get_option(event.buf, "filetype")
        local fallback_on_empty = fallback_name == "" and fallback_ft == ""

        if fallback_on_empty then
          vim.cmd("Alpha")
        end
      end,
    })

    dashboard.section.header.val = {
      [[      `       --._    `-._   `-.   `.     :   /  .'   .-'   _.-'    _.--'                   ]],
      [[        `--.__     `--._   `-._  `-.  `. `. : .' .'  .-'  _.-'   _.--'     __.--'           ]],
      [[           __    `--.__    `--._  `-._ `-. `. :/ .' .-' _.-'  _.--'    __.--'    __         ]],
      [[            `--..__   `--.__   `--._ `-._`-.`_=_'.-'_.-' _.--'   __.--'   __..--'           ]],
      [[          --..__   `--..__  `--.__  `--._`-q(-_-)p-'_.--'  __.--'  __..--'   __..--         ]],
      [[                ``--..__  `--..__ `--.__ `-'_) (_`-' __.--' __..--'  __..--''               ]],
      [[          ...___        ``--..__ `--..__`--/__/  --'__..--' __..--''        ___...          ]],
      [[                ```---...___    ``--..__`_(<_   _/)_'__..--''    ___...---'''               ]],
      [[           ```-----....._____```---...___(____|_/__)___...---'''_____.....-----'''          ]],
    }
    dashboard.section.buttons.val = {
      dashboard.button("f", "󰱽 Find file", ":Telescope find_files <CR>"),
      dashboard.button("g", "󱩾 Find text", ":Telescope live_grep <CR>"),
      dashboard.button("c", "󰣖 Config", ":e $MYVIMRC <CR>"),
      dashboard.button("s", "󰁯 Restore Session", ":SessionManager load_current_dir_session<CR>"),
      dashboard.button("l", "󰒲 Lazy", ":Lazy<CR>"),
      dashboard.button("m", "󱊍 Mason", ":Mason<CR>"),
      dashboard.button("q", " Quit", ":qa<CR>"),
    }
    for _, button in ipairs(dashboard.section.buttons.val) do
      button.opts.hl = "AlphaButtons"
      button.opts.hl_shortcut = "AlphaShortcut"
    end
    dashboard.section.footer.opts.hl = "Constant"
    dashboard.section.header.opts.hl = "AlphaHeader"
    dashboard.section.buttons.opts.hl = "AlphaButtons"
    dashboard.opts.layout[1].val = 0

    -- close Lazy and re-open when the dashboard is ready
    if vim.o.filetype == "lazy" then
      vim.cmd.close()
      vim.api.nvim_create_autocmd("User", {
        pattern = "AlphaReady",
        callback = function()
          require("lazy").show()
        end,
      })
    end

    require("alpha").setup(dashboard.opts)

    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyVimStarted",
      callback = function()
        local stats = require("lazy").stats()
        local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)

        local version = "   v"
            .. vim.version().major
            .. "."
            .. vim.version().minor
            .. "."
            .. vim.version().patch
        local plugins = "Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
        local footer = "\t" .. version .. "\t" .. plugins .. "\n"
        dashboard.section.footer.val = footer
        pcall(vim.cmd.AlphaRedraw)
      end,
    })
  end,
}
