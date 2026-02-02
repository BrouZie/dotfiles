return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",

    -- language helpers (keep if you use them)
    "mfussenegger/nvim-dap-python",
    "leoluz/nvim-dap-go",
  },
  keys = {
    { "<F5>",  function() require("dap").continue() end,     desc = "Debug: Start/Continue" },
    { "<F1>",  function() require("dap").step_into() end,    desc = "Debug: Step Into" },
    { "<F2>",  function() require("dap").step_over() end,    desc = "Debug: Step Over" },
    { "<F3>",  function() require("dap").step_out() end,     desc = "Debug: Step Out" },
    { "<leader>tb", function() require("dap").toggle_breakpoint() end, desc = "Debug: Toggle Breakpoint" },
    {
      "<leader>B",
      function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end,
      desc = "Debug: Conditional Breakpoint",
    },
		{
			"<leader>tl",
			function()
				require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
			end,
			desc = "Debug: Logpoint",
		},
    { "<F7>", function() require("dapui").toggle() end, desc = "Debug: Toggle UI" },
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    -- UI (minimal)
    dapui.setup({
      icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
    })

    dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
    dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
    dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

    ---------------------------------------------------------------------------
    -- C / C++ : codelldb
    ---------------------------------------------------------------------------
    local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
    local codelldb = mason_bin .. "/codelldb"

    if vim.fn.executable(codelldb) == 1 then
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = codelldb,
          args = { "--port", "${port}" },
        },
      }

      dap.configurations.cpp = {
        {
          name = "Launch (codelldb)",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = {},
        },
        {
          name = "Attach to process (codelldb)",
          type = "codelldb",
          request = "attach",
          pid = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
        },
      }

      dap.configurations.c = dap.configurations.cpp
    else
      vim.notify(
        "codelldb not found at: " .. codelldb .. "\nInstall it via mason-tool-installer (ensure_installed = { 'codelldb' })",
        vim.log.levels.WARN
      )
    end

    ---------------------------------------------------------------------------
    -- Python (debugpy)
    ---------------------------------------------------------------------------
		local ok_py, dap_python = pcall(require, "dap-python")
		if ok_py then
			local debugpy_python = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
			dap_python.setup(debugpy_python)
		local dap = require("dap")

		local function project_python()
			local venv = os.getenv("VIRTUAL_ENV")
			if venv and vim.fn.executable(venv .. "/bin/python") == 1 then
				return venv .. "/bin/python"
			end

			local cwd = vim.fn.getcwd()
			local candidates = {
				cwd .. "/.venv/bin/python",
				cwd .. "/venv/bin/python",
			}
			for _, p in ipairs(candidates) do
				if vim.fn.executable(p) == 1 then
					return p
				end
			end

			return vim.fn.exepath("python3")
		end

		dap.configurations.python = {
			{
				type = "python",
				request = "launch",
				name = "Launch file",
				program = "${file}",
				pythonPath = project_python,
			},
		}
		end

    ---------------------------------------------------------------------------
    -- Go (delve)
    ---------------------------------------------------------------------------
    local ok_go, dap_go = pcall(require, "dap-go")
    if ok_go then
      dap_go.setup({
        delve = {
          detached = vim.fn.has("win32") == 0,
        },
      })
    end
  end,
}
