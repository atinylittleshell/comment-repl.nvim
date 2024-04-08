vim.api.nvim_create_user_command("CommentREPLExecute", require("comment_repl.commands").execute, {})
vim.api.nvim_create_user_command("CommentREPLLog", require("comment_repl.commands").view_log, {})
