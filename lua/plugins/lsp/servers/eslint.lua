return {
  on_attach = function(_, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "EslintFixAll",
    })
  end,
  settings = {
    format = {
      enable = false,
    },
  },
  handlers = {
    ["window/showMessageRequest"] = function(_, result)
      if result.message:find("ENOENT") then
        return vim.NIL
      end

      return vim.lsp.handlers["window/showMessageRequest"](nil, result)
    end,
  },
}
