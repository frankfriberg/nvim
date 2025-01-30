local M = {}

local exists = function(key, mode)
  local exists = (vim.fn.maparg(key, mode) ~= "")

  if exists then
    return true
  else
    return false
  end
end

local keymap = function(mode, key, func, desc, overwrite, opts)
  if overwrite == false and exists(key, mode) then
    return nil
  end

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

M.group = function(mode, key, desc, icon, color)
  local ok, wk = pcall(require, "which-key")

  if ok then
    wk.add({
      mode = mode,
      {
        key,
        name = desc,
        icon = { icon = icon, color = color },
      },
    })
  end
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

M.t = function(inputTable, prefix)
  local mode = inputTable.mode or "n"
  local options = inputTable.options or inputTable.opts or nil
  local groupPrefix = prefix or ""

  if inputTable.group then
    local groupKey, groupDesc, groupIcon, groupColor = unpack(inputTable.group)
    groupPrefix = groupKey
    M.group(mode, groupKey, groupDesc, groupIcon, groupColor)
  end

  for k, v in pairs(inputTable) do
    if k ~= "mode" and k ~= "group" and k ~= "options" and k ~= "opts" then
      if type(v[1]) ~= "string" and type(v[1]) ~= "function" then
        M.t(v, groupPrefix)
      else
        local callback, desc, overwrite = unpack(v)
        keymap(mode, groupPrefix .. shortcut(k), callback, desc, overwrite, options)
      end
    end
  end
end

return M
