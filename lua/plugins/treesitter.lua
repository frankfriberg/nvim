return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local ts = require("nvim-treesitter")

    local waiting_buffers = {}
    local installing_langs = {}

    local group = vim.api.nvim_create_augroup("TreesitterSetup", { clear = true })

    local function enable_treesitter(buf, lang)
      if not vim.api.nvim_buf_is_valid(buf) then
        return false
      end

      local ok = pcall(vim.treesitter.start, buf, lang)
      if ok then
        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
      return ok
    end

    vim.api.nvim_create_autocmd("User", {
      group = group,
      pattern = "LazyDone",
      once = true,
      desc = "Install core treesitter parsers",
      callback = function()
        ts.install({
          "bash",
          "lua",
          "luadoc",
          "markdown",
          "markdown_inline",
          "regex",
          "vim",
          "vimdoc",
        }, {
          max_jobs = 8,
        })
      end,
    })

    local ignore_filetypes = {
      "fzf",
      "checkhealth",
      "lazy",
      "mason",
      "opencode_terminal",
      "qf",
      "minifiles",
      "confir",
    }

    local ignore_patterns = {
      "^blink%-",
      "^snacks_",
    }

    local function should_ignore_filetype(ft)
      for _, ignored in ipairs(ignore_filetypes) do
        if ft == ignored then
          return true
        end
      end
      for _, pattern in ipairs(ignore_patterns) do
        if ft:match(pattern) then
          return true
        end
      end
      return false
    end

    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      desc = "Enable treesitter highlighting and indentation",
      callback = function(event)
        if should_ignore_filetype(event.match) then
          return
        end

        local lang = vim.treesitter.language.get_lang(event.match) or event.match
        local buf = event.buf

        if not enable_treesitter(buf, lang) then
          waiting_buffers[lang] = waiting_buffers[lang] or {}
          waiting_buffers[lang][buf] = true

          if not installing_langs[lang] then
            installing_langs[lang] = true
            local task = ts.install({ lang })

            if task and task.await then
              task:await(function()
                vim.schedule(function()
                  installing_langs[lang] = nil

                  local buffers = waiting_buffers[lang]
                  if buffers then
                    for b in pairs(buffers) do
                      enable_treesitter(b, lang)
                    end
                    waiting_buffers[lang] = nil
                  end
                end)
              end)
            else
              installing_langs[lang] = nil
              waiting_buffers[lang] = nil
            end
          end
        end
      end,
    })

    vim.api.nvim_create_autocmd("BufDelete", {
      group = group,
      desc = "Clean up treesitter waiting buffers",
      callback = function(event)
        for lang, buffers in pairs(waiting_buffers) do
          buffers[event.buf] = nil
          if next(buffers) == nil then
            waiting_buffers[lang] = nil
          end
        end
      end,
    })
  end,
}
