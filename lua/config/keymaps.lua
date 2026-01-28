-- Global keymaps (non-plugin-specific)

local map = vim.keymap.set

-- Better escape
map("i", "jj", "<Esc>", { desc = "Выйти из режима вставки" })

-- Save file
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Сохранить файл" })

-- Window navigation
map("n", "<C-h>", "<cmd>wincmd h<CR>", { desc = "Перейти к левому окну" })
map("n", "<C-j>", "<cmd>wincmd j<CR>", { desc = "Перейти к нижнему окну" })
map("n", "<C-k>", "<cmd>wincmd k<CR>", { desc = "Перейти к верхнему окну" })
map("n", "<C-l>", "<cmd>wincmd l<CR>", { desc = "Перейти к правому окну" })

-- Window splits
map("n", "|", "<cmd>vsplit<CR>", { desc = "Вертикальное разделение" })
map("n", "---", "<cmd>split<CR>", { desc = "Горизонтальное разделение" })

-- Window resize mode
map("n", "<leader>r", function()
  local status_msg = "РЕЖИМ ИЗМЕНЕНИЯ РАЗМЕРА ОКОН | h/l - ширина | j/k - высота | q/<Esc> - выход"
  vim.api.nvim_echo({ { status_msg, "WarningMsg" } }, false, {})

  local opts = { buffer = 0, silent = true }

  -- Resize mappings
  map("n", "h", "<cmd>vertical resize -5<CR>", opts)
  map("n", "l", "<cmd>vertical resize +5<CR>", opts)
  map("n", "j", "<cmd>resize +5<CR>", opts)
  map("n", "k", "<cmd>resize -5<CR>", opts)

  -- Fine-tune resize
  map("n", "H", "<cmd>vertical resize -1<CR>", opts)
  map("n", "L", "<cmd>vertical resize +1<CR>", opts)
  map("n", "J", "<cmd>resize +1<CR>", opts)
  map("n", "K", "<cmd>resize -1<CR>", opts)

  -- Exit resize mode
  local exit_func = function()
    pcall(vim.keymap.del, "n", "h", { buffer = 0 })
    pcall(vim.keymap.del, "n", "l", { buffer = 0 })
    pcall(vim.keymap.del, "n", "j", { buffer = 0 })
    pcall(vim.keymap.del, "n", "k", { buffer = 0 })
    pcall(vim.keymap.del, "n", "H", { buffer = 0 })
    pcall(vim.keymap.del, "n", "L", { buffer = 0 })
    pcall(vim.keymap.del, "n", "J", { buffer = 0 })
    pcall(vim.keymap.del, "n", "K", { buffer = 0 })
    pcall(vim.keymap.del, "n", "<Esc>", { buffer = 0 })
    pcall(vim.keymap.del, "n", "q", { buffer = 0 })
    vim.api.nvim_echo({ { "Режим изменения размера выключен", "Normal" } }, false, {})
  end

  map("n", "<Esc>", exit_func, opts)
  map("n", "q", exit_func, opts)
end, { desc = "Войти в режим изменения размеров окон" })

-- Clear search highlighting
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Убрать подсветку поиска" })

-- Better indenting
map("v", "<", "<gv", { desc = "Уменьшить отступ" })
map("v", ">", ">gv", { desc = "Увеличить отступ" })

-- Move lines up and down
map("n", "<A-j>", "<cmd>m .+1<CR>==", { desc = "Переместить строку вниз" })
map("n", "<A-k>", "<cmd>m .-2<CR>==", { desc = "Переместить строку вверх" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Переместить выделение вниз" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Переместить выделение вверх" })
