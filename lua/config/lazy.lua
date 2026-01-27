-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- Import all plugin specs from lua/plugins/
    { import = "plugins" },
  },
  defaults = {
    lazy = false,
    version = false,
  },
  checker = { enabled = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

-- Load remaining config modules
require("config.options")
require("config.keymaps")
require("config.autocmds")
