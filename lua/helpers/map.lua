local M = {}

local exists = function(key, mode)
  return vim.fn.maparg(key, mode) ~= ""
end

local keymap = function(mode, key, func, desc, opts)
  -- Extract overwrite from opts if present
  local overwrite = true
  if opts and opts.overwrite ~= nil then
    overwrite = opts.overwrite
  end

  if overwrite == false and exists(key, mode) then
    return nil
  end

  local options = { desc = desc, silent = true, noremap = true }
  if opts then
    local cleanOpts = vim.tbl_extend("force", {}, opts)
    cleanOpts.overwrite = nil
    options = vim.tbl_extend("force", options, cleanOpts)
  end
  return vim.keymap.set(mode, key, func, options)
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
        local callback, desc, itemOptions = unpack(v)
        -- Merge group options with individual keymap options
        local finalOptions = options
        if itemOptions then
          if finalOptions then
            finalOptions = vim.tbl_extend("force", finalOptions, itemOptions)
          else
            finalOptions = itemOptions
          end
        end
        table.insert(keys, {
          key = groupPrefix .. shortcut(k),
          callback = callback,
          desc = desc,
          mode = mode,
          options = finalOptions,
        })
      end
    end
  end

  return keys
end

M.t = function(inputTable, prefix)
  local keys = M.loop(inputTable, prefix)

  for _, keyData in ipairs(keys) do
    keymap(keyData.mode, keyData.key, keyData.callback, keyData.desc, keyData.options)
  end
end

M.lazy = function(inputTable, prefix)
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
