-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https:/github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.api.nvim_set_keymap("i", "jk", "<esc>", { silent = true })
vim.g.python3_host_prog = "usr/bin/python3"
