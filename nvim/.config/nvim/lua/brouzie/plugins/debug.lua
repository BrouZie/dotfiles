return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui", -- debug UI
		"nvim-neotest/nvim-nio", -- Async stuff, no clue if it's needed
		"theHamsta/nvim-dap-virtual-text", -- Inline text during debug

		-- Language helpers
		"mfussenegger/nvim-dap-python", -- Python support
		"leoluz/nvim-dap-go", -- Go support
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")
		local virt_text = require("nvim-dap-virtual-text")

		-----------------------------------------------------------------------
		-- Virtual inline text
		-----------------------------------------------------------------------
		virt_text.setup({
			enabled = true,
			highlight_changed_variables = true,
			show_stop_reason = true,
		})

		-----------------------------------------------------------------------
		-- UI SETUP
		-----------------------------------------------------------------------
		dapui.setup({
			controls = { enabled = false },
		})

		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close()
		end
		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close()
		end

		-----------------------------------------------------------------------
		-- Keybindings
		-----------------------------------------------------------------------
		-- Frequent actions (active debugging) — F-keys, IDE-standard
		vim.keymap.set("n", "<leader>X", dap.continue, { desc = "DAP Continue" })
		vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "DAP Breakpoint" })
		vim.keymap.set("n", "<F1>", dap.step_into, { desc = "DAP Step Into" })
		vim.keymap.set("n", "<F2>", dap.step_over, { desc = "DAP Step Over" })
		vim.keymap.set("n", "<F3>", dap.step_out, { desc = "DAP Step Out" })

		-- Session / UI (infrequent) — keep on <leader>d*
		vim.keymap.set("n", "<leader>dB", function()
			dap.set_breakpoint(vim.fn.input("Condition: "))
		end, { desc = "Conditional breakpoint" })
		vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "Run last" })
		vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "DAP UI toggle" })

		-- Watches
		vim.keymap.set("n", "<leader>dw", function()
			local expr = vim.fn.input("Watch expression: ")
			if expr ~= "" then
				dapui.elements.watches.add(expr)
			end
		end, { desc = "Add watch" })
		vim.keymap.set("n", "<leader>dW", function()
			dapui.elements.watches.remove()
		end, { desc = "Remove watch" })
		vim.keymap.set("n", "<leader>dC", function()
			dapui.elements.watches.clear()
		end, { desc = "Clear watches" })

		---------------------------------------------------------------------------
		-- C / C++ : codelldb (downloaded by Mason)
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
				"codelldb not found at: "
					.. codelldb
					.. "\nInstall it via mason-tool-installer (ensure_installed = { 'codelldb' })",
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
	end,
}
