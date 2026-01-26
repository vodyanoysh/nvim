require("mason").setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  },
  ensure_installed = { "pyright", "gopls" },
  automatic_installation = true,
})
