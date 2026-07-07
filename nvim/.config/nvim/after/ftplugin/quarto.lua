local cells = require("brouzie.utils.mdcells")
vim.opt.wrap = true

vim.keymap.set("n", "<space>k", cells.jump_up,   { desc = "Jump to previous code cell", buffer = true })
vim.keymap.set("n", "<space>j", cells.jump_down, { desc = "Jump to next code cell",     buffer = true })
