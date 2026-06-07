return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        mode = { "n", "v" },
        desc = "Format buffer",
      },
    },
    opts = {
      notify_on_error = true,
      notify_no_formatters = false,
      format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end

        return {
          timeout_ms = 1000,
          lsp_format = "fallback",
        }
      end,
      formatters_by_ft = {
        bash = { "shfmt" },
        css = { "prettierd", "prettier", stop_after_first = true },
        go = { "goimports", "gofmt", stop_after_first = true },
        gomod = { "gofmt" },
        gotmpl = { "gofmt" },
        graphql = { "prettierd", "prettier", stop_after_first = true },
        hcl = { "hcl" },
        html = { "prettierd", "prettier", stop_after_first = true },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
        json = { "prettierd", "prettier", stop_after_first = true },
        lua = { "stylua" },
        markdown = { "prettierd", "prettier", stop_after_first = true },
        python = { "ruff_format", "black", stop_after_first = true },
        sh = { "shfmt" },
        sql = { "sql_formatter" },
        terraform = { "terraform_fmt" },
        ["terraform-vars"] = { "terraform_fmt" },
        toml = { "taplo" },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        yaml = { "prettierd", "prettier", stop_after_first = true },
        ["yaml.ansible"] = { "prettierd", "prettier", stop_after_first = true },
        ["yaml.docker-compose"] = { "prettierd", "prettier", stop_after_first = true },
        ["yaml.helm-values"] = { "prettierd", "prettier", stop_after_first = true },
        ["_"] = { "trim_whitespace" },
      },
    },
    config = function(_, opts)
      require("conform").setup(opts)

      vim.api.nvim_create_user_command("FormatDisable", function(args)
        if args.bang then
          vim.b.disable_autoformat = true
        else
          vim.g.disable_autoformat = true
        end
      end, {
        bang = true,
        desc = "Disable format on save. Use ! for this buffer only.",
      })

      vim.api.nvim_create_user_command("FormatEnable", function()
        vim.b.disable_autoformat = false
        vim.g.disable_autoformat = false
      end, {
        desc = "Enable format on save",
      })
    end,
  },
}
