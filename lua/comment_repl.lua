local log = require("comment_repl.log")
local repl_manager = require("comment_repl.repl_manager")
local config = require("comment_repl.config")

---@class CommentREPL
local M = {}

---@param args Config?
M.setup = function(args)
  config = vim.tbl_deep_extend("force", config, args or {})

  log.new(config.log, true)
  log.fmt_info("Setting up comment-repl.nvim:\n%s", config)

  local autocmds = vim.api.nvim_create_augroup("CommentREPL", { clear = true })

  vim.api.nvim_create_autocmd("BufUnload", {
    group = autocmds,
    callback = function(ev)
      repl_manager.stop(ev.buf)
    end,
  })
end

return M
