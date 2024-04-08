local log = require("comment_repl.log")

---@class LanguageConfig
---@field display string
---@field cmd string
---@field args table<string>

---@class REPLManager
local M = {}

---@class REPLInstance
---@field config LanguageConfig
---@field process uv_process_t
---@field stdin uv_pipe_t
---@field stdout uv_pipe_t
---@field stderr uv_pipe_t

---@type table<number, REPLInstance>
local buf_to_repl = {}

---@param bufnr number
---@param repl_config LanguageConfig
M.start = function(bufnr, repl_config)
  if buf_to_repl[bufnr] then
    log.fmt_warn("REPL already started for buffer %d", bufnr)
    return
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

  buf_to_repl[bufnr] = {
    config = repl_config,
    process = process,
    stdin = stdin,
    stdout = stdout,
    stderr = stderr,
  }

  log.fmt_info("%s REPL started for buffer %d", repl_config.display, bufnr)
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
