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
      "onsails/lspkind.nvim", -- VSCode-like pictograms
    },
    config = function()
      local cmp = require("cmp")
      local lspkind = require("lspkind")

      cmp.setup({
        snippet = {
          expand = function(args)
            -- Minimal snippet support - just insert the text
            vim.snippet.expand(args.body)
          end,
        },
        completion = {
          autocomplete = { require("cmp.types").cmp.TriggerEvent.TextChanged },
        },
        experimental = {
          ghost_text = {
            hl_group = "CmpGhostText",
          },
        },
        sorting = {
          priority_weight = 2,
          comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            cmp.config.compare.locality,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Auto-select first item
          -- Use arrow keys for navigation (default preset.insert includes this)
          ["<Up>"] = cmp.mapping.select_prev_item(),
          ["<Down>"] = cmp.mapping.select_next_item(),
          -- Tab confirms selection (like Enter)
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.confirm({ select = true })
            elseif vim.snippet.active({ direction = 1 }) then
              vim.snippet.jump(1)
            else
              fallback() -- Insert tab character if no completion
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if vim.snippet.active({ direction = -1 }) then
              vim.snippet.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp", priority = 1000 },
          { name = "buffer", priority = 500 },
          { name = "path", priority = 250 },
        }),
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text", -- show only symbol annotations
            maxwidth = 50, -- prevent the popup from showing more than provided characters
            ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead
            show_labelDetails = true, -- show labelDetails in menu
            before = function(entry, vim_item)
              -- Source name with nice icons
              vim_item.menu = ({
                nvim_lsp = "[LSP]",
                buffer = "[Buf]",
                path = "[Path]",
                cmdline = "[Cmd]",
              })[entry.source.name]
              return vim_item
            end,
          }),
        },
        window = {
          completion = cmp.config.window.bordered({
            border = "rounded",
            winhighlight = "Normal:CmpNormal,FloatBorder:CmpBorder,CursorLine:CmpSelection,Search:None",
          }),
          documentation = cmp.config.window.bordered({
            border = "rounded",
            winhighlight = "Normal:CmpDocNormal,FloatBorder:CmpDocBorder",
          }),
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
