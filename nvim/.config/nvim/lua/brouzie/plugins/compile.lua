return {
	"ej-shafran/compile-mode.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		vim.g.compile_mode = {
			-- The string to show in the compile prompt as a default.
			-- For an empty prompt, you can use:
			-- default_command = "",
			-- To use different defaults based on filetype, you can use a table:
			default_command = function()
				local ft = vim.bo.filetype
				if ft == "python" then return "uv run %" end
				if vim.fn.filereadable("Makefile") == 1 then return "make -k " end
				if vim.fn.filereadable("CMakeLists.txt") == 1 then return "cmake -B build && cmake --build build" end
				if ft == "c" then return "cc -g -O0 -Wall -Wextra -Wconversion -Wsign-conversion -Wshadow -o %:r %" end
				if ft == "cpp" then return "c++ -std=c++17 -g -O0 -Wall -Weffc++ -Wextra -Wconversion -Wsign-conversion -Wshadow -o %:r %" end
				return "make -k "
			end,
			  -- Maybe fallback to these or a different bind for them. I'd like to
			  -- not add too much complexity, so if I need a bunch of functions to
			  -- get fallback behavior, I'd rather add separate binds
			  -- c = "cc -o %:r % && ./%:r",
			  -- cpp = "cc -std=c++23 -o %:r % && ./%:r",
			-- Needed for "%" expanding to filepath
			bang_expansion = true,
			-- Automatically move the cursor to the end of the compilation buffer.
			-- :h compile-mode.auto_scroll
			auto_scroll = true,
			-- Jump back past the end/beginning of the errors
			-- with `:NextError`/`:PrevError`
			-- :h compile-mode.use_circular_error_navigation
			use_circular_error_navigation = true,
		}
		local run_file = {
			python = "uv run %",
			c = "cc -o %:r % && ./%:r",
			cpp = "c++ -std=c++17 -o %:r % && ./%:r",
		}
		vim.keymap.set("n", "<leader>r", function()
			local cmd = run_file[vim.bo.filetype]
			if not cmd then return vim.notify("No run command for " .. vim.bo.filetype) end
			vim.cmd("silent! wall")
			vim.cmd("vert Compile " .. cmd)
		end, { desc = "Run current file" })
		vim.keymap.set("n", "<leader>C", "<cmd>silent! wall<cr><cmd>vert Compile<cr>")
		vim.keymap.set("n", "<leader>c", "<cmd>silent! wall<cr><cmd>vert Recompile<cr>")
		vim.keymap.set("n", "<leader>j", "<cmd>NextError<cr>")
		vim.keymap.set("n", "<leader>k", "<cmd>PrevError<cr>")
	end,
}
