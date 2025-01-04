-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("i", "jk", "<Esc>", { desc = "Go to normal mode" })
vim.keymap.set("n", "<leader>t", ":ToggleTerm direction=float<CR>", { desc = "Opens the terminal", noremap = true })

local dap = require("dap")
vim.keymap.set("n", "<F5>", dap.continue, { desc = "Start/Continue Debugging" })
vim.keymap.set("n", "<S-F5>", dap.terminate, { desc = "Stop Debugging" })
vim.keymap.set("n", "<F6>", dap.step_over, { desc = "Step Over" })
vim.keymap.set("n", "<F7>", dap.step_into, { desc = "Step Into" })

vim.api.nvim_set_keymap(
  "n",
  "<C-b>",
  ":lua vim.g.dotnet_build_project()<CR>",
  { noremap = true, silent = true, desc = "Build dotnet project" }
)

-- Move Lines
vim.keymap.set("n", "<C-A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
vim.keymap.set("n", "<C-A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
vim.keymap.set("i", "<C-A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
vim.keymap.set("i", "<C-A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
vim.keymap.set("v", "<C-A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
vim.keymap.set("v", "<C-A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })
