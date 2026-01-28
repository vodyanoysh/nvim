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

-- Setup treesitter and LSP semantic highlighting for better colors
vim.api.nvim_create_autocmd("ColorScheme", {
  group = augroup,
  callback = function()
    -- Enhanced Treesitter highlights (VSCode-like colors)
    -- Methods and function calls
    vim.api.nvim_set_hl(0, "@function.call", { fg = "#dcdcaa" })
    vim.api.nvim_set_hl(0, "@method.call", { fg = "#dcdcaa" })
    vim.api.nvim_set_hl(0, "@function.method.call", { fg = "#dcdcaa" })

    -- Variables and parameters
    vim.api.nvim_set_hl(0, "@variable", { fg = "#9cdcfe" })
    vim.api.nvim_set_hl(0, "@parameter", { fg = "#9cdcfe" })
    vim.api.nvim_set_hl(0, "@variable.parameter", { fg = "#9cdcfe" })

    -- Properties and attributes
    vim.api.nvim_set_hl(0, "@property", { fg = "#9cdcfe" })
    vim.api.nvim_set_hl(0, "@field", { fg = "#9cdcfe" })
    vim.api.nvim_set_hl(0, "@attribute", { fg = "#9cdcfe" })

    -- Constants
    vim.api.nvim_set_hl(0, "@constant", { fg = "#4fc1ff" })
    vim.api.nvim_set_hl(0, "@constant.builtin", { fg = "#569cd6" })

    -- Types and classes
    vim.api.nvim_set_hl(0, "@type", { fg = "#4ec9b0" })
    vim.api.nvim_set_hl(0, "@type.builtin", { fg = "#4ec9b0" })
    vim.api.nvim_set_hl(0, "@constructor", { fg = "#4ec9b0" })

    -- Keywords
    vim.api.nvim_set_hl(0, "@keyword", { fg = "#c586c0" })
    vim.api.nvim_set_hl(0, "@keyword.function", { fg = "#c586c0" })
    vim.api.nvim_set_hl(0, "@keyword.return", { fg = "#c586c0" })

    -- Strings and characters
    vim.api.nvim_set_hl(0, "@string", { fg = "#ce9178" })
    vim.api.nvim_set_hl(0, "@string.escape", { fg = "#d7ba7d" })

    -- Numbers
    vim.api.nvim_set_hl(0, "@number", { fg = "#b5cea8" })
    vim.api.nvim_set_hl(0, "@float", { fg = "#b5cea8" })

    -- Comments
    vim.api.nvim_set_hl(0, "@comment", { fg = "#6a9955", italic = true })

    -- Operators
    vim.api.nvim_set_hl(0, "@operator", { fg = "#d4d4d4" })
    vim.api.nvim_set_hl(0, "@punctuation.bracket", { fg = "#ffd700" })
    vim.api.nvim_set_hl(0, "@punctuation.delimiter", { fg = "#d4d4d4" })

    -- LSP Semantic Token highlights
    vim.api.nvim_set_hl(0, "@lsp.type.method", { fg = "#dcdcaa" })
    vim.api.nvim_set_hl(0, "@lsp.type.function", { fg = "#dcdcaa" })
    vim.api.nvim_set_hl(0, "@lsp.type.variable", { fg = "#9cdcfe" })
    vim.api.nvim_set_hl(0, "@lsp.type.parameter", { fg = "#9cdcfe" })
    vim.api.nvim_set_hl(0, "@lsp.type.property", { fg = "#9cdcfe" })
    vim.api.nvim_set_hl(0, "@lsp.type.class", { fg = "#4ec9b0" })
    vim.api.nvim_set_hl(0, "@lsp.type.namespace", { fg = "#4ec9b0" })

  end,
  desc = "Настройка улучшенных Treesitter и LSP highlights",
})

-- Apply immediately for current colorscheme
vim.api.nvim_set_hl(0, "@function.call", { fg = "#dcdcaa" })
vim.api.nvim_set_hl(0, "@method.call", { fg = "#dcdcaa" })
vim.api.nvim_set_hl(0, "@function.method.call", { fg = "#dcdcaa" })
vim.api.nvim_set_hl(0, "@variable", { fg = "#9cdcfe" })
vim.api.nvim_set_hl(0, "@parameter", { fg = "#9cdcfe" })
vim.api.nvim_set_hl(0, "@property", { fg = "#9cdcfe" })
vim.api.nvim_set_hl(0, "@field", { fg = "#9cdcfe" })
vim.api.nvim_set_hl(0, "@constant", { fg = "#4fc1ff" })
vim.api.nvim_set_hl(0, "@type", { fg = "#4ec9b0" })
vim.api.nvim_set_hl(0, "@constructor", { fg = "#4ec9b0" })
vim.api.nvim_set_hl(0, "@keyword", { fg = "#c586c0" })
vim.api.nvim_set_hl(0, "@string", { fg = "#ce9178" })
vim.api.nvim_set_hl(0, "@number", { fg = "#b5cea8" })
vim.api.nvim_set_hl(0, "@comment", { fg = "#6a9955", italic = true })
vim.api.nvim_set_hl(0, "@operator", { fg = "#d4d4d4" })
vim.api.nvim_set_hl(0, "@punctuation.bracket", { fg = "#ffd700" })
vim.api.nvim_set_hl(0, "@lsp.type.method", { fg = "#dcdcaa" })
vim.api.nvim_set_hl(0, "@lsp.type.function", { fg = "#dcdcaa" })
vim.api.nvim_set_hl(0, "@lsp.type.variable", { fg = "#9cdcfe" })
vim.api.nvim_set_hl(0, "@lsp.type.property", { fg = "#9cdcfe" })
vim.api.nvim_set_hl(0, "@lsp.type.class", { fg = "#4ec9b0" })

