local function current_directory()
  local ok, oil = pcall(require, "oil")
  if ok then
    local oil_dir = oil.get_current_dir()
    if oil_dir then
      return vim.fs.normalize(oil_dir)
    end
  end

  local buffer_name = vim.api.nvim_buf_get_name(0)
  if buffer_name ~= "" then
    local path = vim.fs.normalize(buffer_name)
    local stat = vim.uv.fs_stat(path)

    if stat and stat.type == "directory" then
      return path
    end

    return vim.fs.dirname(path)
  end

  return vim.fn.getcwd()
end

local function git_root_for(path)
  local result = vim.system({
    "git",
    "-C",
    path,
    "rev-parse",
    "--show-toplevel",
  }, { text = true }):wait()

  if result.code ~= 0 then
    return nil
  end

  return vim.fs.normalize(vim.trim(result.stdout or ""))
end

local function open_oil_git_root()
  local root = git_root_for(current_directory())

  if not root or root == "" then
    vim.notify("Not inside a Git repo.", vim.log.levels.WARN)
    return
  end

  require("oil").open(root)
end

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
    config = function(_, opts)
      require("oil").setup(opts)

      vim.api.nvim_create_user_command("OilGitRoot", open_oil_git_root, {
        desc = "Open Oil at the current Git repo root",
      })
    end,
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
        ["gr"] = {
          callback = open_oil_git_root,
          desc = "Open git root",
          mode = "n",
        },
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
