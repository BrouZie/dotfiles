vim.keymap.set("n", "<leader>x", function()
	vim.cmd("update")
	vim.cmd("belowright split | resize 12")
	local file = vim.fn.shellescape(vim.fn.expand("%"))
	vim.cmd(
		"terminal g++ -std=c++20 -g -O0 -Wall -Weffc++ -Wextra -Wconversion -Wsign-conversion -Wshadow -o run_cpp "
			.. file
			.. " && time ./run_cpp"
	)
	vim.cmd("startinsert")
end, { buffer = true, desc = "Compile and run current cpp file" })
