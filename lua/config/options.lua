-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
-- vim.g.autoformat = false

if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
  vim.o.shellslash = false
end
