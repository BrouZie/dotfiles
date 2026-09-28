return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local ts = require("nvim-treesitter")

    -- Guard: on first install the build step hasn't run yet
    if not ts.install then
      vim.notify(
        "nvim-treesitter: restart Neovim and run :TSUpdate to finish setup.",
        vim.log.levels.WARN
      )
      return
    end

    ts.setup()

    local parsers = {
      "bash", "c", "cpp", "python",
      "markdown", "markdown_inline", "html", -- html for comments/tags inside markdown
      "lua", "luadoc", "vim", "vimdoc", "query", "diff",
    }

    ts.install(parsers)

    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "bash", "sh", "c", "cpp", "python", "markdown",
        "lua", "vim", "diff", "html",
      },
      callback = function()
        vim.treesitter.start()
      end,
    })
  end,
}
