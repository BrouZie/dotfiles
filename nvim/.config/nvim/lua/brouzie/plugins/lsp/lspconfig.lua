return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"saghen/blink.cmp",
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
				opts.desc = "Show LSP references"
				vim.keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

				opts.desc = "Go to declaration"
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

				opts.desc = "Show LSP definitions"
				vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

				opts.desc = "Show LSP implementations"
				vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

				opts.desc = "Show LSP type definitions"
				vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

				opts.desc = "Show LSP project symbols"
				vim.keymap.set("n", "<leader>ps", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", opts) -- show lsp type definitions

				opts.desc = "Project: functions & methods"
				vim.keymap.set("n", "<leader>pf", function()
					require("telescope.builtin").lsp_dynamic_workspace_symbols({ symbols = { "function", "method" } })
				end, opts)

				opts.desc = "Project: classes & interfaces"
				vim.keymap.set("n", "<leader>pc", function()
					require("telescope.builtin").lsp_dynamic_workspace_symbols({
						symbols = { "class", "interface", "struct" },
					})
				end, opts)

				opts.desc = "See available code actions"
				vim.keymap.set({ "n", "v" }, "<leader>ca", function()
					vim.lsp.buf.code_action()
				end, opts) -- see available code actions, in visual mode will apply to selection

				opts.desc = "Smart rename"
				vim.keymap.set("n", "grn", vim.lsp.buf.rename, opts) -- smart rename

				opts.desc = "Show buffer diagnostics"
                vim.keymap.set("n", "<leader>D", function() require("snacks").picker.diagnostics_buffer() end, opts)

                opts.desc = "Show line diagnostics"
                vim.keymap.set("n", "df", function() vim.diagnostic.open_float() end, opts)

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

        -- emmet_language_server
        vim.lsp.config("emmet_language_server", {
            filetypes = {
                "css",
                "html",
                "javascript",
                "javascriptreact",
                "less",
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

        -- emmet_ls
        vim.lsp.config("emmet_ls", {
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

        -- gopls
        vim.lsp.config("gopls", {
            settings = {
                gopls = {
                    analyses = {
                        unusedparams = true,
                    },
                    staticcheck = true,
                    gofumpt = true,
                },
            },
        })

		-- .xml support
		vim.lsp.config("lemminx", {
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

		-- slangd language server (shader language)
		vim.lsp.config("slangd", {
			capabilities = capabilities,
		})

		-- -- cmake language server
		-- vim.lsp.config("cmake-language-server", {
		-- 	capabilities = capabilities,
		-- })

		-- r language server
		vim.lsp.config("r_ls", {
			capabilities = capabilities,
			cmd = { "R", "--slave", "-e", "languageserver::run()" },
			filetypes = { "r", "rmd" },
			root_markers = { ".git", "DESCRIPTION", ".Rproj" },
		})

		vim.lsp.enable({
			"lua_ls",
			"basedpyright",
			"ruff",
			"emmet_ls",
			"emmet_language_server",
			"clangd",
			"bashls",
			"marksman",
			"lemminx",
			"r_ls",
			"slangd",
		})
	end,
}
