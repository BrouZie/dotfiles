-- General ====================================================================
vim.o.clipboard = "unnamedplus" -- Sync with system clipboard
vim.o.confirm   = true          -- Ask to save instead of failing on `:q`
vim.o.exrc      = true          -- Load project-local ".nvim.lua" (asks to trust)
vim.o.secure    = true          -- Restrict commands in local config files
vim.o.undofile  = true          -- Enable persistent undo

-- UI =========================================================================
vim.o.cursorline     = true       -- Enable current line highlighting
vim.o.number         = true       -- Show line numbers
vim.o.relativenumber = true       -- Show line numbers relative to cursor
vim.o.scrolloff      = 2          -- Keep 2 lines above/below cursor
vim.o.sidescrolloff  = 5          -- Keep 5 columns left/right of cursor
vim.o.signcolumn     = "yes"      -- Always show signcolumn (less flicker)
vim.o.splitbelow     = true       -- Horizontal splits will be below
vim.o.splitright     = true       -- Vertical splits will be to the right
vim.o.termguicolors  = true       -- Enable 24-bit colors
vim.o.winborder      = "rounded"  -- Use border in floating windows
vim.o.wrap           = false      -- Don"t visually wrap lines

-- Cursor shape per mode: block in Normal, bar in Insert, underline in Replace
vim.o.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkon500-blinkoff500-blinkwait500"

-- Folds (see `:h fold-commands`, `:h zM`, `:h zR`, `:h zA`, `:h zj`)
vim.o.foldlevel   = 10       -- Fold nothing by default; set to 0 or 1 to fold
vim.o.foldmethod  = "indent" -- Fold based on indent level
vim.o.foldnestmax = 10       -- Limit number of fold levels
vim.o.foldtext    = ""       -- Show text under fold with its highlighting

-- Editing ====================================================================
vim.o.autoindent    = true    -- Use auto indent
vim.o.expandtab     = true    -- Convert tabs to spaces
vim.o.formatoptions = "rqnl1j"-- Improve comment editing
vim.o.ignorecase    = true    -- Ignore case during search
vim.o.shiftwidth    = 4       -- Use this number of spaces for indentation
vim.o.smartcase     = true    -- Respect case if search pattern has upper case
vim.o.smartindent   = true    -- Make indenting smart
vim.o.tabstop       = 4       -- Show tab as this number of spaces
vim.o.spelloptions  = "camel" -- Treat camelCase word parts as separate words

-- Built-in completion
vim.o.complete        = ".,w,b,kspell"                  -- Use less sources
vim.o.completeopt     = "menuone,noselect,fuzzy,nosort" -- Use custom behavior
vim.o.completetimeout = 100                             -- Limit sources delay
-- Don't think i really need this on anymore, it'll be deleted!
-- vim.o.wildoptions     = "pum,fuzzy"                     -- Fuzzy command-line completion

-- Autocommands ===============================================================

-- Briefly highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function() vim.hl.on_yank() end,
})

-- Remember the last picked colorscheme across restarts. Not on Omarchy: there the
-- system theme is the source of truth (see 'brouzie/omarchy'), so picks are
-- session-only and Omarchy's own live theme switches aren't written here.
vim.api.nvim_create_autocmd("ColorScheme", {
	desc = "Save current colorscheme",
	callback = function(ev)
		if vim.v.vim_did_enter == 0 then return end
		if require("brouzie.omarchy").available() then return end
		local path = vim.fn.stdpath("config") .. "/lua/current-theme.lua"
		vim.fn.writefile({ ("vim.cmd('colorscheme %s')"):format(ev.match) }, path)
	end,
})
-- stylua: ignore end
