local augroup = vim.api.nvim_create_augroup("CustomAutocmds", { clear = true })

-- Функция для получения имени текущего проекта
local function get_project_name()
  local cwd = vim.fn.getcwd()
  return vim.fn.fnamemodify(cwd, ":t")
end

-- Автоматическое сохранение истории Copilot Chat
vim.api.nvim_create_autocmd("VimLeavePre", {
  group = augroup,
  callback = function() vim.cmd("silent! CopilotChatSave " .. get_project_name()) end,
  desc = "Сохранение истории чата Copilot при выходе",
})

-- Автоматическая загрузка истории Copilot Chat при старте
vim.api.nvim_create_autocmd("VimEnter", {
  group = augroup,
  callback = function() vim.cmd("silent! CopilotChatLoad " .. get_project_name()) end,
  desc = "Загрузка истории чата Copilot при старте",
})

