require("toggleterm").setup({
    open_mapping = [[<A-t>]], -- Клавиша для открытия терминала
    size = 20,
    shade_terminals = true,
    shading_factor = 2,
    direction = "float", -- или "horizontal", "vertical", "tab", "float"
    float_opts = {
        border = "curved" -- или "single", "double", "shadow" и т.д.
    }
})

