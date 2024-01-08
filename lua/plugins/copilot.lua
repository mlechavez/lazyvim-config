return {
  {
    "github/copilot.vim",
    config = function()
      -- vim.g.copilot_filetypes = { xml = false }
      -- or
      -- vim.g.copilot_filetypes = { ["*"] = false, python = true }
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
      vim.g.copilot_tab_fallback = ""
      --
      vim.api.nvim_set_keymap("i", "<A-i>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
    end,
  },
}
