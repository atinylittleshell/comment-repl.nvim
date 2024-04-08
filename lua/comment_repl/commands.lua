local log = require("comment_repl.log")
local config = require("comment_repl.config")
local repl_manager = require("comment_repl.repl_manager")

---@class Commands
local M = {}

---@return nil
M.execute = function()
  local repl_config = config.repls[vim.bo.filetype]
  if not repl_config then
    log.fmt_error("No REPL configured for %s", vim.bo.filetype)
    vim.notify("No REPL configured for " .. vim.bo.filetype, vim.log.levels.ERROR)
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()
  repl_manager.start(bufnr, repl_config)
end

---@return nil
M.view_log = function()
  log.view_log()
end

return M
