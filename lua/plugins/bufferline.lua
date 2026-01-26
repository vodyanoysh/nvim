require("bufferline").setup {
    options = {
        buffer_close_icon = '',
        mode = 'buffers',
        offsets = {
            {
                filetype = "neo-tree",
                text = "File Explorer",
                separator = true,
                padding = 1
            }
        },
        diagnostics = "nvim_lsp",
        indicator = {
            icon = '  ', -- this should be omitted if indicator style is not 'icon'
            style = 'icon'
        },
        -- separator_style = "slope"
    }
}

-- Функция для закрытия всех буферов
local function close_all_buffers()
    local buffers = vim.api.nvim_list_bufs()
    for _, buffer in ipairs(buffers) do
        if vim.api.nvim_buf_is_valid(buffer) and vim.api.nvim_buf_get_option(buffer, 'buflisted') then
            vim.api.nvim_buf_delete(buffer, { force = false })
        end
    end
end

-- Маппинг на leader + ca для закрытия всех буферов
vim.keymap.set('n', '<leader>ca', close_all_buffers, { noremap = true, silent = true, desc = "Закрыть все буферы" })

