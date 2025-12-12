return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(event)
        local bufnr = event.buf
        local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })

        -- Skip if no filetype
        if filetype == "" then
          return
        end

        -- Don't load treesitter for .env files even if detected as 'sh'
        local filename = vim.api.nvim_buf_get_name(bufnr)
        if filename:match("%.env") or filename:match("/%.env") then
          return
        end

        -- Get parser name based on filetype
        local parser_name = vim.treesitter.language.get_lang(filetype)
        if not parser_name then
          return
        end

        -- Try to get existing parser (helpful check if filetype was returned above)
        local parser_configs = require("nvim-treesitter.parsers")
        if not parser_configs[parser_name] then
          return -- Parser not available, skip silently
        end

        local parser_installed = pcall(vim.treesitter.get_parser, bufnr, parser_name)

        if not parser_installed then
          vim.notify("Installing treesitter parser for " .. parser_name, vim.log.levels.INFO, { icon = "" })

          -- If not installed, install parser synchronously
          require("nvim-treesitter").install({ parser_name }):wait(30000)
        end

        -- let's check again
        parser_installed = pcall(vim.treesitter.get_parser, bufnr, parser_name)

        if parser_installed then
          -- Start treesitter for this buffer
          vim.treesitter.start(bufnr, parser_name)
          vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
