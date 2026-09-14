local servers = {
  "ansiblels",
  "bashls",
  "cssls",
  "docker_compose_language_service",
  "dockerls",
  "eslint",
  "gopls",
  "graphql",
  "helm_ls",
  "html",
  "jsonls",
  "lua_ls",
  "marksman",
  "pyright",
  "ruff",
  "ruby_lsp",
  "rust_analyzer",
  "sorbet",
  "sqlls",
  "taplo",
  "terraformls",
  "tflint",
  "ts_ls",
  "yamlls",
}

local external_servers = { "gopls", "ruby_lsp", "sorbet", "ruff", "rust_analyzer" }

local mason_servers = vim.tbl_filter(function(server)
  return not vim.tbl_contains(external_servers, server)
end, servers)

local function diagnostic_jump(count)
  return function()
    if vim.diagnostic.jump then
      vim.diagnostic.jump({ count = count, float = true })
    elseif count < 0 then
      vim.diagnostic.goto_prev()
    else
      vim.diagnostic.goto_next()
    end
  end
end

local function telescope_or_lsp(picker, fallback)
  return function()
    local ok, builtin = pcall(require, "telescope.builtin")
    if ok then
      builtin[picker]()
    else
      fallback()
    end
  end
end

local function sorbet_root(bufnr, on_dir)
  local filename = vim.api.nvim_buf_get_name(bufnr)
  local dir = filename ~= "" and vim.fs.dirname(filename) or vim.uv.cwd()

  while dir do
    local sorbet_config = vim.fs.joinpath(dir, "sorbet", "config")

    if vim.uv.fs_stat(sorbet_config) then
      on_dir(dir)
      return
    end

    local parent = vim.fs.dirname(dir)
    if parent == dir then
      return
    end

    dir = parent
  end
end

local function disable_capabilities(client, capabilities)
  for _, capability in ipairs(capabilities) do
    client.server_capabilities[capability] = nil
  end
end

local server_commands = {
  gopls = "gopls",
  ruff = "ruff",
  ruby_lsp = "ruby-lsp",
  rust_analyzer = "rust-analyzer",
}

local function should_enable(server)
  local command = server_commands[server]

  if command then
    return vim.fn.executable(command) == 1
  end

  return true
end

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

      for _, server in ipairs(servers) do
        vim.lsp.config(server, {
          capabilities = capabilities,
        })
      end

      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
              },
            },
          },
        },
      })

      vim.lsp.config("ruby_lsp", {
        capabilities = capabilities,
        init_options = {
          formatter = "auto",
        },
      })

      vim.lsp.config("sorbet", {
        capabilities = capabilities,
        cmd = { "bundle", "exec", "srb", "tc", "--lsp" },
        root_dir = sorbet_root,
      })

      vim.lsp.config("yamlls", {
        capabilities = capabilities,
        settings = {
          yaml = {
            keyOrdering = false,
            schemaStore = {
              enable = true,
            },
            customTags = {
              "!reference sequence",
            },
          },
        },
      })

      vim.lsp.config("ruff", {
        capabilities = capabilities,
        init_options = {
          settings = {
            lineLength = 100,
          },
        },
      })

      vim.lsp.config("rust_analyzer", {
        capabilities = capabilities,
        settings = {
          ["rust-analyzer"] = {
            check = {
              command = "clippy",
            },
          },
        },
      })

      vim.lsp.config("tflint", {
        capabilities = capabilities,
        init_options = {
          args = {},
        },
      })

      vim.diagnostic.config({
        severity_sort = true,
        virtual_text = {
          spacing = 2,
          prefix = "*",
        },
        float = {
          border = "rounded",
          source = true,
        },
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("kris.lsp", { clear = true }),
        callback = function(event)
          local client = event.data and vim.lsp.get_client_by_id(event.data.client_id)

          if client and vim.tbl_contains({ "ts_ls", "eslint" }, client.name) then
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end

          if client and client.name == "sorbet" then
            disable_capabilities(client, {
              "codeActionProvider",
              "completionProvider",
              "declarationProvider",
              "definitionProvider",
              "documentFormattingProvider",
              "documentHighlightProvider",
              "documentRangeFormattingProvider",
              "documentSymbolProvider",
              "hoverProvider",
              "implementationProvider",
              "inlayHintProvider",
              "referencesProvider",
              "renameProvider",
              "semanticTokensProvider",
              "signatureHelpProvider",
              "typeDefinitionProvider",
              "typeHierarchyProvider",
              "workspaceSymbolProvider",
            })
          end

          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, {
              buffer = event.buf,
              desc = "LSP: " .. desc,
            })
          end

          map("n", "gd", telescope_or_lsp("lsp_definitions", vim.lsp.buf.definition), "Go to definition")
          map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
          map("n", "gr", telescope_or_lsp("lsp_references", vim.lsp.buf.references), "Find references")
          map("n", "gI", telescope_or_lsp("lsp_implementations", vim.lsp.buf.implementation), "Go to implementation")
          map("n", "<leader>D", telescope_or_lsp("lsp_type_definitions", vim.lsp.buf.type_definition), "Type definition")
          map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
          map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("n", "K", vim.lsp.buf.hover, "Hover documentation")
          map({ "n", "i" }, "<C-k>", vim.lsp.buf.signature_help, "Signature help")
        end,
        desc = "Configure LSP keymaps",
      })

      vim.keymap.set("n", "[d", diagnostic_jump(-1), { desc = "Previous diagnostic" })
      vim.keymap.set("n", "]d", diagnostic_jump(1), { desc = "Next diagnostic" })
      vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })
      vim.keymap.set("n", "<leader>cq", vim.diagnostic.setloclist, { desc = "Diagnostics to location list" })

      for _, server in ipairs(servers) do
        if should_enable(server) then
          vim.lsp.enable(server)
        end
      end
    end,
  },
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    opts = {
      PATH = "append",
      ui = {
        border = "rounded",
      },
    },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = mason_servers,
      automatic_enable = false,
    },
  },
}
