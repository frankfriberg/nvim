return function(event)
  local map = require("helpers.map")

  map.t({
    gD = { vim.lsp.buf.declaration, "[G]oto [D]eclaration", false },
    gd = { "<C-]>", "Goto Definition", false },
    gr = { vim.lsp.buf.references, "Goto References", false },
    gI = { vim.lsp.buf.implementation, "Goto Implementations", false },
    {
      group = { "<leader>l", "LSP" },
      k = { vim.lsp.buf.signature_help, "Signature Help", false },
      r = { vim.lsp.buf.rename, "[R]e[n]ame", false },
      c = { vim.lsp.buf.code_action, "[C]ode Action", false },
    },
  })

  local client = vim.lsp.get_client_by_id(event.data.client_id)
  if not client then
    return
  end
  local methods = vim.lsp.protocol.Methods

  if client:supports_method(methods.textDocument_documentHighlight) then
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      buffer = event.buf,
      callback = vim.lsp.buf.document_highlight,
    })

    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      buffer = event.buf,
      callback = vim.lsp.buf.clear_references,
    })
  end

  if client:supports_method(methods.textDocument_inlayHint) then
    map.n("<leader>lt", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }))
    end, "[T]oggle Inlay [H]ints")
  end
end
