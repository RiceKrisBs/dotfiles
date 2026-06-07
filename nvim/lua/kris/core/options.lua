local opt = vim.opt

opt.number = true
opt.relativenumber = true

opt.mouse = "a"
opt.showmode = false
opt.clipboard = "unnamedplus"

opt.breakindent = true
opt.undofile = true
opt.swapfile = false
opt.backup = false
opt.writebackup = false

opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true

opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.colorcolumn = "100"

opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

opt.wrap = false
opt.linebreak = true
opt.list = true
opt.listchars = { tab = "> ", trail = ".", nbsp = "+" }

opt.splitright = true
opt.splitbelow = true
opt.termguicolors = true
opt.confirm = true
opt.updatetime = 250
opt.timeoutlen = 500
opt.completeopt = { "menu", "menuone", "noselect" }
opt.inccommand = "split"

if vim.fn.has("nvim-0.11") == 1 then
  opt.winborder = "rounded"
end
