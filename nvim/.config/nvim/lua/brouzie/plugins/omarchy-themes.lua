-- Colorscheme plugins that `omarchy theme set` can select.
--
-- Mirrors Omarchy's own lua/plugins/all-themes.lua: every theme plugin is
-- declared lazily so switching themes never has to clone one mid-session. The
-- ones this config already configures itself (rose-pine, catppuccin, gruvbox,
-- kanagawa, tokyonight, aether, ...) live in brouzie.plugins.colorscheme instead --
-- lazy merges the two declarations by repo url.
--
-- The active theme's spec is appended last, straight from Omarchy's generated
-- neovim.lua, which is also where its opts come from.

local omarchy = require("brouzie.omarchy")

local specs = {
  { "ribru17/bamboo.nvim", lazy = true, priority = 1000 },
  { "bjarneo/ethereal.nvim", lazy = true, priority = 1000 },
  { "bjarneo/hackerman.nvim", lazy = true, priority = 1000 },
  { "bjarneo/vantablack.nvim", lazy = true, priority = 1000 },
  { "bjarneo/white.nvim", lazy = true, priority = 1000 },
  { "neanias/everforest-nvim", lazy = true, priority = 1000 },
  { "kepano/flexoki-neovim", lazy = true, priority = 1000 },
  { "tahayvr/matteblack.nvim", lazy = true, priority = 1000 },
  { "loctvl842/monokai-pro.nvim", lazy = true, priority = 1000 }, -- gthelding/ fork no longer exists
  { "EdenEast/nightfox.nvim", lazy = true, priority = 1000 },
  { "ficcdaf/ashen.nvim", lazy = true, priority = 1000 },
  { "OldJobobo/miasma.nvim", lazy = true, priority = 1000 },
  { "OldJobobo/retro-82.nvim", lazy = true, priority = 1000 },
  { "omacom-io/lumon.nvim", lazy = true, priority = 1000 },
}

return vim.list_extend(specs, omarchy.plugins())
