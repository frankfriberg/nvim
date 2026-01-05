---@alias KeymapCallback string|function

---@class KeymapEntry
---@field [1] KeymapCallback Callback or command string
---@field mode? string|string[] Mode override for this specific keymap
---@field desc? string Description for which-key
---@field buffer? boolean|number Buffer-local mapping
---@field expr? boolean Treat RHS as expression
---@field silent? boolean Silent mapping (default: true)
---@field nowait? boolean Don't wait for more keys
---@field noremap? boolean Non-recursive mapping
---@field remap? boolean Allow recursive mapping
---@field unique? boolean Fail if mapping exists
---@field script? boolean Use script-local mapping
---@field replace_keycodes? boolean Replace keycodes in expr

---@class InputTable
---@field mode? string|string[] Mode for all keymaps (default: "n")
---@field group? [string, string, string?, string?] Which-key group: {key, name, icon, color}
---@field [string] KeymapEntry|InputTable Keymap entry or nested table
---
--- Parent-level options (cascade to all children):
---@field buffer? boolean|number Buffer-local for all keymaps
---@field expr? boolean Expression mode for all keymaps
---@field silent? boolean Silent for all keymaps
---@field nowait? boolean No wait for all keymaps
---@field noremap? boolean Non-recursive for all keymaps
---@field remap? boolean Recursive for all keymaps
---@field unique? boolean Unique for all keymaps
---@field script? boolean Script-local for all keymaps
---@field replace_keycodes? boolean Replace keycodes for all keymaps

---@class ProcessedKey
---@field key string The full key sequence
---@field callback KeymapCallback The callback or command
---@field mode string|string[] The mode(s) for this keymap
---@field options vim.keymap.set.Opts The options for vim.keymap.set

---@class LazyKey
---@field [1] string The key sequence
---@field [2] KeymapCallback The callback or command
---@field mode string|string[] The mode(s)
---@field desc? string Description
---@field buffer? boolean|number Buffer-local mapping
---@field expr? boolean Expression mapping
---@field silent? boolean Silent mapping
---@field nowait? boolean No wait
---@field noremap? boolean Non-recursive
---@field remap? boolean Recursive

local M = {}

-- Reserved keys that don't cascade as parent options
local RESERVED_KEYS = {
  mode = true,
  group = true,
}

---Helper function to set default silent = true
---@param mode string|string[] The mode(s)
---@param key string The key sequence
---@param func string|function The callback or command
---@param opts? vim.keymap.set.Opts Options for vim.keymap.set
---@return nil
local keymap = function(mode, key, func, opts)
  local options = opts or {}
  if options.silent == nil then
    options.silent = true
  end

  return vim.keymap.set(mode, key, func, options)
end

---Register a which-key group
---@param mode string|string[] The mode(s)
---@param key string The group key
---@param name string The group name
---@param icon? string The group icon
---@param color? string The icon color
---@return nil
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

---Expand keymap shortcuts (e.g., "l_q" -> "<leader>q", "c_s" -> "<C-s>")
---@param key string The shortcut key
---@return string The expanded key sequence
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

---Extract named parameters from a keymap table (excludes numeric keys)
---@param keymapTable table The keymap entry table
---@return table The extracted named parameters
local function extractNamedParams(keymapTable)
  local params = {}
  for key, value in pairs(keymapTable) do
    if type(key) ~= "number" then
      params[key] = value
    end
  end
  return params
end

---Extract parent-level options from input table
---@param inputTable InputTable The input table
---@param existingParentOptions? vim.keymap.set.Opts Existing parent options from outer scope
---@return vim.keymap.set.Opts The extracted and merged parent options
local function extractParentOptions(inputTable, existingParentOptions)
  local parentOptions = vim.tbl_extend("force", {}, existingParentOptions or {})

  for key, value in pairs(inputTable) do
    if type(key) == "string" and not RESERVED_KEYS[key] and type(value) ~= "table" then
      parentOptions[key] = value
    end
  end

  return parentOptions