-- Setup nvim-cmp highlight groups for VSCode-like appearance
vim.api.nvim_create_autocmd("ColorScheme", {
  group = augroup,
  callback = function()
    -- Completion menu colors (VSCode-like)
    vim.api.nvim_set_hl(0, "CmpNormal", { bg = "#1e1e1e", fg = "#cccccc" })
    vim.api.nvim_set_hl(0, "CmpBorder", { bg = "#1e1e1e", fg = "#454545" })
    vim.api.nvim_set_hl(0, "CmpSelection", { bg = "#094771", fg = "#ffffff" })

    -- Documentation window colors
    vim.api.nvim_set_hl(0, "CmpDocNormal", { bg = "#252526", fg = "#cccccc" })
    vim.api.nvim_set_hl(0, "CmpDocBorder", { bg = "#252526", fg = "#454545" })

    -- Item kind highlights (for icons)
    vim.api.nvim_set_hl(0, "CmpItemAbbrDeprecated", { fg = "#808080", strikethrough = true })
    vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { fg = "#569cd6", bold = true })
    vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { fg = "#569cd6", bold = true })

    -- Item kind colors (VSCode-like)
    vim.api.nvim_set_hl(0, "CmpItemKindVariable", { fg = "#9cdcfe" })
    vim.api.nvim_set_hl(0, "CmpItemKindInterface", { fg = "#9cdcfe" })
    vim.api.nvim_set_hl(0, "CmpItemKindText", { fg = "#9cdcfe" })
    vim.api.nvim_set_hl(0, "CmpItemKindFunction", { fg = "#c586c0" })
    vim.api.nvim_set_hl(0, "CmpItemKindMethod", { fg = "#c586c0" })
    vim.api.nvim_set_hl(0, "CmpItemKindKeyword", { fg = "#d4d4d4" })
    vim.api.nvim_set_hl(0, "CmpItemKindProperty", { fg = "#9cdcfe" })
    vim.api.nvim_set_hl(0, "CmpItemKindUnit", { fg = "#d4d4d4" })

    -- Ghost text (VSCode-like gray suggestion)
    vim.api.nvim_set_hl(0, "CmpGhostText", { fg = "#6a6a6a", italic = true })
  end,
  desc = "Настройка цветов nvim-cmp в стиле VSCode",
})

-- Apply immediately for current colorscheme
vim.api.nvim_set_hl(0, "CmpNormal", { bg = "#1e1e1e", fg = "#cccccc" })
vim.api.nvim_set_hl(0, "CmpBorder", { bg = "#1e1e1e", fg = "#454545" })
vim.api.nvim_set_hl(0, "CmpSelection", { bg = "#094771", fg = "#ffffff" })
vim.api.nvim_set_hl(0, "CmpDocNormal", { bg = "#252526", fg = "#cccccc" })
vim.api.nvim_set_hl(0, "CmpDocBorder", { bg = "#252526", fg = "#454545" })
vim.api.nvim_set_hl(0, "CmpItemAbbrDeprecated", { fg = "#808080", strikethrough = true })
vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { fg = "#569cd6", bold = true })
vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { fg = "#569cd6", bold = true })
vim.api.nvim_set_hl(0, "CmpItemKindVariable", { fg = "#9cdcfe" })
vim.api.nvim_set_hl(0, "CmpItemKindInterface", { fg = "#9cdcfe" })
vim.api.nvim_set_hl(0, "CmpItemKindText", { fg = "#9cdcfe" })
vim.api.nvim_set_hl(0, "CmpItemKindFunction", { fg = "#c586c0" })
vim.api.nvim_set_hl(0, "CmpItemKindMethod", { fg = "#c586c0" })
vim.api.nvim_set_hl(0, "CmpItemKindKeyword", { fg = "#d4d4d4" })
vim.api.nvim_set_hl(0, "CmpItemKindProperty", { fg = "#9cdcfe" })
vim.api.nvim_set_hl(0, "CmpItemKindUnit", { fg = "#d4d4d4" })
vim.api.nvim_set_hl(0, "CmpGhostText", { fg = "#6a6a6a", italic = true })
