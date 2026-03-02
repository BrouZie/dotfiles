return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		-- "saghen/blink.cmp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
	},
	config = function()
		-- LSP Keybinds

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				-- Buffer local mappings
				-- Check `:help vim.lsp.*` for documentation on any of the below functions
				local opts = { buffer = ev.buf, silent = true }

				-- keymaps
				-- inside your LspAttach/on_attach, keep your opts table
				opts.desc = "Show LSP references"
				vim.keymap.set("n", "grr", function()
					require("fzf-lua").lsp_references()
				end, opts)

				opts.desc = "Go to declaration"
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

				opts.desc = "Show LSP definitions"
				vim.keymap.set("n", "gd", function()
					require("fzf-lua").lsp_definitions({ jump_to_single_result = true })
				end, opts)

				opts.desc = "Show LSP implementations"
				vim.keymap.set("n", "gi", function()
					require("fzf-lua").lsp_implementations({ jump_to_single_result = true })
				end, opts)

				opts.desc = "Show LSP type definitions"
				vim.keymap.set("n", "gt", function()
					require("fzf-lua").lsp_typedefs({ jump_to_single_result = true })
				end, opts)

				opts.desc = "Show LSP project symbols"
				vim.keymap.set("n", "<leader>ps", function()
					require("fzf-lua").lsp_workspace_symbols()
				end, opts)

				opts.desc = "Project: functions & methods"
				vim.keymap.set("n", "<leader>pf", function()
					require("fzf-lua").lsp_workspace_symbols({
						query = "function|method", -- quick filter string
					})
				end, opts)

				opts.desc = "Project: classes & interfaces"
				vim.keymap.set("n", "<leader>pc", function()
					require("fzf-lua").lsp_workspace_symbols({
						query = "class|interface|struct",
					})
				end, opts)

				opts.desc = "See available code actions"
				vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

				opts.desc = "Smart rename"
				vim.keymap.set("n", "grn", vim.lsp.buf.rename, opts)

				-- diagnostics picker (Telescope diagnostics bufnr=0)
				opts.desc = "Show buffer diagnostics"
				vim.keymap.set("n", "<leader>D", function()
					require("fzf-lua").diagnostics_document()
				end, opts)

				opts.desc = "Show line diagnostics"
				vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

				opts.desc = "Show documentation for what is under cursor"
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

				opts.desc = "Restart LSP"
				vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary

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

		-- Set the diagnostic config with all icons
		vim.diagnostic.config({
			signs = {
				text = signs, -- Enable signs in the gutter
			},
			virtual_text = true, -- Specify Enable virtual text for diagnostics
			underline = true, -- Specify Underline diagnostics
			update_in_insert = false, -- Keep diagnostics active in insert mode
		})

		-- Setup servers
		local lspconfig = require("lspconfig")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local capabilities = cmp_nvim_lsp.default_capabilities()

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
				basedpyright = {
					analysis = {
						typeCheckingMode = "basic", -- or "strict"
						autoImportCompletions = true,
					},
				},
			},
		})

		vim.lsp.config("ruff", {
			capabilities = capabilities,
		})
		-- emmet_ls
		vim.lsp.config("emmet_ls", {
			capabilities = capabilities,
			filetypes = {
				"html",
				"typescriptreact",
				"javascriptreact",
				"css",
				"sass",
				"scss",
				"less",
				"svelte",
			},
		})

		-- emmet_language_server
		vim.lsp.config("emmet_language_server", {
			capabilities = capabilities,
			filetypes = {
				"css",
				"eruby",
				"html",
				"javascript",
				"javascriptreact",
				"less",
				"sass",
				"scss",
				"pug",
				"typescriptreact",
			},
			init_options = {
				includeLanguages = {},
				excludeLanguages = {},
				extensionsPath = {},
				preferences = {},
				showAbbreviationSuggestions = true,
				showExpandedAbbreviation = "always",
				showSuggestionsAsSnippets = false,
				syntaxProfiles = {},
				variables = {},
			},
		})

		-- .xml support
		vim.lsp.config("lemminx", {
			capabilities = capabilities,
		})

		-- denols
		vim.lsp.config("denols", {
			capabilities = capabilities,
			root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
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
					fallbackFlags = { "-std=c++20" },
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

		-- hyprland language server
		vim.lsp.config("hyprls", {
			capabilities = capabilities,
		})

		-- r language server
		vim.lsp.config("r_ls", {
			capabilities = capabilities,
			cmd = { "R", "--slave", "-e", "languageserver::run()" },
			filetypes = { "r", "rmd" },
			root_markers = { ".git", "DESCRIPTION", ".Rproj" },
		})

		-- ts_ls (replaces tsserver)
		vim.lsp.config("ts_ls", {
			capabilities = capabilities,
			root_dir = function(fname)
				local util = lspconfig.util
				return not util.root_pattern("deno.json", "deno.jsonc")(fname)
					and util.root_pattern("tsconfig.json", "package.json", "jsconfig.json", ".git")(fname)
			end,
			single_file_support = false,
			init_options = {
				preferences = {
					includeCompletionsWithSnippetText = true,
					includeCompletionsForImportStatements = true,
				},
			},
		})
		vim.lsp.enable("lua_ls")
		vim.lsp.enable("basedpyright")
		vim.lsp.enable("ruff")
		vim.lsp.enable("emmet_ls")
		vim.lsp.enable("emmet_language_server")
		vim.lsp.enable("denols")
		vim.lsp.enable("clangd")
		vim.lsp.enable("bashls")
		vim.lsp.enable("marksman")
		vim.lsp.enable("lemminx")
		vim.lsp.enable("ts_ls")
		vim.lsp.enable("hyprls")
		vim.lsp.enable("r_ls")
	end,
}