end

---Recursively loop through keymap tables and build keymap entries
---@param inputTable InputTable The input table with keymaps
---@param prefix? string The prefix for group keys
---@param keyTable? ProcessedKey[] Accumulator for processed keys
---@param parentMode? string|string[] Mode inherited from parent
---@param parentOptions? vim.keymap.set.Opts Options inherited from parent
---@return ProcessedKey[] The processed keymap entries
M.loop = function(inputTable, prefix, keyTable, parentMode, parentOptions)
  local keys = keyTable or {}
  local mode = inputTable.mode or parentMode or "n"
  local groupPrefix = prefix or ""

  -- Extract parent-level options (cascade to children)
  local parentLevelOptions = extractParentOptions(inputTable, parentOptions)

  -- Handle which-key groups
  if inputTable.group then
    local groupKey, groupDesc, groupIcon, groupColor = unpack(inputTable.group)
    groupPrefix = groupKey
    M.group(mode, groupKey, groupDesc, groupIcon, groupColor)
  end

  -- Process each key in the input table
  for k, v in pairs(inputTable) do
    if not RESERVED_KEYS[k] and type(v) == "table" then
      -- Check if this is a nested table (not a keymap entry)
      if type(v[1]) ~= "string" and type(v[1]) ~= "function" then
        -- Recursively process nested table
        local nestedTable = M.loop(v, groupPrefix, keys, mode, parentLevelOptions)
        if nestedTable then
          keys = vim.list_extend(keys, nestedTable)
        end
      else
        -- This is a keymap entry: { callback, desc = "...", ... }
        local callback = v[1]
        local namedParams = extractNamedParams(v)

        -- Extract mode (child mode overrides parent mode)
        local itemMode = namedParams.mode or mode
        namedParams.mode = nil

        -- Merge parent options with child options (child wins)
        local finalOptions = vim.tbl_extend("force", {}, parentLevelOptions, namedParams)

        table.insert(keys, {
          key = groupPrefix .. shortcut(k),
          callback = callback,
          mode = itemMode,
          options = finalOptions,
        })
      end
    end
  end

  return keys
end

---Set keymaps immediately (for use in config files)
---
---Example:
---```lua
---map.t({
---  buffer = true,  -- Parent option (cascades to children)
---  l_s = { "<cmd>write<cr>", desc = "Save file" },
---  l_q = { "<cmd>quit<cr>", desc = "Quit" },
---})
---```
---@param inputTable InputTable The input table with keymaps
---@param prefix? string Optional prefix for group keys
---@return nil
M.t = function(inputTable, prefix)
  local keys = M.loop(inputTable, prefix)

  for _, keyData in ipairs(keys) do
    keymap(keyData.mode, keyData.key, keyData.callback, keyData.options)
  end
end

---Generate lazy.nvim-style keymap table (for use in plugin specs)
---
---Example:
---```lua
---return {
---  "some-plugin",
---  keys = map.lazy({
---    l_t = { "<cmd>Toggle<cr>", desc = "Toggle" },
---    l_f = { "<cmd>Find<cr>", desc = "Find" },
---  }),
---}
---```
---@param inputTable InputTable The input table with keymaps
---@param prefix? string Optional prefix for group keys
---@return LazyKey[] The lazy.nvim-style keymap table
M.lazy = function(inputTable, prefix)
  local keys = M.loop(inputTable, prefix)
  local lazyTable = {}

  for _, key in ipairs(keys) do
    -- Start with base structure: { key, callback, mode = mode }
    local lazyKey = {
      key.key,
      key.callback,
      mode = key.mode,
    }

    -- Spread options directly into lazy key table
    if key.options then
      for k, v in pairs(key.options) do
        lazyKey[k] = v
      end
    end

    table.insert(lazyTable, lazyKey)
  end

  return lazyTable
end

return M
