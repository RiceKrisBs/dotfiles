return {
  {
    "stevearc/oil.nvim",
    lazy = false,
    dependencies = {
      { "nvim-mini/mini.icons", opts = {} },
    },
    keys = {
      { "-", "<cmd>Oil<CR>", desc = "Open parent directory" },
      { "<leader>e", "<cmd>Oil<CR>", desc = "Open file explorer" },
    },
    opts = {
      default_file_explorer = true,
      skip_confirm_for_simple_edits = true,
      watch_for_changes = true,
      view_options = {
        show_hidden = true,
      },
      keymaps = {
        ["q"] = "actions.close",
        ["<C-s>"] = "actions.select_vsplit",
        ["<C-h>"] = "actions.select_split",
      },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
    },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Live grep" },
      { "<leader>fw", "<cmd>Telescope grep_string<CR>", desc = "Find word under cursor" },
      { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Find buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Find help" },
      { "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Recent files" },
      { "<leader>fd", "<cmd>Telescope diagnostics<CR>", desc = "Find diagnostics" },
      { "<leader>fk", "<cmd>Telescope keymaps<CR>", desc = "Find keymaps" },
      { "<C-p>", "<cmd>Telescope git_files<CR>", desc = "Find git files" },
    },
    opts = {
      defaults = {
        mappings = {
          i = {
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
          },
        },
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)

      pcall(telescope.load_extension, "fzf")
    end,
  },
}
