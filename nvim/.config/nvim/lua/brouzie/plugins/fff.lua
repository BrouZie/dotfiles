return {
    "dmtrKovalenko/fff.nvim",
    enabled = true,
    build = function()
        -- this will download prebuild binary or try to use existing rustup toolchain to build from source
        -- (if you are using lazy you can use gb for rebuilding a plugin if needed)
        require("fff.download").download_or_build_binary()
    end,
    lazy = false,
    config = function()
        require("fff").setup({
            install = {
                timeout = 1200, -- 20 minutes - should be plenty
            },
            title = 'Find Files',  -- Window title
            max_results = 100,     -- Maximum search results to display
            max_threads = 4,      -- Maximum threads for fuzzy search
            lazy_sync = true,

            prompt = '> ',       -- Input prompt symbol
            layout = {
                width = 0.90,          -- Window width as fraction of screen
                height = 0.90,         -- Window height as fraction of screen
                prompt_position = 'top', -- or 'top'
                preview_position = 'right', -- or 'left', 'right', 'top', 'bottom'
                preview_size = 0.5,
                flex = false,
                min_list_height = 15,
            },
            preview = {
                enabled = true,
                max_lines = 100,
                max_size = 10 * 1024 * 1024, -- 1MB
                chunk_size = 8192,
                binary_file_threshold = 1024,
                line_numbers = false,
                wrap_lines = false,
                show_file_info = true,
                history = {
                    enabled = true,
                    db_path = vim.fn.stdpath('data') .. '/fff_queries',
                    min_combo_count = 3, -- file will get a boost if it was selected 3 in a row times per specific query
                    combo_boost_score_multiplier = 100, -- Score multiplier for combo matches
                },
            },
            keymaps = {
                close = {'<C-c>','<Esc>'},
                select = '<CR>',
                select_split = '<C-s>',
                select_vsplit = '<C-v>',
                select_tab = '<C-t>',
                -- Multiple bindings supported
                move_up = { '<Up>', '<C-p>', '<C-k>' },
                move_down = { '<Down>', '<C-n>', '<C-j>'},
                preview_scroll_up = '<C-u>',
                preview_scroll_down = '<C-d>',
                toggle_preview = '<C-o>',
            },
            git = {
                status_text_color = true, -- Enable git status colors on filename text
            },
            -- Highlight groups
            hl = {
                border = 'FloatBorder',
                normal = 'Normal',
                cursor = 'CursorLine',
                matched = 'IncSearch',
                title = 'Title',
                prompt = 'Question',
                active_file = 'Visual',
                frecency = 'Number',
                debug = 'Comment',
                git_staged = 'FFFGitStaged',       -- Files staged for commit
                git_modified = 'FFFGitModified',   -- Modified unstaged files
                git_deleted = 'FFFGitDeleted',     -- Deleted files
                git_renamed = 'FFFGitRenamed',     -- Renamed files
                git_untracked = 'FFFGitUntracked', -- New untracked files
                git_ignored = 'FFFGitIgnored',     -- Git-ignored files
            },
            frecency = {
                enabled = true,
                db_path = vim.fn.stdpath('cache') .. '/fff_nvim',
            },
            history = {
                enabled = true,
                db_path = vim.fn.stdpath('data') .. '/fff_queries',
                min_combo_count = 3, -- file will get a boost if it was selected 3 in a row times per specific query
                combo_boost_score_multiplier = 100, -- Score multiplier for combo matches
            },
            -- Debug options
            debug = {
                show_scores = false,  -- Toggle with F2 or :FFFDebug
            },
        })

        -- fff.nvim has no preview toggle; wire one up live via relayout().
        local picker_ui = require('fff.picker_ui.picker_ui')
        local state = require('fff.picker_ui.picker_ui_state').state

        picker_ui.toggle_preview = function()
            if not state.config or not state.config.preview then return end
            state.config.preview.enabled = not state.config.preview.enabled
            local status = state.config.preview.enabled and 'enabled' or 'disabled'
            vim.notify('FFF preview ' .. status, vim.log.levels.INFO)
            picker_ui.relayout()
        end

        -- Register the toggle keymap: setup_keymaps has no slot for it.
        local ui_creator = require('fff.picker_ui.ui_creator')
        local original_setup_keymaps = ui_creator.setup_keymaps
        ui_creator.setup_keymaps = function()
            original_setup_keymaps()
            local toggle = state.config and state.config.keymaps and state.config.keymaps.toggle_preview
            if not toggle then return end
            local function map(buf, modes)
                vim.keymap.set(modes, toggle, picker_ui.toggle_preview, { buffer = buf, noremap = true, silent = true })
            end
            map(state.input_buf, { 'i', 'n' })
            map(state.list_buf, 'n')
        end

        -- Auto-hide preview on narrow terminals. fff only ships min_list_height,
        -- so patch layout.compute to honor min_list_width as well.
        local layout = require('fff.layout')
        local original_compute = layout.compute
        layout.compute = function(config, preview_user_enabled)
            local min_width = config.layout and config.layout.min_list_width
            if min_width and vim.o.columns <= min_width then
                preview_user_enabled = false
            end
            return original_compute(config, preview_user_enabled)
        end
    end,
    keys = {
        {
            "<leader>f",
            function()
                require("fff").find_files({ preview = { enabled = false } })
            end,
            desc = "Open file picker",
        },
        {
            "<leader>g",
            function() require('fff').live_grep({
                grep = {
                  modes = { 'plain', 'fuzzy' }
                }
            }) end,
            desc = 'Live fffuzy grep word',
        },
        {
            "<leader>F",
            function()
                require("fff").find_in_git_root()
            end,
            desc = "Find files in git root",
        },
        {
            "<leader>td",
            function()
                 require("fff").find_files_in_dir("~/Documents/2ndBrain/TODO") -- Find files in a specific directory
            end,
            desc = "Find files in specified path",
        },
    },
}
