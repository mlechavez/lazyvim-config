local dap = require("dap")
local noice = require("noice")

return {
  "mfussenegger/nvim-dap",
  init = function()
    vim.g.dotnet_build_project = function()
      local default_path = vim.fn.getcwd() .. "/"
      if vim.g["dotnet_last_proj_path"] ~= nil then
        default_path = vim.g["dotnet_last_proj_path"]
      end
      local path = vim.fn.input("Path to your *proj file", default_path, "file")
      vim.g["dotnet_last_proj_path"] = path
      local cmd = "dotnet build -c Debug " .. path
      noice.notify("Cmd to execute: " .. cmd, "info")
      os.execute(cmd)
    end

    vim.g.dotnet_get_dll_path = function()
      local request = function()
        return vim.fn.input("Path to dll", vim.fn.getcwd() .. "/bin/Debug/", "file")
      end

      if vim.g["dotnet_last_dll_path"] == nil then
        vim.g["dotnet_last_dll_path"] = request()
      else
        if
          vim.fn.confirm("Do you want to change the path to dll?\n" .. vim.g["dotnet_last_dll_path"], "&yes\n&no", 2)
          == 1
        then
          vim.g["dotnet_last_dll_path"] = request()
        end
      end

      return vim.g["dotnet_last_dll_path"]
    end
  end,
  config = function()
    local adapter = {
      type = "executable",
      -- command = vim.fn.exepath("netcoredbg"),
      command = "netcoredbg",
      args = { "--interpreter=vscode" },
    }
    dap.adapters.coreclr = adapter

    local config = {
      {
        name = "launch - netcoredbg",
        type = "coreclr",
        request = "launch",
        cwd = "${workspaceFolder}",
        program = function()
          if vim.fn.confirm("Should I recompile first?", "&yes\n&no", 2) == 1 then
            vim.g.dotnet_build_project()
          end
          -- return vim.g.dotnet_get_dll_path()

          local pickers = require("telescope.pickers")
          local finders = require("telescope.finders")
          local conf = require("telescope.config").values
          local actions = require("telescope.actions")
          local action_state = require("telescope.actions.state")

          return coroutine.create(function(coro)
            local opts = {}
            pickers
              .new(opts, {
                prompt_title = "Path to executable",
                finder = finders.new_oneshot_job({ "fd", "--hidden", "--no-ignore", "--type", "f", "-e", "dll" }, {}),
                sorter = conf.generic_sorter(opts),
                attach_mappings = function(buffer_number)
                  actions.select_default:replace(function()
                    actions.close(buffer_number)
                    coroutine.resume(coro, action_state.get_selected_entry()[1])
                  end)
                  return true
                end,
              })
              :find()
          end)
        end,
      },
    }
    dap.configurations.cs = config
  end,
}
