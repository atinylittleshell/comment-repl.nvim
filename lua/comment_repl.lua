local commands = require("comment_repl.commands")

---@class Config
local config = {}

---@class CommentREPL
local M = {}

---@type Config
M.config = config

---@param args Config?
M.setup = function(args)
  M.config = vim.tbl_deep_extend("force", M.config, args or {})
end

M.execute = function()
  return commands.execute()
end

return M
