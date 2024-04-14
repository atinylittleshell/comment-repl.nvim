# Comment-REPL.nvim

![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/atinylittleshell/comment-repl.nvim/lint_test.yml?branch=main&style=for-the-badge)
![Lua](https://img.shields.io/badge/Made%20with%20Lua-blueviolet.svg?style=for-the-badge&logo=lua)

A neovim plugin that allows you to run code in a REPL without ever leaving your buffer. Output from the REPL is printed as a comment below the executed code.

Can be used as an extremely simplified Jupyter Notebook experience.

## How does it work

`:CommentREPLExecute` will run the code cell at your cursor and print the output as a comment. That's it!

![Screenshot](doc/screenshot.png?raw=true)

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

Python is the only language supported by default, but you can add support for other REPLs through configuration.

## Commands

`:CommentREPLExecute` - Run the code cell at the cursor and print the output as a comment.

`:CommentREPLLog` - View logs from Comment-REPL.nvim.

```lua
-- By default the plugin will not enable any key bindings.
-- Your can define your own keybind behavior like below.
vim.keymap.set('n', '<leader>ce', '<cmd>CommentREPLExecute<CR>')
vim.keymap.set('n', '<leader>cl', '<cmd>CommentREPLLog<CR>')
```
