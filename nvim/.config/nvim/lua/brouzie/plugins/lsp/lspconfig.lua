return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"saghen/blink.cmp",
	},
	config = function()
		-- LSP Keybinds

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				-- Buffer local mappings
				-- Check `:help vim.lsp.*` for documentation on any of the below functions
				local opts = { buffer = ev.buf, silent = true }

				-- keymaps: fuzzy pickers with preview (fzf-lua). A single result jumps directly.
				local fzf = function(picker)
					return function() require("fzf-lua")[picker]() end
				end

				opts.desc = "Show LSP references"
				vim.keymap.set("n", "gR", fzf("lsp_references"), opts)

				opts.desc = "Go to declaration"
				vim.keymap.set("n", "gD", fzf("lsp_declarations"), opts)

				opts.desc = "Show LSP definitions"
				vim.keymap.set("n", "gd", fzf("lsp_definitions"), opts)

				opts.desc = "Show LSP implementations"
				vim.keymap.set("n", "gi", fzf("lsp_implementations"), opts)

				opts.desc = "Show LSP type definitions"
				vim.keymap.set("n", "gt", fzf("lsp_typedefs"), opts)

				opts.desc = "Document symbols"
				vim.keymap.set("n", "gO", fzf("lsp_document_symbols"), opts)

				opts.desc = "Workspace symbols (live)"
				vim.keymap.set("n", "gW", fzf("lsp_live_workspace_symbols"), opts)

				-- Previews the change as a diff; in visual mode applies to selection
				opts.desc = "See available code actions"
				vim.keymap.set({ "n", "v" }, "<leader>la", fzf("lsp_code_actions"), opts)

				-- Prompt is a floating input at the cursor (see 'brouzie/ui-input.lua')
				opts.desc = "Smart rename"
				vim.keymap.set("n", "grn", vim.lsp.buf.rename, opts)

				opts.desc = "Show buffer diagnostics"
				vim.keymap.set("n", "<leader>D", fzf("diagnostics_document"), opts)

				opts.desc = "Show line diagnostics"
				vim.keymap.set("n", "<leader>dl", function() vim.diagnostic.open_float() end, opts)

				opts.desc = "Show documentation for what is under cursor"
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

				opts.desc = "Restart LSP"
				vim.keymap.set("n", "<leader>rs", ":lsp restart<CR>", opts) -- mapping to restart lsp if necessary

				vim.keymap.set("i", "<C-h>", function()
					vim.lsp.buf.signature_help()
				end, opts)
			end,
		})

		-- Define sign icons for each severity
		local signs = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.HINT] = "󰠠 ",
			[vim.diagnostic.severity.INFO] = " ",
		}

        -- update diagnostic config function
        vim.diagnostic.config({
            signs = { text = signs },
            virtual_text = true,
            underline = true,
            update_in_insert = false,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = true,
            },
        })

        -- toggle for virtual text
        vim.keymap.set("n", "<leader>lx", function()
            local current = vim.diagnostic.config().virtual_text
            vim.diagnostic.config({ virtual_text = not current })
        end, { desc = "Toggle LSP virtual text" })

		vim.lsp.log.set_level("warn")

		-- Single notification when first LSP attaches
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("LspReadyNotify", { clear = true }),
			once = true,
			callback = function(ev)
				local client = vim.lsp.get_client_by_id(ev.data.client_id)
				if client then
					vim.notify(client.name .. " attached")
				end
			end,
		})

        -- NOTE: Setup servers
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        -- blink cmp
        capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

        -- Global LSP settings (applied to all servers)
        vim.lsp.config('*', {
            capabilities = capabilities,
        })

		-- Config lsp servers here
		-- lua_ls
		vim.lsp.config("lua_ls", {
			capabilities = capabilities,
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
					completion = {
						callSnippet = "Replace",
					},
					hint = { enable = true },
					workspace = {
						library = {
							[vim.fn.expand("$VIMRUNTIME/lua")] = true,
							[vim.fn.stdpath("config") .. "/lua"] = true,
						},
					},
				},
			},
		})

		vim.lsp.config("basedpyright", {
			capabilities = capabilities,
			settings = {
				python = {
					analysis = {
						typeCheckingMode = "basic",
						autoImportCompletions = true,
					},
				},
			},
		})

		vim.lsp.config("ruff", {
			capabilities = capabilities,
		})

		-- clangd or c/c++
		vim.lsp.config("clangd", {
			capabilities = capabilities,
			settings = {
				clangd = {
					InlayHints = {
						Designators = true,
						Enabled = true,
						ParameterNames = true,
						DeducedTypes = true,
					},
					fallbackFlags = { "-std=c++17" },
				},
			},
			cmd = {
				"clangd",
				"--background-index",
				"--clang-tidy",
				"--completion-style=detailed",
				"--header-insertion=iwyu",
			},
		})

		-- bashls
		vim.lsp.config("bashls", {
			capabilities = capabilities,
		})

		-- marksman
		vim.lsp.config("marksman", {
			capabilities = capabilities,
		})

		-- -- cmake language server
		-- vim.lsp.config("cmake-language-server", {
		-- 	capabilities = capabilities,
		-- })

		vim.lsp.enable({
			"lua_ls",
			"basedpyright",
			"ruff",
			"clangd",
			"bashls",
			"marksman",
		})
	end,
}
