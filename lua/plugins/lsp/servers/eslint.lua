return {
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
  }
}
