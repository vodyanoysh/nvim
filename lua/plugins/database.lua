-- Database management with vim-dadbod

return {
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
    keys = {
      { "<leader>dd", "<cmd>DBUIToggle<CR>", desc = "Переключить Database UI" },
    },
    init = function()
      vim.g.db_ui_win_position = "left"
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_winwidth = 35
      vim.g.db_ui_save_location = os.getenv("HOME") .. "/Documents/sql"

      -- Table helpers
      vim.g.db_ui_table_helpers = {
        sqlite = {
          Describe = "PRAGMA table_info({table})",
          Format = ".mode column\n.headers on",
        },
      }

      -- Auto-completion setup for SQL files
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "sql", "mysql", "plsql" },
        callback = function()
          require("cmp").setup.buffer({ sources = { { name = "vim-dadbod-completion" } } })
        end,
      })

      -- Load database connections
      local db_connections_path = os.getenv("HOME") .. "/Documents/sql/.connections.lua"
      local ok, connections = pcall(dofile, db_connections_path)
      if ok then
        vim.g.dbs = connections
      end
    end,
  },
}
