-- Vim options configuration

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Indentation
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.smartindent = true

-- Line wrapping
vim.opt.wrap = false

-- Mouse support
vim.opt.mouse = "a"
vim.opt.mousefocus = true

-- Clipboard integration
vim.opt.clipboard = "unnamedplus"

-- Shell
vim.opt.shell = "/bin/fish"

-- True color support
vim.opt.termguicolors = true

-- Appearance
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true

-- Splits
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Scrolling
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

-- Persistent undo
vim.opt.undofile = true
vim.opt.undolevels = 10000

-- Update time
vim.opt.updatetime = 200
vim.opt.timeoutlen = 300

-- Completion
vim.opt.completeopt = "menu,menuone,noselect"
