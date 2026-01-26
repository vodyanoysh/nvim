local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    { "phaazon/hop.nvim" },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
            "3rd/image.nvim",
        },
    },
    { "nvim-treesitter/nvim-treesitter" },
    { "neovim/nvim-lspconfig" },
    { "joshdick/onedark.vim" },
    { "rebelot/kanagawa.nvim" },
    { "decaycs/decay.nvim" },
    { "Mofiqul/vscode.nvim" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-cmdline" },
    { "hrsh7th/nvim-cmp" },
    { "williamboman/mason.nvim" },
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    { "github/copilot.vim" },
    { "jose-elias-alvarez/null-ls.nvim" },
    {
        "akinsho/bufferline.nvim",
        version = "*",
        dependencies = "nvim-tree/nvim-web-devicons",
    },
    { "terrortylor/nvim-comment" },
    { "lewis6991/gitsigns.nvim" },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {},
    },
    { "akinsho/toggleterm.nvim", version = "*", config = true },
    { "folke/which-key.nvim" },
    { "echasnovski/mini.nvim" },
    { "windwp/nvim-ts-autotag" },
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "rcarriga/nvim-dap-ui",
            "mfussenegger/nvim-dap-python",
            "theHamsta/nvim-dap-virtual-text",
        },
    },
    {
        "kristijanhusak/vim-dadbod-ui",
        dependencies = {
            { "tpope/vim-dadbod", lazy = true },
            {
                "kristijanhusak/vim-dadbod-completion",
                lazy = true,
                ft = { "sql", "plsql", "mysql", "sqlite", "mssql" },
            },
        },
        cmd = {
            "DBUI",
            "DBUIToggle",
            "DBUIAddConnection",
            "DBUIRenameConnection",
            "DBUIExecuteQuery",
            "DBUIFindBuffer",
        },
        init = function()
            vim.g.db_ui_win_position = "left"
            vim.g.db_ui_use_nerd_fonts = 1
            vim.g.db_ui_winwidth = 35
            vim.g.db_ui_save_location = os.getenv("HOME") .. "/Documents/sql"

            -- Настройки для форматирования вывода
            vim.g.db_ui_table_helpers = {
                sqlite = {
                    Describe = "PRAGMA table_info({table})",
                    Format = ".mode column\n.headers on",
                },
            }

            -- Настройки для автодополнения
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "sql", "mysql", "plsql" },
                callback = function()
                    require("cmp").setup.buffer({ sources = { { name = "vim-dadbod-completion" } } })
                end,
            })

            local db_connections_path = os.getenv("HOME") .. "/Documents/sql/.connections.lua"
            local ok, connections = pcall(dofile, db_connections_path)
            if ok then
                vim.g.dbs = connections
            end
        end,
    },

    {
        "numToStr/Comment.nvim",
        opts = {
            toggler = {
                line = "gcc",
                block = "gbc",
            },
            opleader = {
                line = "gc",
                block = "gb",
            },
        },
    },
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        dependencies = {
            { "github/copilot.vim" },
            { "nvim-lua/plenary.nvim", branch = "master" },
        },
        build = "make tiktoken",
        opts = {
            model = "claude-3.7-sonnet-thought",
            proxy = os.getenv("HTTP_PROXY"),
            history_path = vim.fn.stdpath("data") .. "/copilotchat_history",
            mappings = {
                reset = "<leader>cr", -- изменено с <C-l> на <leader>cr
            },

        },
    },
    {
        "stevearc/conform.nvim",
        opts = {
            formatters_by_ft = {
                javascript = { "prettier" },
                typescript = { "prettier" },
                python = { "black" },
                lua = { "stylua" },
                html = { "prettier" },
                htmldjango = { "prettier" },
                css = { "prettier" },
                json = { "prettier" },
            },
            formatters = {
                prettier = {
                    options = {
                        tab_width = 4,
                        print_width = 140,
                    },
                },
            },
        },
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {},
    },
    {
        "rmagatti/auto-session",
        lazy = false,
        opts = {
            suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
        },
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {},
    },
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            -- add any options here
        },
        dependencies = {
            -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
            "MunifTanjim/nui.nvim",
            -- OPTIONAL:
            --   `nvim-notify` is only needed, if you want to use the notification view.
            --   If not available, we use `mini` as the fallback
            "rcarriga/nvim-notify",
        },
    },
    {
        "j-hui/fidget.nvim",
        opts = {
            -- options
        },
    },
    {
        "sindrets/diffview.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
    }
})
