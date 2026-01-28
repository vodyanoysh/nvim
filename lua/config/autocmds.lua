-- Autocommands

local augroup = vim.api.nvim_create_augroup("VodyanoyAutocmds", { clear = true })

-- Function to get current project name
local function get_project_name()
  local cwd = vim.fn.getcwd()
  return vim.fn.fnamemodify(cwd, ":t")
end

-- Auto-save Copilot Chat history on exit
vim.api.nvim_create_autocmd("VimLeavePre", {
  group = augroup,
  callback = function()
    -- Check if CopilotChat is loaded before trying to save
    local ok = pcall(vim.cmd, "CopilotChatSave " .. get_project_name())
    if not ok then
      -- Silently ignore if CopilotChat is not loaded
    end
  end,
  desc = "Сохранение истории чата Copilot при выходе",
})

-- Auto-load Copilot Chat history on enter
vim.api.nvim_create_autocmd("VimEnter", {
  group = augroup,
  callback = function()
    -- Delay loading to ensure CopilotChat has time to initialize
    vim.defer_fn(function()
      local ok = pcall(vim.cmd, "CopilotChatLoad " .. get_project_name())
      if not ok then
        -- Silently ignore if CopilotChat is not loaded
      end
    end, 1000)
  end,
  desc = "Загрузка истории чата Copilot при старте",
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function()
    vim.highlight.on_yank()
  end,
  desc = "Подсветка при копировании текста",
})

-- Resize splits when window is resized
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup,
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
  desc = "Автоматическое изменение размеров окон при ресайзе",
})

-- Close some filetypes with q
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = {
    "help",
    "qf",
    "query",
    "lspinfo",
    "man",
    "notify",
    "noice",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = event.buf, silent = true })
  end,
  desc = "Закрытие некоторых окон по q",
})
