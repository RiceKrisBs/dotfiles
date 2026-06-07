local augroup = vim.api.nvim_create_augroup("kris.core", { clear = true })

local function set_filetype(filetype)
  return function()
    vim.bo.filetype = filetype
  end
end

vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
  desc = "Highlight yanked text",
})

vim.api.nvim_create_autocmd("VimResized", {
  group = augroup,
  command = "tabdo wincmd =",
  desc = "Resize splits when the terminal size changes",
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "markdown", "text", "gitcommit" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
  desc = "Use prose-friendly settings for text buffers",
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = "python",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
  desc = "Use Python's conventional four-space indentation",
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup,
  pattern = {
    "compose.yaml",
    "compose.yml",
    "docker-compose.yaml",
    "docker-compose.yml",
    "*.compose.yaml",
    "*.compose.yml",
  },
  callback = set_filetype("yaml.docker-compose"),
  desc = "Detect Docker Compose files",
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup,
  pattern = {
    "*/templates/*.yaml",
    "*/templates/*.yml",
    "*/templates/*.tpl",
  },
  callback = set_filetype("helm"),
  desc = "Detect Helm templates",
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup,
  pattern = {
    "values.yaml",
    "values.yml",
    "values.*.yaml",
    "values.*.yml",
  },
  callback = set_filetype("yaml.helm-values"),
  desc = "Detect Helm values files",
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup,
  pattern = {
    "playbook.yaml",
    "playbook.yml",
    "site.yaml",
    "site.yml",
    "*/playbooks/*.yaml",
    "*/playbooks/*.yml",
    "*/roles/*/tasks/*.yaml",
    "*/roles/*/tasks/*.yml",
    "*/roles/*/handlers/*.yaml",
    "*/roles/*/handlers/*.yml",
    "*/roles/*/defaults/*.yaml",
    "*/roles/*/defaults/*.yml",
    "*/roles/*/vars/*.yaml",
    "*/roles/*/vars/*.yml",
    "*/group_vars/*.yaml",
    "*/group_vars/*.yml",
    "*/host_vars/*.yaml",
    "*/host_vars/*.yml",
  },
  callback = set_filetype("yaml.ansible"),
  desc = "Detect Ansible YAML files",
})
