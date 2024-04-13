# Comment-REPL.nvim

![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/atinylittleshell/comment-repl.nvim/lint_test.yml?branch=main&style=for-the-badge)
![Lua](https://img.shields.io/badge/Made%20with%20Lua-blueviolet.svg?style=for-the-badge&logo=lua)

Execute code directly from your buffer and print the output as a comment.

## How does it work

[Screenshot](doc/screenshot.png?raw=true)

## Installation

Using lazy.nvim:

```lua
{
  'atinylittleshell/comment-repl.nvim',
  opts = {},
}
```

## Configuration

See [config.lua](lua/comment-repl/config.lua) for config schema and default values.

## Commands

`:CommentREPLExecute` - Execute the code cell at the cursor and print the output as a comment.

`:CommentREPLLog` - View logs from Comment-REPL.nvim.

```lua
-- By default the plugin will not enable any key bindings.
-- Your can define your own keybind behavior like below.
vim.keymap.set('n', '<leader>ce', '<cmd>CommentREPLExecute<CR>')
vim.keymap.set('n', '<leader>cl', '<cmd>CommentREPLLog<CR>')
```
