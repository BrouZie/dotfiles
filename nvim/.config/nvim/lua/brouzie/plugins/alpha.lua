return {
  "goolord/alpha-nvim",
  dependencies = { "echasnovski/mini.icons" },

  config = function()
    local alpha     = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    -- Highlight groups for the sokratOS logo (re-apply after colorscheme changes)
    local function set_sokrat_hl()
      vim.api.nvim_set_hl(0, "SokratBold", { fg = "#ffffff", bold = true })
      vim.api.nvim_set_hl(0, "SokratBlue", { fg = "#1793d1" })
    end
    vim.api.nvim_create_autocmd("ColorScheme", { callback = set_sokrat_hl })
    set_sokrat_hl()

    dashboard.section.header.val = {
      [[              __                     __    _____   ____  ]],
      [[             /\ \                   /\ \__/\  __`\/\  _`\]],
      [[  ____    ___\ \ \/'\   _ __    __  \ \ ,_\ \ \/\ \ \,\L\_\]],
      [[ /',__\  / __`\ \ , <  /\`'__\/'__`\ \ \ \/\ \ \ \ \/_\__ \]],
      [[/\__, `\/\ \L\ \ \ \\`\\ \ \//\ \L\.\_\ \ \_\ \ \_\ \/\ \L\ \]],
      [[\/\____/\ \____/\ \_\ \_\ \_\\ \__/.\_\\ \__\\ \_____\ `\____\]],
      [[ \/___/  \/___/  \/_/\/_/\/_/ \/__/\/_/ \/__/ \/_____/\/_____/]],
    }

    -- Per-line column boundaries where OS rendering begins
    local boundaries = { 43, 42, 44, 43, 44, 45, 46 }

    dashboard.section.header.opts.hl = {}
    for i, boundary in ipairs(boundaries) do
      table.insert(dashboard.section.header.opts.hl, {
        { "SokratBold", 0, boundary },
        { "SokratBlue", boundary, 62 },
      })
    end

    -- 4) Buttons
    dashboard.section.buttons.val = {
			dashboard.button("f", "󰈞  Find file",    ":Telescope find_files<CR>"),
			dashboard.button("G", "  Git Status",   function()
				local alpha_buf = vim.api.nvim_get_current_buf()
				vim.cmd.Git()
				vim.api.nvim_buf_delete(alpha_buf, { force = true })
			end),
			dashboard.button("g", "󰈬  Grep word",    ":Telescope live_grep<CR>"),
      dashboard.button("e", "  Explore",      ":Oil<CR>"),
      dashboard.button("r", "󰊄  Recent files", ":Telescope oldfiles<CR>"),
      dashboard.button("q", "󰈆  Quit NVIM",    ":qa<CR>"),
    }

    alpha.setup(dashboard.opts)
  end,
}

