return {
  "famiu/bufdelete.nvim",
  config = function()
    local map = require("ff.map")
    local bd = require("bufdelete")

    map.t({
      l_q = { bd.bufdelete, "Delete buffer" },
      l_o = { function()
        local buffers = vim.api.nvim_list_bufs()
        for _, buf in ipairs(buffers) do
          if vim.api.nvim_buf_is_loaded(buf) then
            bd.bufdelete(buf)
          end
        end
      end, "Delete all buffers" },
    })
  end
}
