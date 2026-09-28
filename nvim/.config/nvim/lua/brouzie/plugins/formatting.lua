return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters = {
				["markdown-toc"] = {
					condition = function(_, ctx)
						for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
							if line:find("<!%-%- toc %-%->") then
								return true
							end
						end
					end,
				},
				["markdownlint-cli2"] = {
					condition = function(_, ctx)
						local diag = vim.tbl_filter(function(d)
							return d.source == "markdownlint"
						end, vim.diagnostic.get(ctx.buf))
						return #diag > 0
					end,
				},
				["clang-format"] = {
					args = {
						"--assume-filename",
						"$FILENAME",
						"--style={"
						.. "BasedOnStyle: Microsoft, "
						.. "IndentWidth: 4, "
						.. "IndentCaseLabels: true, "
						.. "UseTab: Never, "
						-- .. "ColumnLimit: 100, "
						.. "PointerAlignment: Left, "
						.. "AlignConsecutiveAssignments: {Enabled: true, AcrossEmptyLines: false, AcrossComments: false, AlignCompound: true}, "
						.. "AlignConsecutiveShortCaseStatements: {Enabled: true, AcrossEmptyLines: false, AcrossComments: false, AlignCaseColons: false}, "
						.. "AllowShortCaseLabelsOnASingleLine: true, "
						.. "AllowShortFunctionsOnASingleLine: true, "
						.. "Cpp11BracedListStyle: false, "
						.. "SpaceBeforeCpp11BracedList: true, "
						.. "}",
						-- "--style={BasedOnStyle: WebKit, BreakBeforeBraces: Allman, IndentWidth: 4, UseTab: Never, ColumnLimit: 100}",
					},
				},
			},
			formatters_by_ft = {
                lua = { "stylua" },
                markdown = { "mdformat","markdownlint-cli2","markdown-toc" },
				cpp = { "clang-format" },
				c = { "clang-format" },
                sh = { "shfmt" },
                bash = { "shfmt" },
                -- python = { "black" },
			},
			-- format_on_save = {
			-- 	lsp_fallback = true,
			-- 	async = false,
			-- 	timeout_ms = 1000,
			-- },
		})

		-- Configure individual formatters
		conform.formatters.shfmt = {
			prepend_args = { "-i", "4" },
		}

		vim.keymap.set({ "n", "v" }, "<leader>lf", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			})
		end, { desc = "Format whole file or range (in visual mode)" })
	end,
}
