-- Colorscheme entry point, called last from init.lua so it wins over any
-- `colorscheme` a plugin config runs while loading.
--
-- On Omarchy, follow the system theme (`omarchy theme set <name>`) live.
-- Everywhere else, fall back to lua/current-theme.lua.
--
-- This deliberately does not live in lua/current-theme.lua: that file is
-- overwritten whenever you pick a theme without Omarchy (the `ColorScheme`
-- autocmd in 'core/options.lua'), so nothing kept there is safe.
local ok, omarchy = pcall(require, "brouzie.omarchy")

if ok and omarchy.setup() then
	return
end

pcall(require, "current-theme")
