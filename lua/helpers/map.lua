local M = {}

local keymap = function(mode, key, func, desc, opts)
  local options = { desc = desc, silent = true, noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  return vim.keymap.set(mode, key, func, options)
end

M.n = function(key, func, desc, opts)
  return keymap("n", key, func, desc, opts)
end

M.v = function(key, func, desc, opts)
  return keymap("v", key, func, desc, opts)
end

M.i = function(key, func, desc, opts)
  return keymap("i", key, func, desc, opts)
end

M.nv = function(key, func, desc, opts)
  return keymap({ "n", "v" }, key, func, desc, opts)
end

local group = function(mode, key, desc)
  local ok, wk = pcall(require, "which-key")

  if ok then
    wk.add({
      mode = mode,
      { key, name = desc },
    })
  end
end

M.ng = function(key, desc)
  return group("n", key, desc)
end

M.vg = function(key, desc)
  return group("v", key, desc)
end

M.nvg = function(key, desc)
  return group({ "n", "v" }, key, desc)
end

local shortcut = function(key)
  local shorts = {
    a_ = "<A-",
    c_ = "<C-",
    d_ = "<D-",
    m_ = "<M-",
    s_ = "<S-",
    l_ = "<leader>",
    t_ = "<tab>",
  }

  if key == "esc" then
    return "<esc>"
  end

  local prefix = key:sub(1, 2)
  local remainingKey = key:sub(3)

  if shorts[prefix] then
    if prefix == "l_" or prefix == "t_" then
      return shorts[prefix] .. remainingKey
    else
      return shorts[prefix] .. remainingKey .. ">"
    end
  end

  return key
end

M.t = function(input, prefix)
  local mode = "n"
  local options = nil

  prefix = prefix or ""

  if input.mode then
    mode = input.mode
  end

  if input.options or input.opts then
    options = input.options or input.opts
  end

  if input.group then
    prefix = (prefix and prefix .. input.group[1]) or ""
    group(mode, input.group[1], input.group[2])
  end

  for k, v in pairs(input) do
    if k ~= "mode" and k ~= "group" and k ~= "options" and k ~= "opts" then
      if type(v[1]) ~= "string" and type(v[1]) ~= "function" then
        M.t(v, prefix)
      else
        keymap(mode, prefix .. shortcut(k), v[1], v[2], options)
      end
    end
  end
end

return M
