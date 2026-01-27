-- Terminal configuration (AstroNvim-inspired)

return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = { "ToggleTerm", "TermExec" },
    keys = {
      { "<C-\\>", "<cmd>ToggleTerm<CR>", desc = "Переключить терминал", mode = { "n", "t" } },
      { "<leader>tf", "<cmd>ToggleTerm direction=float<CR>", desc = "Плавающий терминал" },
      { "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", desc = "Горизонтальный терминал" },
      { "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>", desc = "Вертикальный терминал" },
      { "<leader>tl", function() _LAZYGIT_TOGGLE() end, desc = "Lazygit" },
      { "<leader>tp", function() _PYTHON_TOGGLE() end, desc = "Python REPL" },
      { "<leader>tn", function() _NODE_TOGGLE() end, desc = "Node REPL" },
      { "<leader>tu", function() _BTOP_TOGGLE() end, desc = "Btop (мониторинг системы)" },
    },
    opts = {
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
      open_mapping = [[<C-\>]],
      hide_numbers = true,
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      terminal_mappings = true,
      persist_size = true,
      persist_mode = true,
      direction = "float",
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = {
        border = "curved",
        winblend = 0,
      },
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)

      local Terminal = require("toggleterm.terminal").Terminal

      -- Lazygit terminal
      local lazygit = Terminal:new({
        cmd = "lazygit",
        direction = "float",
        float_opts = {
          border = "curved",
        },
        hidden = true,
        on_open = function(term)
          vim.cmd("startinsert!")
          vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
        end,
      })

      function _LAZYGIT_TOGGLE()
        lazygit:toggle()
      end

      -- Python REPL
      local python = Terminal:new({
        cmd = "python3",
        direction = "float",
        hidden = true,
        on_open = function(term)
          vim.cmd("startinsert!")
        end,
      })

      function _PYTHON_TOGGLE()
        python:toggle()
      end

      -- Node REPL
      local node = Terminal:new({
        cmd = "node",
        direction = "float",
        hidden = true,
        on_open = function(term)
          vim.cmd("startinsert!")
        end,
      })

      function _NODE_TOGGLE()
        node:toggle()
      end

      -- Btop (system monitor)
      local btop = Terminal:new({
        cmd = "btop",
        direction = "float",
        hidden = true,
        on_open = function(term)
          vim.cmd("startinsert!")
          vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
        end,
      })

      function _BTOP_TOGGLE()
        btop:toggle()
      end

      -- Terminal keymaps
      function _G.set_terminal_keymaps()
        local opts = { buffer = 0 }
        vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
        vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
        vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
        vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
        vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
      end

      vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

      -- Send commands to terminal
      vim.api.nvim_create_user_command("TermSendCurrentLine", function()
        local line = vim.api.nvim_get_current_line()
        require("toggleterm").send_lines_to_terminal("single_line", true, { args = vim.v.count })
      end, { range = true, desc = "Отправить текущую строку в терминал" })

      vim.api.nvim_create_user_command("TermSendVisualLines", function()
        require("toggleterm").send_lines_to_terminal("visual_lines", true, { args = vim.v.count })
      end, { range = true, desc = "Отправить выделенные строки в терминал" })

      -- Additional keymaps for sending code to terminal
      vim.keymap.set("n", "<leader>ts", "<cmd>TermSendCurrentLine<CR>", { desc = "Отправить строку в терминал" })
      vim.keymap.set("v", "<leader>ts", "<cmd>TermSendVisualLines<CR>", { desc = "Отправить выделение в терминал" })
    end,
  },
}
