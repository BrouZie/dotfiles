-- Strip backgrounds after any colorscheme loads (ported from Omarchy's
-- transparency.lua). Themes in 'plugins/colorscheme.lua' set transparency
-- themselves, but only for the groups they know about, and unconfigured themes
-- not at all. This pass makes every theme transparent the same way, including
-- plugin windows (fzf-lua, diffview, ...). It keeps every other attribute.
--
-- Plugin groups that link to these (e.g. `DiffviewNormal` -> `Normal`,
-- `FzfLuaNormal` -> `NormalFloat`) follow automatically. Plugin groups listed
-- below are ones that themes often define with their own background.

local groups = {
	-- Editor
	"Normal",
	"NormalNC",
	"NormalFloat",
	"FloatBorder",
	"FloatTitle",
	"Pmenu",
	"EndOfBuffer",
	"FoldColumn",
	"Folded",
	"SignColumn",
	"LineNr",
	"CursorLineNr",
	"StatusLine",
	"StatusLineNC",
	"WinBar",
	"WinBarNC",
	"MsgArea",
	-- fzf-lua
	"FzfLuaNormal",
	"FzfLuaBorder",
	"FzfLuaTitle",
	"FzfLuaPreviewNormal",
	"FzfLuaPreviewBorder",
	"FzfLuaPreviewTitle",
	-- diffview (some themes, e.g. rose-pine, give these their own background)
	"DiffviewNormal",
	"DiffviewWinSeparator",
	"DiffviewEndOfBuffer",
	"DiffviewStatusLine",
	"DiffviewStatuslineNC",
	-- blink.cmp
	"BlinkCmpMenu",
	"BlinkCmpMenuBorder",
	"BlinkCmpDoc",
	"BlinkCmpDocBorder",
	"BlinkCmpSignatureHelp",
	"BlinkCmpSignatureHelpBorder",
	-- lazy.nvim / mason
	"LazyNormal",
	"MasonNormal",
}

-- Drop a group's background while keeping every other attribute it defines
local make_transparent = function(name)
	local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
	if not ok or vim.tbl_isempty(hl) then return end
	hl.bg, hl.ctermbg = nil, nil
	pcall(vim.api.nvim_set_hl, 0, name, hl)
end

vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("BrouzieTransparency", { clear = true }),
	desc = "Strip highlight backgrounds for a transparent UI",
	-- Scheduled so the colorscheme (and plugins reacting to it) finish first
	callback = function() vim.schedule(function() vim.tbl_map(make_transparent, groups) end) end,
})
