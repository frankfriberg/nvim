return function(event)
  local map = function(keys, func, desc)
    vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
  end

  local telescope_ok, builtin = pcall(require, "telescope.builtin")

  if telescope_ok then
    map("gd", builtin.lsp_definitions, "[G]oto [D]efinition")
    map("gr", builtin.lsp_references, "[G]oto [R]eferences")
    map("gI", builtin.lsp_implementations, "[G]oto [I]mplementation")
    map("<leader>D", builtin.lsp_type_definitions, "Type [D]efinition")
    map("<leader>ds", builtin.lsp_document_symbols, "[D]ocument [S]ymbols")
    map("<leader>ws", builtin.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
  end

  map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
  map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
  map("K", vim.lsp.buf.hover, "Hover Documentation")
  map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

  local client = vim.lsp.get_client_by_id(event.data.client_id)
  if client and client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      buffer = event.buf,
      callback = vim.lsp.buf.document_highlight,
    })

    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      buffer = event.buf,
      callback = vim.lsp.buf.clear_references,
    })
  end

  if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
    map("<leader>th", function()
      vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled())
    end, "[T]oggle Inlay [H]ints")
  end
end
