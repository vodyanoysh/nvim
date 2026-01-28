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

-- Shell (use fish if available, otherwise fallback to bash)
local shell = vim.fn.executable("fish") == 1 and "/bin/fish" or "/bin/bash"
vim.opt.shell = shell

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

-- Suppress annoying file info messages when switching buffers
vim.opt.shortmess:append("F") -- Don't show file info when opening
vim.opt.shortmess:append("I") -- Don't show intro message
vim.opt.shortmess:append("W") -- Don't show "written" message
vim.opt.shortmess:append("a") -- Use abbreviations in messages (filnxtToO)
vim.opt.shortmess:append("c") -- Don't show completion messages

-- Suppress annoying warnings
local notify = vim.notify
vim.notify = function(msg, level, opts)
  -- Filter out position_encoding warning
  if type(msg) == "string" and msg:match("position_encoding") then
    return
  end
  -- Filter out vim.deprecated warnings from third-party plugins
  if type(msg) == "string" and msg:match("vim%.deprecated") then
    return
  end
  if type(msg) == "string" and msg:match("vim%.str_utfindex is deprecated") then
    return
  end
  if type(msg) == "string" and msg:match("vim%.validate is deprecated") then
    return
  end
  notify(msg, level, opts)
end

-- Disable deprecation warnings from third-party plugins
-- This prevents vim.deprecated from showing warnings in :checkhealth
vim.g.deprecation_warnings = false
