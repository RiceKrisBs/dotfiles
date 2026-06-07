local launch_cwd = vim.fs.normalize(vim.uv.cwd() or vim.fn.getcwd())
local launch_name = vim.fs.basename(launch_cwd)

local function path_relative_to_launch(path)
  local normalized = vim.fs.normalize(path)

  if normalized == launch_cwd then
    return launch_name
  end

  local prefix = launch_cwd .. "/"
  if vim.startswith(normalized, prefix) then
    return launch_name .. "/" .. normalized:sub(#prefix + 1)
  end

  return vim.fn.fnamemodify(normalized, ":~:.")
end

local function oil_path(buffer_name)
  if not vim.startswith(buffer_name, "oil://") then
    return nil
  end

  local ok, path = pcall(vim.uri_to_fname, buffer_name:gsub("^oil://", "file://"))
  if ok then
    return path
  end

  return buffer_name:gsub("^oil://", "")
end

local function relative_buffer_name()
  local buffer_name = vim.api.nvim_buf_get_name(0)

  if buffer_name == "" then
    return "[No Name]"
  end

  local path = oil_path(buffer_name) or buffer_name
  return path_relative_to_launch(path)
end

return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      delay = 350,
      spec = {
        { "<leader>b", group = "buffers" },
        { "<leader>c", group = "code" },
        { "<leader>f", group = "find" },
        { "<leader>g", group = "git" },
        { "<leader>h", group = "hunks" },
        { "<leader>t", group = "terminal" },
        { "<leader>x", group = "lists" },
      },
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Show buffer keymaps",
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        icons_enabled = false,
        theme = "auto",
        component_separators = "|",
        section_separators = "",
      },
      sections = {
        lualine_c = {
          {
            relative_buffer_name,
            color = { gui = "bold" },
          },
        },
      },
    },
  },
}
