return function(event)
  local map = require("helpers.map")

  map.t({
    gD = { vim.lsp.buf.declaration, "Goto Declaration", { overwrite = false } },
    gd = { "<C-]>", "Goto Definition", { overwrite = false } },
    gr = { vim.lsp.buf.references, "Goto References", { overwrite = false } },
    gI = { vim.lsp.buf.implementation, "Goto Implementations", { overwrite = false } },
    {
      group = { "<leader>l", "LSP" },
      k = { vim.lsp.buf.signature_help, "Signature Help", { overwrite = false } },
      r = { vim.lsp.buf.rename, "Rename File", { overwrite = false } },
      c = { vim.lsp.buf.code_action, "Code Action", { overwrite = false } },
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
    map.t({
      l_lt = {
        function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }))
        end,
        "Toggle Inlay Hints",
      },
    })
  end

  map.t({
    l_lw = {
      function()
        require("workspace-diagnostics").populate_workspace_diagnostics(client, event.buf)
      end,
      "Load Workspace Diagnostics",
    },
  })
end
