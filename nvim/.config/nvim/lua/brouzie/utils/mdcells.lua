local M = {}

-------------------
-- Codecell jumping
-------------------
local FENCE_OPEN  = "^```\\S"      -- opening fence: ``` followed by a non-whitespace char (the lang)
local FENCE_CLOSE = "^```\\s*$"    -- closing fence: ``` with optional trailing whitespace (vim regex \s)

local function info(msg)
  vim.notify(msg, vim.log.levels.INFO, { title = "Cells" })
end

local function get_row()
  return vim.api.nvim_win_get_cursor(0)[1]
end

local function set_row(row)
  vim.api.nvim_win_set_cursor(0, { row, 0 })
  vim.cmd("normal! zz")
end

-- Find the opening fence for the *current* block (if cursor is inside one).
-- Returns row number of opening fence, or 0 if not inside a fenced block.
local function current_block_open_row()
  local cur = get_row()
  local open = vim.fn.search(FENCE_OPEN, "bnW")
  if open == 0 then return 0 end

  local save = vim.api.nvim_win_get_cursor(0)
  vim.api.nvim_win_set_cursor(0, { open, 0 })
  local close = vim.fn.search(FENCE_CLOSE, "nW")
  vim.api.nvim_win_set_cursor(0, save)

  if close == 0 then return 0 end
  if cur >= open and cur <= close then return open end
  return 0
end

-- Returns the {open, close} row pair for the block the cursor is currently in,
-- or nil if cursor is not inside a fenced block.
local function current_block_range()
  local open = current_block_open_row()
  if open == 0 then return nil end

  local save = vim.api.nvim_win_get_cursor(0)
  vim.api.nvim_win_set_cursor(0, { open, 0 })
  local close = vim.fn.search(FENCE_CLOSE, "nW")
  vim.api.nvim_win_set_cursor(0, save)

  if close == 0 then return nil end
  return { open = open, close = close }
end

-- Public: jump down to next code cell (first line inside the fence)
function M.jump_down(opts)
  opts = opts or {}
  local wrap = opts.wrap ~= false -- default true

  -- If inside a block, find its close and search forward from there
  local open = current_block_open_row()
  local search_from = get_row()
  if open ~= 0 then
    local save = vim.api.nvim_win_get_cursor(0)
    vim.api.nvim_win_set_cursor(0, { open, 0 })
    local close = vim.fn.search(FENCE_CLOSE, "nW")
    vim.api.nvim_win_set_cursor(0, save)
		local last_line = vim.api.nvim_buf_line_count(0)
		if close ~= 0 then
			search_from = math.min(close + 1, last_line)
		end
  end

  local save = vim.api.nvim_win_get_cursor(0)
  vim.api.nvim_win_set_cursor(0, { search_from, 0 })
  local nxt = vim.fn.search(FENCE_OPEN, "nW")
  if nxt == 0 and wrap then
    vim.api.nvim_win_set_cursor(0, { 1, 0 })
    nxt = vim.fn.search(FENCE_OPEN, "cnW")
  end
  vim.api.nvim_win_set_cursor(0, save)

  if nxt == 0 then info("No code blocks found in this file.") return end
  set_row(nxt + 1)
end

-- Public: jump up to previous code cell (first line inside the fence)
function M.jump_up(opts)
  opts = opts or {}
  local wrap = opts.wrap ~= false -- default true

  local open = current_block_open_row()
  if open ~= 0 then
    local cur = get_row()
    -- If not at the first content line, go there first
    if cur > open + 1 then
      set_row(open + 1)
      return
    end
    -- Already at top of block — search backwards from before the opening fence
    local save = vim.api.nvim_win_get_cursor(0)
    vim.api.nvim_win_set_cursor(0, { math.max(open - 1, 1), 0 })
    local prev = vim.fn.search(FENCE_OPEN, "bnW")
    if prev == 0 and wrap then
      local last = vim.api.nvim_buf_line_count(0)
      vim.api.nvim_win_set_cursor(0, { last, 0 })
      prev = vim.fn.search(FENCE_OPEN, "bnW")
    end
    vim.api.nvim_win_set_cursor(0, save)
    if prev == 0 then info("No code blocks found in this file.") return end
    set_row(prev + 1)
    return
  end

  -- Not inside any block — just find the previous opening fence
  local save = vim.api.nvim_win_get_cursor(0)
  local prev = vim.fn.search(FENCE_OPEN, "bnW")
  if prev == 0 and wrap then
    local last = vim.api.nvim_buf_line_count(0)
    vim.api.nvim_win_set_cursor(0, { last, 0 })
    prev = vim.fn.search(FENCE_OPEN, "bnW")
  end
  vim.api.nvim_win_set_cursor(0, save)
  if prev == 0 then info("No code blocks found in this file.") return end
  set_row(prev + 1)
end

-------------------
-- Codecell running
-------------------

function M.run_cell(lang)
  lang = lang or "python"

  local range = current_block_range()
  if not range then
    info("Not inside a code cell.")
    return
  end

  local open_line = vim.api.nvim_buf_get_lines(0, range.open - 1, range.open, false)[1]
  if not open_line:match("^```{?" .. lang .. "}?%s*$") then
    info("Not inside a " .. lang .. " code cell.")
    return
  end

  local first = range.open + 1
  local last  = range.close - 1

  if first > last then
    info("Code cell is empty.")
    return
  end

  -- Set visual marks directly so MoltenEvaluateVisual knows what to evaluate
  vim.api.nvim_buf_set_mark(0, "<", first, 0, {})
  vim.api.nvim_buf_set_mark(0, ">", last, 0, {})
  vim.cmd("MoltenEvaluateVisual")
  vim.cmd("normal! zz")
end

return M
