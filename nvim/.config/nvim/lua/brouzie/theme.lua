-- Colorscheme entry point, called last from init.lua so it wins over any
-- `colorscheme` a plugin config runs while loading.
--
-- On Omarchy, follow the system theme (`omarchy theme set <name>`) live.
-- Everywhere else, fall back to lua/current-theme.lua.
--
-- This deliberately does not live in lua/current-theme.lua: that path is
-- telescope-themes' default persist target, and the plugin writes it with a
-- bare io.open(path, "w"), so anything kept there is one <leader>ths away from
-- being overwritten.
local ok, omarchy = pcall(require, "brouzie.omarchy")

if ok and omarchy.setup() then
	return
end

pcall(require, "current-theme")
