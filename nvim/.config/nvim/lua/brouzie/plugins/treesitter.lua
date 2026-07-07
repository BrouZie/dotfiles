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
      "bash", "lua", "diff", "html", "luadoc", "query",
      "markdown", "markdown_inline", "python", "go",
      "vimdoc", "c", "cpp", "r", "sql",
    }

    ts.install(parsers)

    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "bash", "sh", "lua", "diff", "html", "markdown",
        "python", "go", "c", "cpp", "r", "sql", "vim",
      },
      callback = function()
        vim.treesitter.start()
      end,
    })
  end,
}
