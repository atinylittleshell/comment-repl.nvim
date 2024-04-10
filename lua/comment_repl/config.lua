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
    margin = {
      top = 2,
      bottom = 1,
    },
  },
  log = {
    level = "info",
  },
  repls = {
    python = {
      display = "Python",
      cmd = "python",
      args = { "-i" },
      cell_marker = "# %%",
      multi_line_comment_open = '"""',
      multi_line_comment_close = '"""',
    },
  },
}

return M
