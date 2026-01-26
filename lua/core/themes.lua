vim.opt.termguicolors = true

function set_theme(theme)
    vim.cmd.colorscheme(theme)
end

set_theme("vscode")
-- set_theme("onedark")