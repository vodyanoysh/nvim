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
    },
    config = function(_, opts)
      require("vscode").setup(opts)
      vim.cmd.colorscheme("vscode")
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
