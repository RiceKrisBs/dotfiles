local languages = {
  "bash",
  "c",
  "css",
  "dockerfile",
  "go",
  "gomod",
  "gosum",
  "gotmpl",
  "gowork",
  "graphql",
  "hcl",
  "helm",
  "html",
  "javascript",
  "json",
  "lua",
  "markdown",
  "markdown_inline",
  "python",
  "query",
  "regex",
  "ruby",
  "rust",
  "sql",
  "terraform",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "yaml",
}

local filetypes = {
  "bash",
  "c",
  "css",
  "dockerfile",
  "go",
  "gomod",
  "gosum",
  "gotmpl",
  "gowork",
  "graphql",
  "hcl",
  "helm",
  "html",
  "javascript",
  "javascriptreact",
  "json",
  "lua",
  "markdown",
  "python",
  "query",
  "regex",
  "ruby",
  "rust",
  "sql",
  "terraform",
  "terraform-vars",
  "toml",
  "typescript",
  "typescriptreact",
  "vim",
  "vimdoc",
  "yaml",
  "yaml.ansible",
  "yaml.docker-compose",
  "yaml.helm-values",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local treesitter = require("nvim-treesitter")

      treesitter.setup({
        install_dir = vim.fn.stdpath("data") .. "/site",
      })

      vim.treesitter.language.register("yaml", {
        "yaml.ansible",
        "yaml.docker-compose",
        "yaml.helm-values",
      })

      treesitter.install(languages)

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("kris.treesitter", { clear = true }),
        pattern = filetypes,
        callback = function()
          pcall(vim.treesitter.start)
        end,
        desc = "Enable Treesitter highlighting",
      })
    end,
  },
}
