return function(event)
  local map = require("helpers.map")

  local fzf_ok, fzf = pcall(require, "fzf-lua")

  if fzf_ok then
    map.t({
      gd = {
        function()
          fzf.lsp_definitions({ jump_to_single_result = true })
        end,
        "[G]oto [D]efinition",
      },
      gr = {
        function()
          fzf.lsp_references({ jump_to_single_result = true, ignore_current_line = true })
        end,
        "[G]oto [R]eferences",
      },
      gI = { fzf.lsp_implementations, "[G]oto [I]mplementation" },
    })
  end

  map.t({
    gD = { vim.lsp.buf.declaration, "[G]oto [D]eclaration" },
    {
      group = { "<leader>l", "LSP" },
      k = { vim.lsp.buf.signature_help, "Signature Help" },
      r = { vim.lsp.buf.rename, "[R]e[n]ame" },
      c = { vim.lsp.buf.code_action, "[C]ode Action" },
    },
  })

  local client = vim.lsp.get_client_by_id(event.data.client_id)
  local methods = vim.lsp.protocol.Methods
  if client and client.supports_method(methods.textDocument_documentHighlight) then
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      buffer = event.buf,
      callback = vim.lsp.buf.document_highlight,
    })

    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      buffer = event.buf,
      callback = vim.lsp.buf.clear_references,
    })
  end

  if client and client.supports_method(methods.textDocument_inlayHint) then
    map.n("<leader>lt", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }))
    end, "[T]oggle Inlay [H]ints")
  end
end
