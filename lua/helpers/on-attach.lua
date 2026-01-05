return function(event)
  local map = require("helpers.map")

  map.t({
    gD = { vim.lsp.buf.declaration, desc = "Goto Declaration", remap = false },
    gd = { "<C-]>", desc = "Goto Definition", remap = false },
    {
      group = { "<leader>l", "LSP" },
      k = { vim.lsp.buf.signature_help, desc = "Signature Help", remap = false },
      r = { vim.lsp.buf.rename, desc = "Rename File", remap = false },
      c = { vim.lsp.buf.code_action, desc = "Code Action", remap = false },
    },
  })

  if vim.fn.mapcheck("gr", "n") == "" then
    map.t({
      gr = { vim.lsp.buf.references, desc = "Goto References", remap = false },
    })
  end

  if vim.fn.mapcheck("gI", "n") == "" then
    map.t({
      gI = { vim.lsp.buf.implementation, desc = "Goto Implementations", remap = false },
    })
  end

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
        desc = "Toggle Inlay Hints",
      },
    })
  end

  map.t({
    l_lw = {
      function()
        require("workspace-diagnostics").populate_workspace_diagnostics(client, event.buf)
      end,
      desc = "Load Workspace Diagnostics",
    },
  })
end
