local M = {}

local exists = function(key, mode)
  local exists = (vim.fn.maparg(key, mode) ~= "")

  if exists then
    return true
  else
    return false
  end
end

local keymap = function(mode, key, func, desc, opts, overwrite)
  if overwrite == false and exists(key, mode) then
    return nil
  end

  local options = { desc = desc, silent = true, noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  return vim.keymap.set(mode, key, func, options)
end

M.n = function(key, func, desc, opts, overwrite)
  return keymap("n", key, func, desc, opts, overwrite)
end

M.v = function(key, func, desc, opts, overwrite)
  return keymap("v", key, func, desc, opts, overwrite)
end

M.i = function(key, func, desc, opts, overwrite)
  return keymap("i", key, func, desc, opts, overwrite)
end

M.nv = function(key, func, desc, opts, overwrite)
  return keymap({ "n", "v" }, key, func, desc, opts, overwrite)
end

M.group = function(mode, key, name, icon, color)
  local ok, wk = pcall(require, "which-key")

  if ok then
    wk.add({
      mode = mode,
      {
        key,
        group = name,
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

M.loop = function(inputTable, prefix, keyTable, parentMode)
  local keys = keyTable or {}
  local mode = inputTable.mode or parentMode or "n"
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
        local nestedTable = M.loop(v, groupPrefix, keys, mode)
        if nestedTable then
          keys = vim.list_extend(keys, nestedTable)
        end
      else
        local callback, desc, overwrite = unpack(v)
        table.insert(keys, {
          key = groupPrefix .. shortcut(k),
          callback = callback,
          desc = desc,
          mode = mode,
          options = options,
          overwrite = overwrite,
        })
      end
    end
  end

  return keys
end

M.t = function(inputTable, prefix)
  local keys = M.loop(inputTable, prefix)

  for _, keyData in ipairs(keys) do
    keymap(keyData.mode, keyData.key, keyData.callback, keyData.desc, keyData.options, keyData.overwrite)
  end
end

M.l = function(inputTable, prefix)
  local keys = M.loop(inputTable, prefix)
  local lazyTable = {}
  for _, keyData in ipairs(keys) do
    table.insert(lazyTable, {
      keyData.key,
      keyData.callback,
      desc = keyData.desc,
      mode = keyData.mode,
    })
  end

  return lazyTable
end

return M
