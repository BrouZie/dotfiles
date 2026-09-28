-- General mappings ===========================================================

-- Helpers to create mappings with a description. See `:h vim.keymap.set()`.
local nmap = function(lhs, rhs, desc) vim.keymap.set("n", lhs, rhs, { desc = desc }) end
local xmap = function(lhs, rhs, desc) vim.keymap.set("x", lhs, rhs, { desc = desc }) end

-- Move by visual lines when there is no count (useful with "wrap" set)
vim.keymap.set("n", "j", [[v:count == 0 ? "gj" : "j"]], { expr = true, desc = "Down (wrap-aware)" })
vim.keymap.set("n", "k", [[v:count == 0 ? "gk" : "k"]], { expr = true, desc = "Up (wrap-aware)" })

nmap("<Esc>", "<Cmd>nohlsearch<CR>", "Clear search highlight")

-- Move between windows
nmap("<C-h>", "<C-w>h", "Focus left window")
nmap("<C-j>", "<C-w>j", "Focus below window")
nmap("<C-k>", "<C-w>k", "Focus above window")
nmap("<C-l>", "<C-w>l", "Focus right window")

-- Keep selection after indenting; move selected lines up/down
xmap("<", "<gv",              "Indent left")
xmap(">", ">gv",              "Indent right")
xmap("J", ":m '>+1<CR>gv=gv", "Move lines down")
xmap("K", ":m '<-2<CR>gv=gv", "Move lines up")

-- Terminal mode: <Esc> leaves terminal mode when the shell is in front, but is
-- sent to the program when one is running (nvim, htop, less, lazygit, ...).
-- Reads the terminal's foreground process group from '/proc' (Linux only).
local shell_in_front = function()
  local ok, pid = pcall(vim.fn.jobpid, vim.bo.channel)
  local stat = ok and io.open("/proc/" .. pid .. "/stat")
  if not stat then return true end
  local comm, rest = stat:read("*l"):match("^%d+ %((.*)%) (.*)$")
  stat:close()
  -- After the command name: state ppid pgrp session tty_nr tpgid.
  -- Also check the job is a shell (bash, zsh, fish, ...): a terminal running
  -- e.g. lazygit directly has it in front too, and it needs <Esc>.
  local fields = vim.split(rest, " ")
  return tonumber(fields[6]) == pid and comm:match("sh$") ~= nil
end
vim.keymap.set("t", "<Esc>", function()
  return shell_in_front() and [[<C-\><C-n>]] or "<Esc>"
end, { expr = true, desc = "Exit terminal mode (shell) / send <Esc> (program)" })

-- Leader mappings ============================================================

vim.g.mapleader      = " "  -- Use `<Space>` as <leader> key
vim.g.maplocalleader = "\\" -- Use `\` as <LocalLeader> key

-- Many mappings live next to the plugin they use:
-- - 'plugins/fff.lua'            files and grep (f, F, /, td)
-- - 'plugins/fzf-lua.lua'        other pickers (#, $, ', h, M, ths, df, gb, gc, gh, gs, gw, gz)
-- - 'plugins/git-stuff.lua'      git hunks and review (ga, gA, gr, gp, gB, gd, gH, ]h, [h, ih)
-- - 'brouzie/terminalpop.lua'    floating terminal (tt, <M-t>) and lazygit (gL)
-- - 'plugins/lsp/lspconfig.lua'  LSP (gd, gR, gi, gt, gD, gO, gW, grn, la, D)
-- - 'plugins/compile.lua'        compile (C, c, j, k)
-- - 'after/ftplugin/*.lua'       run current file (x)
local nmap_leader = function(suffix, rhs, desc)
  vim.keymap.set("n", "<leader>" .. suffix, rhs, { desc = desc })
end

-- Mappings ending with a space (like `:help `) leave the command line open so
-- you can type the rest. Others use `<Cmd>...<CR>` to run straight away.

-- Single-key actions
local toggle_inlay_hints = function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end
local select_md_codeblock = function()
  local start_line = vim.fn.search("^```\\S", "bnW")
  local end_line = vim.fn.search("^```\\s*$", "nW")
  if start_line > 0 and end_line > start_line + 1 then
    vim.api.nvim_win_set_cursor(0, { start_line + 1, 0 })
    vim.cmd("normal! V")
    vim.api.nvim_win_set_cursor(0, { end_line - 1, 0 })
  else
    print("You are not within a codeblock!")
  end
end

nmap_leader("b", "<Cmd>e #<CR>",       "Alternate buffer")
nmap_leader("e", "<Cmd>Oil<CR>",       "Explore (Oil)")
nmap_leader("H", toggle_inlay_hints,   "Toggle inlay hints")
nmap_leader("o", select_md_codeblock,  "Select inside markdown codeblock")
nmap_leader("q", "<Cmd>quit<CR>",      "Quit window")
nmap_leader("w", "<Cmd>update<CR>",    "Write if modified")

-- Windows
nmap_leader("+", "<Cmd>vertical resize +5<CR>", "Wider")
nmap_leader("\\", "<Cmd>vertical resize -5<CR>", "Narrower")
nmap_leader("?", "<Cmd>resize +5<CR>",          "Taller")
nmap_leader("`", "<Cmd>resize -5<CR>",          "Shorter")
nmap_leader("s", "<Cmd>split<CR>",              "Split horizontal")
nmap_leader("S", "<Cmd>sfind #<CR>",            "Split alternate file")
nmap_leader("v", "<Cmd>vsplit<CR>",             "Split vertical")
nmap_leader("V", "<Cmd>vsplit #<CR>",           "Split vertical alternate file")

nmap_leader(".", "<Cmd>cd %:p:h | pwd<CR>", "cd to file directory")

-- Pickers (#, $, ', h, M, ths, df, and git ones) live in 'plugins/fzf-lua.lua'

-- g is for 'Git' (vim-fugitive)
nmap_leader("gg", "<Cmd>vert Git<CR>", "Status (vertical)")

-- r is for 'Replace'
local replace_word = [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]]

nmap_leader("rp", replace_word, "Replace word under cursor")

-- y is for 'Yank'
local copy_file_path = function()
  local path = vim.fn.expand("%:~")
  vim.fn.setreg("+", path)
  print("File path copied to clipboard: " .. path)
end

nmap_leader("yp", copy_file_path, "Copy file path")
