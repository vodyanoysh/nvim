-- Core plugins

return {
  -- Treesitter for syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,
    priority = 900,
    config = function()
      local ok, treesitter_configs = pcall(require, "nvim-treesitter.configs")
      if not ok then
        vim.notify("nvim-treesitter.configs not found. Run :TSUpdate", vim.log.levels.WARN)
        return
      end

      treesitter_configs.setup({
        ensure_installed = {
          "bash",
          "c",
          "css",
          "go",
          "html",
          "javascript",
          "json",
          "lua",
          "markdown",
          "markdown_inline",
          "python",
          "query",
          "regex",
          "sql",
          "typescript",
          "vim",
          "vimdoc",
          "vue",
          "yaml",
        },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = false,
            node_decremental = "<bs>",
          },
        },
      })
    end,
  },

  -- Auto pairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true,
      ts_config = {
        lua = { "string" },
        javascript = { "template_string" },
      },
    },
  },

  -- Auto tag (HTML/JSX)
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    opts = {},
  },

  -- Hop (easy motion)
  {
    "phaazon/hop.nvim",
    cmd = { "HopWord", "HopLine", "HopChar1", "HopChar2" },
    keys = {
      { "<leader>hw", "<cmd>HopWord<CR>", desc = "Прыжок к слову" },
      { "<leader>hl", "<cmd>HopLine<CR>", desc = "Прыжок к строке" },
      { "<leader>hc", "<cmd>HopChar1<CR>", desc = "Прыжок к символу" },
    },
    config = function()
      require("hop").setup()
    end,
  },

  -- Comments
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
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

  -- Mini.nvim (various utilities)
  {
    "echasnovski/mini.nvim",
    event = "VeryLazy",
    config = function()
      -- Add any mini.nvim modules here
    end,
  },
}
