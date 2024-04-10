local log = require("comment_repl.log")
local config = require("comment_repl.config")

---@class CommentREPLCore
local M = {}

---@type number
M.comment_repl_extmark_ns = vim.api.nvim_create_namespace("comment_repl_extmark")

---@param repl_config LanguageConfig
---@return table<number, number> "One-indexed { first_line, last_line }"
M.get_cell_at_cursor = function(repl_config)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local bufnr = vim.api.nvim_get_current_buf()
  local cell_first_line = cursor[1]
  local cell_last_line = cursor[1]

  while
    cell_first_line > 1
    and vim.api.nvim_buf_get_lines(bufnr, cell_first_line - 1, cell_first_line, false)[1]
      ~= repl_config.cell_marker
  do
    cell_first_line = cell_first_line - 1
  end

  local line_count = vim.api.nvim_buf_line_count(bufnr)
  while
    cell_last_line < line_count
    and vim.api.nvim_buf_get_lines(bufnr, cell_last_line, cell_last_line + 1, false)[1]
      ~= repl_config.cell_marker
  do
    cell_last_line = cell_last_line + 1
  end

  return { cell_first_line, cell_last_line }
end

---@param bufnr number
---@param cell table<number, number>
---@param repl_config LanguageConfig
---@return table<number, number>|nil "One-indexed { first_line, last_line }"
M.get_trailing_comment_block_in_cell = function(bufnr, cell, repl_config)
  local cell_first_line, cell_last_line = cell[1], cell[2]
  log.fmt_trace(
    "get_trailing_comment_block_in_cell: cell_first_line=%d, cell_last_line=%d",
    cell_first_line,
    cell_last_line
  )

  local trailing_comment_block = { 0, 0 }
  local in_comment_block = false
  local lines = vim.api.nvim_buf_get_lines(bufnr, cell_first_line - 1, cell_last_line, false)

  for i = cell_first_line, cell_last_line do
    local line = lines[i - cell_first_line + 1]
    if in_comment_block then
      if line == repl_config.multi_line_comment_close then
        in_comment_block = false
      end
      trailing_comment_block[2] = i
    elseif line == repl_config.multi_line_comment_open then
      in_comment_block = true
      trailing_comment_block[1] = i
      trailing_comment_block[2] = i
    elseif line:len() > 0 then
      trailing_comment_block[1] = 0
      trailing_comment_block[2] = 0
    end
  end

  if trailing_comment_block[1] == 0 then
    return nil
  end

  return trailing_comment_block
end

---@param bufnr number
---@param cell table<number, number>
---@param repl_config LanguageConfig
---@return table<number, number> "One-indexed { first_line, last_line}"
M.create_trailing_comment_block_in_cell = function(bufnr, cell, repl_config)
  local cell_last_line = cell[2]
  vim.api.nvim_buf_set_lines(bufnr, cell_last_line, cell_last_line, false, {
    repl_config.multi_line_comment_open,
    "",
    repl_config.multi_line_comment_close,
  })

  return { cell_last_line + 1, cell_last_line + 3 }
end

---@param bufnr number
---@param trailing_comment_block table<number, number>
---@param repl_config LanguageConfig
---@return table<number, number> "One-indexed { first_line, last_line }"
M.clean_trailing_comment_block = function(bufnr, trailing_comment_block, repl_config)
  local trailing_comment_block_first_line, trailing_comment_block_last_line =
    trailing_comment_block[1], trailing_comment_block[2]
  vim.api.nvim_buf_set_lines(
    bufnr,
    trailing_comment_block_first_line - 1,
    trailing_comment_block_last_line,
    false,
    {
      repl_config.multi_line_comment_open,
      "",
      repl_config.multi_line_comment_close,
    }
  )

  return { trailing_comment_block_first_line, trailing_comment_block_first_line + 2 }
end

---@param bufnr number
---@param comment_block table<number, number>
---@return table<number, number> "One-indexed { first_line, last_line }"
M.ensure_margin_around_comment_block = function(bufnr, comment_block)
  local remaining_top_margin = config.output.margin.top
  local remaining_bottom_margin = config.output.margin.bottom

  local top_cursor = comment_block[1] - 1
  while
    top_cursor > 0
    and vim.api.nvim_buf_get_lines(bufnr, top_cursor - 1, top_cursor, false)[1] == ""
  do
    remaining_top_margin = remaining_top_margin - 1
    top_cursor = top_cursor - 1
  end

  while remaining_top_margin > 0 do
    vim.api.nvim_buf_set_lines(bufnr, comment_block[1] - 1, comment_block[1] - 1, false, { "" })
    comment_block[1] = comment_block[1] + 1
    comment_block[2] = comment_block[2] + 1
    remaining_top_margin = remaining_top_margin - 1
  end

  local bottom_cursor = comment_block[2] + 1
  local line_count = vim.api.nvim_buf_line_count(bufnr)
  while
    bottom_cursor <= line_count
    and vim.api.nvim_buf_get_lines(bufnr, bottom_cursor - 1, bottom_cursor, false)[1] == ""
  do
    remaining_bottom_margin = remaining_bottom_margin - 1
    bottom_cursor = bottom_cursor + 1
  end

  while remaining_bottom_margin > 0 do
    vim.api.nvim_buf_set_lines(bufnr, comment_block[2], comment_block[2], false, { "" })
    remaining_bottom_margin = remaining_bottom_margin - 1
  end

  return comment_block
end

return M
