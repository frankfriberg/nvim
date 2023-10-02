local tb = require("telescope.builtin")
local map = require("ff.map")
local format = require("plugins.utils.format")

return function(client, bufnr)
  local lsp = vim.lsp.buf

  map.t({
    {
      options = { buffer = bufnr },
      gD = { lsp.declaration, "[LSP] Declaration" },
      K = { lsp.hover, "[LSP] Hover" },
      gr = { tb.lsp_references, "[LSP] References" },
      gd = { tb.lsp_definitions, "[LSP] Definitions" },
      gi = { tb.lsp_implementations, "[LSP] Goto Implementation" },
      c_s = { lsp.signature_help, "[LSP] Signature Help" },
    }
  })

  map.t({
    group = { "<leader>l", "LSP" },
    {
      options = { buffer = bufnr },
      s = { lsp.signature_help, "[LSP] Signature Help" },
      S = { tb.lsp_document_symbols, "[LSP] Document Symbols" },
      W = { tb.lsp_workspace_symbols, "[LSP] Workspace Symbols" },
      d = { tb.lsp_definitions, "[LSP] Definition" },
      D = { tb.lsp_type_definitions, "[LSP] Type Definition" },
      r = { lsp.rename, "[LSP] Rename" },
      c = { lsp.code_action, "[LSP] Code Actions" },
      f = { format.format, "[LSP] Format" },
    },
    {
      mode = "v",
      opts = { buffer = bufnr },
      f = { format.format, "[LSP] Format" },
    }
  })

  vim.api.nvim_create_autocmd("CursorHold", {
    buffer = bufnr,
    callback = function()
      local opts = {
        focusable = false,
        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
        source = false,
        scope = "cursor",
        header = "",
        format = function(diagnostic)
          return string.format(
            "%s [%s]",
            diagnostic.message,
            diagnostic.source
          )
        end,
      }
      vim.diagnostic.open_float(nil, opts)
    end,
  })
end
