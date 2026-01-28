-- Theme plugins

return {
  -- VSCode theme (default)
  {
    "Mofiqul/vscode.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = false,
      italic_comments = true,
      disable_nvimtree_bg = false,
      -- Enable treesitter syntax highlighting
      group_overrides = {},
    },
    config = function(_, opts)
      local vscode = require("vscode")
      vscode.setup(opts)
      vscode.load()

      -- Ensure treesitter is enabled after theme loads
      vim.defer_fn(function()
        if vim.fn.exists(":TSEnable") > 0 then
          vim.cmd("TSEnable highlight")
        end
      end, 100)
    end,
  },

  -- Kanagawa theme
  {
    "rebelot/kanagawa.nvim",
    lazy = true,
    opts = {
      theme = "wave",
      background = {
        dark = "wave",
        light = "lotus",
      },
    },
  },

  -- Decay theme
  {
    "decaycs/decay.nvim",
    lazy = true,
    name = "decay",
  },
}
