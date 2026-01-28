-- Editor plugins

return {
  -- Neo-tree file explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>e", "<cmd>Neotree float toggle<CR>", desc = "Файловый менеджер" },
      { "<leader>gg", "<cmd>Neotree float git_status toggle<CR>", desc = "Статус Git" },
    },
    opts = {
      close_if_last_window = true,
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = true,
      window = {
        position = "float",
        width = 40,
      },
      filesystem = {
        follow_current_file = {
          enabled = true,
        },
        use_libuv_file_watcher = true,
      },
    },
  },

  -- Telescope fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Найти файлы" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Поиск в файлах" },
      { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Найти буфер" },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Справка" },
      { "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Недавние файлы" },
      { "<leader>fw", "<cmd>Telescope grep_string<CR>", desc = "Найти слово под курсором" },
      { "<leader>gb", "<cmd>Telescope git_branches<CR>", desc = "Git ветки" },
      { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "Git коммиты" },
      { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "Git статус" },
    },
    config = function()
      -- Fix telescope treesitter preview errors by wrapping in pcall
      local previewers = require("telescope.previewers")
      local putils = require("telescope.previewers.utils")

      -- Wrap ts_highlighter to handle errors gracefully
      local ts_highlighter_original = putils.ts_highlighter
      putils.ts_highlighter = function(...)
        local ok, result = pcall(ts_highlighter_original, ...)
        if ok then
          return result
        else
          -- Fallback to no highlighting on error
          return nil
        end
      end

      local telescope = require("telescope")

      telescope.setup({
        defaults = {
          prompt_prefix = "   ",
          selection_caret = " ",
          path_display = { "smart" },
          file_ignore_patterns = { ".git/", "node_modules/" },
          mappings = {
            i = {
              ["<C-j>"] = "move_selection_next",
              ["<C-k>"] = "move_selection_previous",
            },
          },
        },
        pickers = {
          find_files = {
            hidden = true,
          },
        },
      })
    end,
  },

  -- Git signs
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      { "<leader>gb", "<cmd>Gitsigns toggle_current_line_blame<CR>", desc = "Git Blame" },
      { "]h", "<cmd>Gitsigns next_hunk<CR>", desc = "Следующее изменение" },
      { "[h", "<cmd>Gitsigns prev_hunk<CR>", desc = "Предыдущее изменение" },
      { "<leader>gp", "<cmd>Gitsigns preview_hunk<CR>", desc = "Просмотр изменения" },
      { "<leader>gr", "<cmd>Gitsigns reset_hunk<CR>", desc = "Сбросить изменение" },
    },
    opts = {
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      },
      current_line_blame = false,
      current_line_blame_opts = {
        delay = 300,
      },
    },
  },

  -- Diffview for git diffs
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>dvo", "<cmd>DiffviewOpen<CR>", desc = "Открыть Diffview" },
      { "<leader>dvc", "<cmd>DiffviewClose<CR>", desc = "Закрыть Diffview" },
    },
    opts = {},
  },
}
