local M = {}

M.diagnostics = {
  HINT = "󰘥",
  INFO = "󱨧",
  WARN = "󰗖",
  ERROR = "󰅚",
}

M.symbol_kinds = {
  Array = "󰅪 ",
  Object = "󰅩 ",
  Text = " ",
  Method = " ",
  Function = "󰊕 ",
  Constructor = "󰢻 ",
  Package = ' ',
  Field = " ",
  Variable = " ",
  Class = " ",
  Interface = " ",
  Module = " ",
  Property = "󰌖 ",
  Unit = "󰑭 ",
  Value = "󱔁 ",
  Number = " ",
  Enum = " ",
  Keyword = "󰿦 ",
  Snippet = "󰅨 ",
  Color = "󰸌 ",
  File = "󰧮 ",
  Reference = " ",
  Folder = "󰉖 ",
  EnumMember = "󰖽 ",
  Constant = " ",
  Struct = " ",
  Event = " ",
  Operator = "󱓉 ",
  TypeParameter = "󱄽 ",
  Null = " ",
  Boolean = ' ',
  Key = ' ',
  Copilot = " ",
}

M.git = {
  ahead = "󰳢",
  behind = "󰳜",
  added = "󰯫",
  untracked = "󰰧",
  deleted = "󰯴",
  modified = "󰰏",
  conflict = "󰯱",
}

M.custom = {
  spellcheck_enabled = "󰸥 ",
  spellcheck_disabled = "󰸦 ",
  format_enabled = " ",
  format_disabled = "󰐙 ",
  linting_enabled = "󰓏",
  linting_disabled = "󰦤"
}

M.spinners = {
  hourglass = { "󰚭", "󰔟", "󱦟", "󱦠" },
  circle = { "󰝦", "󰪞", "󰪟", "󰪡", "󰪢", "󰪣", "󰪤", "󰪥" },
  clock_outline = { "󱑖", "󱑋", "󱑌", "󱑍", "󱑎", "󱑏", "󱑐", "󱑑", "󱑒", "󱑓", "󱑔", "󱑕" },
  clock_filled = { "󱑊", "󱐿", "󱑀", "󱑁", "󱑂", "󱑃", "󱑄", "󱑅", "󱑆", "󱑇", "󱑈", "󱑉" },
}

return M
