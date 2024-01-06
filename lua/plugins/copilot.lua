-- if true then
--   return {}
-- end

return {
  {
    "github/copilot.vim",
    event = "InsertEnter",
    config = function()
      vim.cmd("source ~/.config/nvim/extra_conf.vim")
    end,
  },
}
