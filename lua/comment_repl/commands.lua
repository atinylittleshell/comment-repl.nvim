local core = require("comment_repl.core")
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
  local repl = repl_manager.start(bufnr, repl_config)
  if not repl then
    log.fmt_error("Failed to start REPL for %s", vim.bo.filetype)
    vim.notify("Failed to start REPL for " .. vim.bo.filetype, vim.log.levels.ERROR)
    return
  end

  local cell = core.get_cell_at_cursor(repl_config)
  local repl_output_comment_block =
    core.get_trailing_comment_block_in_cell(bufnr, cell, repl_config)
  if repl_output_comment_block then
    repl_output_comment_block =
      core.clean_trailing_comment_block(bufnr, repl_output_comment_block, repl_config)
  else
    repl_output_comment_block = core.create_trailing_comment_block_in_cell(bufnr, cell, repl_config)
  end
  repl_output_comment_block =
    core.ensure_margin_around_comment_block(bufnr, repl_output_comment_block)

  repl.output_cursor = { repl_output_comment_block[1] + 1, 0 }

  local code_lines =
    vim.api.nvim_buf_get_lines(bufnr, cell[1] - 1, repl_output_comment_block[1] - 1, false)
  log.fmt_trace("Executing code:\n%s", code_lines)
  for i = 1, #code_lines do
    local line = code_lines[i]
    vim.loop.write(repl.stdin, line .. "\n")
  end
end

---@return nil
M.view_log = function()
  log.view_log()
end

return M
