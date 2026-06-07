local map = vim.keymap.set

local function current_file_path()
  local path = vim.api.nvim_buf_get_name(0)

  if path == "" then
    vim.notify("Current buffer has no file path.", vim.log.levels.WARN)
    return nil
  end

  return vim.fs.normalize(path)
end

local function repo_root_for(path)
  local git_dir = vim.fs.find(".git", {
    path = vim.fs.dirname(path),
    upward = true,
  })[1]

  if git_dir then
    return vim.fs.dirname(git_dir)
  end

  return nil
end

local function relative_path(path, root)
  local prefix = root .. "/"

  if vim.startswith(path, prefix) then
    return path:sub(#prefix + 1)
  end

  return vim.fn.fnamemodify(path, ":~:.")
end

local function copy_to_clipboard(value, label)
  vim.fn.setreg("+", value)
  vim.notify("Copied " .. label .. ": " .. value)
end

map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

map("n", "<Up>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
map("n", "<Down>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
map("n", "<Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })

map("n", "[b", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "]b", "<cmd>bnext<CR>", { desc = "Next buffer" })

map("n", "<C-d>", "<C-d>zz", { desc = "Page down and center" })
map("n", "<C-u>", "<C-u>zz", { desc = "Page up and center" })
map("n", "n", "nzzzv", { desc = "Next search result and center" })
map("n", "N", "Nzzzv", { desc = "Previous search result and center" })

map("n", "<leader>yp", function()
  local path = current_file_path()
  if not path then
    return
  end

  local root = repo_root_for(path)
  local copied = root and relative_path(path, root) or vim.fn.fnamemodify(path, ":~:.")

  copy_to_clipboard(copied, "path")
end, { desc = "Yank repo-relative path" })

map("n", "<leader>yn", function()
  local path = current_file_path()
  if not path then
    return
  end

  copy_to_clipboard(vim.fn.fnamemodify(path, ":t"), "filename")
end, { desc = "Yank filename" })

map("v", "<", "<gv", { desc = "Indent left and keep selection" })
map("v", ">", ">gv", { desc = "Indent right and keep selection" })
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
