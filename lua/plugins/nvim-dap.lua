return {
  "mfussenegger/nvim-dap",
  opts = function()
    local dap = require("dap")
    local json = require("plenary.json") -- Ensure you have `cjson` installed or use an equivalent JSON parser
    -- local notify = require("notify")

    -- Function to read the port from launchSettings.json
    local function get_launchsettings_port()
      local project_root = vim.fn.getcwd() -- Get the current working directory
      vim.notify("current dirctory" .. project_root, vim.log.levels.INFO)
      local settings_path = project_root .. "/Properties/launchSettings.json"

      if vim.fn.filereadable(settings_path) == 1 then
        local file = io.open(settings_path, "r")

        if not file then
          vim.notify("Failed to open launchSeetings.json", vim.log.levels.ERROR)
          return nil
        end

        local content = file:read("*a")
        file:close()

        local launch_settings = json.decode(content)
        for _, profile in pairs(launch_settings.profiles) do
          if profile.applicationUrl then
            local urls = vim.split(profile.applicationUrl, ";")
            for _, url in ipairs(urls) do
              local port = url:match("http://localhost:(%d+)")
              if port then
                return tonumber(port)
              end
            end
          end
        end
      end

      return nil -- Default to nil if no port is found
    end

    local function rebuild_project()
      local cwd = vim.fn.getcwd()
      local cmd = "dotnet build"
      local handle = io.open(cmd)
      if handle then
        local result = handle:read("*a")
        handle:close()
        vim.notify("Rebuild complete:\n" .. result, vim.log.levels.INFO)
      else
        vim.notify("Failed to rebuild project", vim.log.levels.ERROR)
      end
    end
    -- Ensure netcoredbg adapter is set up
    if not dap.adapters["netcoredbg"] then
      dap.adapters["netcoredbg"] = {
        type = "executable",
        command = vim.fn.exepath("netcoredbg"),
        args = { "--interpreter=vscode" },
        options = {
          detached = false,
        },
      }
    end

    -- Configure DAP for supported languages
    for _, lang in ipairs({ "cs", "fsharp", "vb" }) do
      if not dap.configurations[lang] then
        dap.configurations[lang] = {
          {
            type = "netcoredbg",
            name = "Launch file",
            request = "launch",
            ---@diagnostic disable-next-line: redundant-parameter
            program = function()
              return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/", "file")
            end,
            cwd = "${workspaceFolder}",
            server = function()
              local port = get_launchsettings_port()

              if port then
                vim.notify("the port is " .. tostring(port), vim.log.levels.INFO)
              else
                vim.notify("no port found", vim.log.levels.INFO)
              end

              return port or 5000 -- Default to 5000 if no port is found
            end,
            preLaunchTask = rebuild_project,
          },
        }
      end
    end

    -- Add keymaps here
    -- Start/Stop Debugging
    vim.keymap.set("n", "<F5>", dap.continue, { desc = "Start/Continue Debugging" })
    vim.keymap.set("n", "<S-F5>", dap.terminate, { desc = "Stop Debugging" })
    -- vim.keymap.set("n", "<C-F5>", function()
    --   dap.run({ noDebug = true })
    -- end, { desc = "Start Without Debugging" })

    -- Step Over/Into/Out
    vim.keymap.set("n", "<F6>", dap.step_over, { desc = "Step Over" })
    vim.keymap.set("n", "<F7>", dap.step_into, { desc = "Step Into" })
    -- vim.keymap.set("n", "<S-F11>", dap.step_out, { desc = "Step Out" })

    -- Breakpoints
    -- vim.keymap.set("n", "<F9>", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
    -- vim.keymap.set("n", "<C-S-F9>", dap.clear_breakpoints, { desc = "Clear All Breakpoints" })

    -- Navigating During Debugging
    -- vim.keymap.set("n", "<C-A-U>", require("dap.ui.widgets").scopes, { desc = "Show Call Stack" })
    -- vim.keymap.set("n", "<C-D>", dap.repl.open, { desc = "Open REPL (Immediate Window)" })

    -- Execution Context
    -- vim.keymap.set("n", "<C-S-F10>", dap.run_to_cursor, { desc = "Run to Cursor" })
    -- vim.keymap.set("n", "<C-F10>", dap.run_to_cursor, { desc = "Run to Cursor (Duplicate)" }) -- Visual Studio behavior
    -- vim.keymap.set("n", "<A-F5>", function()
    --   require("dap.ui.widgets").threads()
    -- end, { desc = "Show Threads Window" })
  end,
}
