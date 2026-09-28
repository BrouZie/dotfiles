-- Bridge between Omarchy's dynamic theme system and this config.
--
-- `omarchy theme set <name>` rebuilds ~/.local/state/omarchy/current/theme/ and
-- writes a lazy.nvim spec there as neovim.lua, naming the colorscheme plugin for
-- that theme. Omarchy's own Neovim config symlinks that file into lua/plugins/ and
-- reads the colorscheme out of the `LazyVim/LazyVim` entry it contains.
--
-- This config isn't LazyVim, so we read the spec ourselves instead: the plugin
-- entries are handed to lazy from brouzie.plugins.omarchy-themes, and the
-- colorscheme name is applied here -- at startup, and again whenever Omarchy
-- writes a new theme while nvim is running.
--
-- Every entry point degrades to a no-op when Omarchy isn't installed, so this
-- config still works unchanged on other machines.

local M = {}

local state_dir = vim.env.HOME .. "/.local/state/omarchy/current"
local spec_file = state_dir .. "/theme/neovim.lua"

--- True when this machine has an Omarchy theme to follow.
function M.available()
  return vim.uv.fs_stat(spec_file) ~= nil
end

--- Load the generated spec list, or nil if it's missing/unreadable.
local function read_spec()
  local chunk = loadfile(spec_file)
  if not chunk then
    return nil
  end
  local ok, specs = pcall(chunk)
  if not ok or type(specs) ~= "table" then
    return nil
  end
  return specs
end

--- Colorscheme name Omarchy wants, taken from the LazyVim marker entry.
local function colorscheme_of(specs)
  for _, spec in ipairs(specs) do
    if type(spec) == "table" and type(spec.opts) == "table" and spec.opts.colorscheme then
      return spec.opts.colorscheme
    end
  end
end

--- Real plugin entries only -- the LazyVim marker exists to carry the name, not
--- to be installed.
local function plugin_entries(specs)
  local out = {}
  for _, spec in ipairs(specs) do
    if type(spec) == "table" and type(spec[1]) == "string" and spec[1] ~= "LazyVim/LazyVim" then
      table.insert(out, spec)
    end
  end
  return out
end

--- Guess the Lua module a plugin repo exposes: "bjarneo/aether.nvim" -> "aether".
local function module_of(repo)
  local tail = repo:match("[^/]+$")
  return tail and (tail:gsub("%.nvim$", ""):gsub("%.lua$", ""))
end

--- Specs for lazy: the active theme's plugin, eagerly loaded so it's ready at
--- startup. Called from brouzie.plugins.omarchy-themes.
function M.plugins()
  local specs = M.available() and read_spec()
  if not specs then
    return {}
  end
  local out = {}
  for _, spec in ipairs(plugin_entries(specs)) do
    spec.lazy = false
    spec.priority = 1000
    table.insert(out, spec)
  end
  return out
end

--- Re-run a theme plugin's own setup() with freshly generated opts.
---
--- Needed for the themes Omarchy renders from default/themed/neovim.lua.tpl
--- (aether + the theme's colors.toml palette): switching between two of those
--- changes only the opts, and lazy won't re-run setup for an already-loaded
--- plugin whose spec file on disk never changed.
local function reapply_opts(specs)
  for _, spec in ipairs(plugin_entries(specs)) do
    if type(spec.opts) == "table" then
      local mod = module_of(spec[1])
      local ok, plugin = pcall(require, mod)
      if ok and type(plugin) == "table" and type(plugin.setup) == "function" then
        pcall(plugin.setup, spec.opts)
      end
    end
  end
end

--- Make sure the plugin backing `name` is actually loaded before we switch to it.
local function ensure_loaded(specs)
  local ok, loader = pcall(require, "lazy.core.loader")
  if not ok then
    return
  end
  for _, spec in ipairs(plugin_entries(specs)) do
    local plugin_name = spec.name or spec[1]:match("[^/]+$")
    pcall(loader.load, plugin_name, { colorscheme = true })
  end
end

--- Apply Omarchy's current colorscheme. `live` means we're reacting to a theme
--- change rather than starting up, so highlights need clearing first.
function M.apply(live)
  local specs = M.available() and read_spec()
  if not specs then
    return false
  end

  local name = colorscheme_of(specs)
  if not name then
    return false
  end

  if live then
    -- Clear everything the previous colorscheme defined; a stale `background`
    -- would otherwise keep a light theme from taking effect.
    vim.cmd("highlight clear")
    if vim.fn.exists("syntax_on") == 1 then
      vim.cmd("syntax reset")
    end
    vim.o.background = "dark"
    ensure_loaded(specs)
  end

  reapply_opts(specs)

  if not pcall(vim.cmd.colorscheme, name) then
    return false
  end

  if live then
    vim.cmd("redraw!")
  end
  return true
end

--- Watch for `omarchy theme set` and follow it without restarting nvim.
---
--- theme.name is the last thing omarchy-theme-set writes (it rebuilds the theme
--- directory under next-theme/ and renames it into place first), so keying off
--- that file avoids reading a half-built theme. We watch the parent directory,
--- which is never replaced, so the handle stays valid across theme changes.
local function watch()
  local handle = vim.uv.new_fs_event()
  if not handle then
    return
  end

  local timer = vim.uv.new_timer()

  local started = handle:start(state_dir, {}, function(err, filename)
    if err or (filename and filename ~= "theme.name") then
      return
    end
    -- Coalesce the burst of events a single theme switch produces.
    timer:start(150, 0, vim.schedule_wrap(function()
      M.apply(true)
    end))
  end)

  if not started then
    handle:close()
    timer:close()
    return
  end

  vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
      pcall(function()
        timer:close()
        handle:close()
      end)
    end,
  })
end

--- Follow the Omarchy theme. Safe to call unconditionally.
function M.setup()
  if not M.available() then
    return false
  end

  -- Transparency for every theme (Omarchy's included) is handled by
  -- brouzie/transparency.lua, loaded from init.lua before this runs.
  local applied = M.apply(false)
  watch()
  return applied
end

return M
