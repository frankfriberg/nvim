local diagnostic_icons = require("plugins.ui.icons").diagnostics

-- Diagnostic configuration.
vim.diagnostic.config {
  float = {
    border = 'rounded',
    source = 'if_many',
    header = false,
    scope = "cursor",
    prefix = " ",
    suffix = " ",
    focusable = false,
    close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
  },
  update_in_insert = true,
  signs = false,
  severity_sort = true,
}

for severity, icon in pairs(diagnostic_icons) do
  local hl = 'DiagnosticSign' .. severity:sub(1, 1) .. severity:sub(2):lower()
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

local md_namespace = vim.api.nvim_create_namespace('lsp_float')

---LSP handler that adds extra inline highlights, keymaps, and window options.
---Code inspired from `noice`.
---@param handler fun(err: any, result: any, ctx: any, config: any): integer, integer
---@return function
local function enhanced_float_handler(handler)
  return function(err, result, ctx, config)
    local buf, win = handler(
      err,
      result,
      ctx,
      vim.tbl_deep_extend('force', config or {}, {
        border = 'rounded',
        max_height = math.floor(vim.o.lines * 0.5),
        max_width = math.floor(vim.o.columns * 0.4),
      })
    )

    if not buf or not win then
      return
    end

    -- Conceal everything.
    vim.wo[win].concealcursor = 'n'

    -- Extra highlights.
    for l, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
      for pattern, hl_group in pairs {
        ['|%S-|'] = '@text.reference',
        ['@%S+'] = '@parameter',
        ['^%s*(Parameters:)'] = '@text.title',
        ['^%s*(Return:)'] = '@text.title',
        ['^%s*(See also:)'] = '@text.title',
        ['{%S-}'] = '@parameter',
      } do
        local from = 1 ---@type integer?
        while from do
          local to
          from, to = line:find(pattern, from)
          if from then
            vim.api.nvim_buf_set_extmark(buf, md_namespace, l - 1, from - 1, {
              end_col = to,
              hl_group = hl_group,
            })
          end
          from = to and to + 1 or nil
        end
      end
    end

    -- Add keymaps for opening links.
    if not vim.b[buf].markdown_keys then
      vim.keymap.set('n', 'K', function()
        -- Vim help links.
        local url = (vim.fn.expand '<cWORD>' --[[@as string]]):match '|(%S-)|'
        if url then
          return vim.cmd.help(url)
        end

        -- Markdown links.
        local col = vim.api.nvim_win_get_cursor(0)[2] + 1
        local from, to
        from, to, url = vim.api.nvim_get_current_line():find '%[.-%]%((%S-)%)'
        if from and col >= from and col <= to then
          vim.system({ 'open', url }, nil, function(res)
            if res.code ~= 0 then
              vim.notify('Failed to open URL' .. url, vim.log.levels.ERROR)
            end
          end)
        end
      end, { buffer = buf, silent = true })
      vim.b[buf].markdown_keys = true
    end
  end
end

vim.lsp.handlers["textDocument/hover"] = enhanced_float_handler(vim.lsp.handlers.hover)
vim.lsp.handlers["textDocument/signatureHelp"] = enhanced_float_handler(vim.lsp.handlers.signature_help)

return {
  "williamboman/mason.nvim",
  event = "BufReadPre",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
    "hrsh7th/cmp-nvim-lsp",
    "jose-elias-alvarez/typescript.nvim",
    "folke/neodev.nvim",
    "b0o/schemastore.nvim",
    {
      "pmizio/typescript-tools.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
    }
  },
  opts = {
    autoformat = true,
  },
  config = function(_, opts)
    local on_attach = require("plugins.lsp.on-attach")
    local servers = {
      "lua_ls",
      "tsserver",
      "tailwindcss",
      "bashls",
      "jsonls",
      "html",
      "taplo",
      "marksman",
    }

    require("plugins.utils.format").setup(opts)

    vim.lsp.handlers["textDocument/publishDiagnostics"] =
        vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, { update_in_insert = false })

    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = servers,
      automatic_installation = true,
    })

    local cmp = require("cmp_nvim_lsp")

    local capabilities = cmp.default_capabilities() or vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true

    require("mason-lspconfig").setup_handlers({
      function(server_name)
        require("lspconfig")[server_name].setup({ on_attach, capabilities })
      end,
      ["tsserver"] = function()
        require("plugins.lsp.typescript-tools").setup(on_attach, capabilities)
      end,
      ["lua_ls"] = function()
        require("plugins.lsp.lua_ls").setup(on_attach, capabilities)
      end,
      ["jsonls"] = function()
        require("plugins.lsp.jsonls").setup(on_attach, capabilities)
      end,
      ["html"] = function()
        require("plugins.lsp.html").setup(on_attach, capabilities)
      end,
      ["bashls"] = function()
        require("lspconfig").bashls.setup({
          filetypes = { "sh", "bash", "zsh" },
          on_attach,
          capabilities,
        })
      end,
      ["tailwindcss"] = function()
        require("lspconfig").tailwindcss.setup({
          filetypes = { "html", "markdown", "css", "scss", "javascript", "javascriptreact", "typescript",
            "typescriptreact", "vue", "svelte" },
          on_attach,
          capabilities
        })
      end,
      ["volar"] = function()
        require("plugins.lsp.vue").volar(on_attach, capabilities)
      end,
      ["vuels"] = function()
        require("plugins.lsp.vue").vuels(on_attach, capabilities)
      end
    })
  end,
}
