local log = require("comment_repl.log")

---@class LanguageConfig
---@field display string
---@field cmd string
---@field args table<string>
---@field cell_marker string
---@field multi_line_comment_open string
---@field multi_line_comment_close string

---@class REPLManager
local M = {}

---@class REPLInstance
---@field bufnr number
---@field output_cursor table<number, number>|nil
---@field config LanguageConfig
---@field process uv_process_t
---@field stdin uv_pipe_t
---@field stdout uv_pipe_t
---@field stderr uv_pipe_t

---@type table<number, REPLInstance>
local buf_to_repl = {}

---@param bufnr number
---@param repl_config LanguageConfig
---@return REPLInstance|nil
M.start = function(bufnr, repl_config)
  local instance = buf_to_repl[bufnr]
  if instance then
    return instance
  end

  local stdin = vim.loop.new_pipe(false)
  local stdout = vim.loop.new_pipe(false)
  local stderr = vim.loop.new_pipe(false)
  local process = vim.loop.spawn(repl_config.cmd, {
    args = repl_config.args,
    stdio = { stdin, stdout, stderr },
  }, function()
    stdin:close()
    stdout:close()
    stderr:close()
    buf_to_repl[bufnr] = nil
  end)

  assert(process)
  log.fmt_info("%s REPL started for buffer %d", repl_config.display, bufnr)

  instance = {
    bufnr = bufnr,
    output_cursor = nil,
    config = repl_config,
    process = process,
    stdin = stdin,
    stdout = stdout,
    stderr = stderr,
  }
  buf_to_repl[bufnr] = instance

  stdout:read_start(function(_, data)
    log.fmt_trace("%s REPL received output: %s", repl_config.display, data)
    if data and instance.output_cursor then
      local line = instance.output_cursor[1]
      local col = instance.output_cursor[2]
      vim.api.nvim_buf_set_text(bufnr, line - 1, col, line - 1, col, { data })
    end
  end)

  return instance
end

---@param bufnr number
M.stop = function(bufnr)
  if buf_to_repl[bufnr] then
    buf_to_repl[bufnr].process:kill("sigterm")
    buf_to_repl[bufnr] = nil

    log.fmt_info("REPL stopped for buffer %d", bufnr)
  else
    log.fmt_debug("Can't stop REPL because it's not started for buffer %d", bufnr)
  end
end

return M
