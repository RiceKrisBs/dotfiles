return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy",
    dependencies = {
      "mason-org/mason.nvim",
    },
    opts = {
      ensure_installed = {
        "black",
        "goimports",
        "hclfmt",
        "prettierd",
        "shellcheck",
        "shfmt",
        "sql-formatter",
        "stylua",
      },
      auto_update = false,
      run_on_start = true,
      start_delay = 3000,
      debounce_hours = 24,
    },
    config = function(_, opts)
      require("mason-tool-installer").setup(opts)
    end,
  },
}
