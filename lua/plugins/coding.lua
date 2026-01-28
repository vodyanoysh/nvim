-- Coding plugins (completion, copilot, etc.)

return {
  -- nvim-cmp for completion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
    },
    config = function()
      local cmp = require("cmp")

      cmp.setup({
        snippet = {
          expand = function(args)
            -- Minimal snippet support - just insert the text
            vim.snippet.expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = false }), -- Don't auto-select first item
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
        }),
        formatting = {
          format = function(entry, vim_item)
            vim_item.menu = ({
              nvim_lsp = "[LSP]",
              buffer = "[Buffer]",
              path = "[Path]",
            })[entry.source.name]
            return vim_item
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
      })

      -- Setup cmdline completion
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
          { name = "cmdline" },
        }),
      })

      -- Setup search completion
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })
    end,
  },

  -- GitHub Copilot
  {
    "github/copilot.vim",
    event = "InsertEnter",
    config = function()
      -- Disable default Tab mapping (we handle it in cmp)
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true

      -- Alternative accept key
      vim.keymap.set("i", "<C-J>", 'copilot#Accept("\\<CR>")', {
        expr = true,
        replace_keycodes = false,
        desc = "Принять предложение Copilot",
      })
    end,
  },

  -- Copilot Chat
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "github/copilot.vim" },
      { "nvim-lua/plenary.nvim", branch = "master" },
    },
    cmd = { "CopilotChat", "CopilotChatOpen", "CopilotChatToggle" },
    keys = {
      { "<leader>bb", "<cmd>CopilotChatToggle<CR>", desc = "Переключить CopilotChat" },
      { "<leader>bq", "<cmd>CopilotChatClose<CR>", desc = "Закрыть CopilotChat" },
      { "<leader>be", "<cmd>CopilotChatExplain<CR>", desc = "Объяснить код", mode = { "n", "v" } },
      { "<leader>br", "<cmd>CopilotChatReview<CR>", desc = "Проверить код", mode = { "n", "v" } },
      { "<leader>bf", "<cmd>CopilotChatFix<CR>", desc = "Исправить код", mode = { "n", "v" } },
      { "<leader>bo", "<cmd>CopilotChatOptimize<CR>", desc = "Оптимизировать код", mode = { "n", "v" } },
    },
    opts = {
      model = "claude-3.7-sonnet-thought",
      proxy = os.getenv("HTTP_PROXY"),
      history_path = vim.fn.stdpath("data") .. "/copilotchat_history",
      mappings = {
        reset = "<leader>cr",
      },
    },
  },
}
