-- Strip backgrounds after any colorscheme loads.
--
-- Ported from Omarchy's own plugin/after/transparency.lua. The colorschemes
-- configured in brouzie.plugins.colorscheme set transparency themselves, but
-- Omarchy can select any of ~20 themes, most of which this config never
-- configures. Running the same pass Omarchy runs keeps every one of them
-- transparent instead of only the handful with a local config block.

local M = {}

local groups = {
  -- editor
  "Normal",
  "NormalNC",
  "NormalFloat",
  "FloatBorder",
  "FloatTitle",
  "Pmenu",
  "Terminal",
  "EndOfBuffer",
  "FoldColumn",
  "Folded",
  "SignColumn",
  "LineNr",
  "CursorLineNr",
  "WinBar",
  "WinBarNC",
  "MsgArea",
  "WhichKeyFloat",
  -- telescope
  "TelescopeNormal",
  "TelescopeBorder",
  "TelescopePromptNormal",
  "TelescopePromptBorder",
  "TelescopePromptTitle",
  "TelescopeResultsNormal",
  "TelescopeResultsBorder",
  "TelescopePreviewNormal",
  "TelescopePreviewBorder",
  -- snacks
  "SnacksNormal",
  "SnacksNormalNC",
  "SnacksPickerNormal",
  "SnacksPickerBorder",
  "SnacksPickerPreview",
  "SnacksDashboardNormal",
  "SnacksDashboardDesc",
  "SnacksDashboardIcon",
  -- blink.cmp
  "BlinkCmpMenu",
  "BlinkCmpMenuBorder",
  "BlinkCmpDoc",
  "BlinkCmpDocBorder",
  "BlinkCmpSignatureHelp",
  "BlinkCmpSignatureHelpBorder",
  -- oil / neo-tree / nvim-tree
  "OilFloat",
  "NeoTreeNormal",
  "NeoTreeNormalNC",
  "NeoTreeVertSplit",
  "NeoTreeWinSeparator",
  "NeoTreeEndOfBuffer",
  "NvimTreeNormal",
  "NvimTreeVertSplit",
  "NvimTreeEndOfBuffer",
  -- notifications
  "NotifyINFOBody",
  "NotifyERRORBody",
  "NotifyWARNBody",
  "NotifyTRACEBody",
  "NotifyDEBUGBody",
  "NotifyINFOTitle",
  "NotifyERRORTitle",
  "NotifyWARNTitle",
  "NotifyTRACETitle",
  "NotifyDEBUGTitle",
  "NotifyINFOBorder",
  "NotifyERRORBorder",
  "NotifyWARNBorder",
  "NotifyTRACEBorder",
  "NotifyDEBUGBorder",
}

--- Drop a group's background while keeping every other attribute it defines.
local function make_transparent(name)
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
  if not ok or vim.tbl_isempty(hl) then
    return
  end
  hl.bg = nil
  hl.ctermbg = nil
  pcall(vim.api.nvim_set_hl, 0, name, hl)
end

function M.apply()
  for _, name in ipairs(groups) do
    make_transparent(name)
  end
end

function M.setup()
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("BrouzieOmarchyTransparency", { clear = true }),
    callback = function()
      -- Let the colorscheme (and anything hooking ColorScheme before us) finish
      -- defining its groups first.
      vim.schedule(M.apply)
    end,
  })
end

return M
