---@class Config
---@field repls table<string, LanguageConfig>
local M = {
  repls = {
    python = {
      display = "Python",
      cmd = "python",
      args = { "-i" },
    },
  },
}

return M
