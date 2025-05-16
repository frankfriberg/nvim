vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function(args)
    local client = vim.lsp.get_clients({ name = "eslint" })
    if not client then
      return
    end

    local success, err = pcall(function()
      vim.cmd("LspEslintFixAll")
    end)
    if not success then
      vim.notify("ESLint fix failed: " .. tostring(err), vim.log.levels.ERROR)
    end
  end,
})

return {
  settings = {
    format = {
      enable = true,
    },
  },
  handlers = {
    ["window/showMessageRequest"] = function(ctx, result)
      if result.message:find("ENOENT") then
        return vim.NIL
      end

      return vim.lsp.handlers["window/showMessageRequest"](nil, result, ctx)
    end,
  },
}
