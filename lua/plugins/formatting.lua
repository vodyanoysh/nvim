-- Formatting with conform.nvim

return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>fc",
        function()
          require("conform").format({ bufnr = 0 })
        end,
        desc = "Форматировать буфер",
      },
    },
    opts = {
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        vue = { "prettier" },
        python = { "black" },
        lua = { "stylua" },
        html = { "prettier" },
        htmldjango = { "prettier" },
        css = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
      },
      formatters = {
        prettier = {
          prepend_args = {
            "--tab-width=4",
            "--print-width=140",
          },
        },
      },
      format_on_save = false, -- Disable auto-format on save by default
    },
  },
}
