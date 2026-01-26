require("nvim-treesitter.configs").setup({
    ensure_installed = {
        "lua",
        "go",
        "typescript",
        "javascript",
        "json",
        "yaml",
        "html",
        "css",
        "bash",
        "python",
    },

    sync_install = false,
    auto_install = true,
    highlight = {
        enable = true,
    },
})