return function(event)
  local map = require("helpers.map")

  local telescope_ok, builtin = pcall(require, "telescope.builtin")

  if telescope_ok then
    map.t({
      gd = { builtin.lsp_definitions, "[G]oto [D]efinition" },
      gr = { builtin.lsp_references, "[G]oto [R]eferences" },
      gI = { builtin.lsp_implementations, "[G]oto [I]mplementation" },
      l_D = { builtin.lsp_type_definitions, "Type [D]efinition" },
      l_ds = { builtin.lsp_document_symbols, "[D]ocument [S]ymbols" },
      l_ws = { builtin.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols" },
    })
  end

  map.t({
    K = { vim.lsp.buf.hover, "Hover Documentation" },
    gD = { vim.lsp.buf.declaration, "[G]oto [D]eclaration" },
    {
      group = { "<leader>l", "LSP" },
      k = { vim.lsp.buf.signature_help, "Signature Help" },
      r = { vim.lsp.buf.rename, "[R]e[n]ame" },
      c = { vim.lsp.buf.code_action, "[C]ode Action" },
    },
  })

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
    map.n("<leader>lt", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    end, "[T]oggle Inlay [H]ints")
  end
end
