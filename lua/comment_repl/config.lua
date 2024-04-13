---@class LogConfig
---@field level "trace"|"debug"|"info"|"warn"|"error"|"fatal"?

---@class LineMarginConfig
---@field top number?
---@field bottom number?

---@class OutputConfig
---@field margin LineMarginConfig?

---@class Config
---@field output OutputConfig?
---@field log LogConfig?
---@field repls table<string, LanguageConfig>?
local M = {
  output = {
    -- Margin around the output comment
    margin = {
      top = 2,
      bottom = 1,
    },
  },
  log = {
    level = "info",
  },
  repls = {
    -- Python is supported by default
    python = {
      display = "Python",
      cmd = "python",
      args = { "-i" },
      -- The marker is what separates code cells
      cell_marker = "# %%",
      multi_line_comment_open = '"""',
      multi_line_comment_close = '"""',
    },
    -- Add your own repl configurations below.
    -- Use filetype as the key.
  },
}

return M
