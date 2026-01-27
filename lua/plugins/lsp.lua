-- LSP Configuration (LazyVim-inspired)

return {
  -- Mason for LSP/DAP/linter installer
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    keys = {
      { "<leader>cm", "<cmd>Mason<CR>", desc = "Mason" },
    },
    opts = {
      ensure_installed = {
        "pyright",
        "gopls",
        "typescript-language-server",
        "html-lsp",
        "css-lsp",
        "vue-language-server",
        "stylua",
        "black",
        "prettier",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          -- Trigger FileType event to possibly load this newly installed LSP server
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)
      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end
      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },

  -- Mason-LSPConfig bridge
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "mason.nvim" },
    opts = {
      automatic_installation = true,
    },
  },

  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    opts = {
      -- Global diagnostic configuration
      diagnostics = {
        underline = true,
        virtual_text = true,
        signs = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded",
          source = "always",
        },
      },
      -- Diagnostic signs
      signs = {
        { name = "DiagnosticSignError", text = "" },
        { name = "DiagnosticSignWarn", text = "" },
        { name = "DiagnosticSignHint", text = "" },
        { name = "DiagnosticSignInfo", text = "" },
      },
      -- LSP servers configuration
      servers = {
        -- Python
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "off",
                autoImportCompletions = true,
                diagnosticMode = "workspace",
                useLibraryCodeForTypes = true,
              },
            },
          },
        },
        -- Go
        gopls = {
          settings = {
            gopls = {
              usePlaceholders = true,
              completeUnimported = true,
              analyses = {
                unusedparams = true,
              },
              staticcheck = true,
            },
          },
        },
        -- TypeScript/JavaScript
        ts_ls = {
          settings = {
            typescript = {
              preferences = {
                importModuleSpecifierPreference = "non-relative",
              },
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayFunctionParameterTypeHints = true,
              },
            },
            javascript = {
              preferences = {
                importModuleSpecifierPreference = "non-relative",
              },
            },
          },
        },
        -- HTML
        html = {
          settings = {
            html = {
              suggest = {
                completion = {
                  enabled = true,
                  emmet = true,
                },
              },
            },
          },
        },
        -- CSS
        cssls = {
          settings = {
            css = {
              validate = true,
            },
          },
        },
        -- Vue
        volar = {
          settings = {
            vetur = {
              completion = {
                autoImport = true,
                tagCasing = "kebab",
              },
            },
          },
        },
      },
    },
    config = function(_, opts)
      -- Setup diagnostics
      vim.diagnostic.config(opts.diagnostics)

      -- Setup diagnostic signs
      for _, sign in ipairs(opts.signs) do
        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
      end

      -- Change underline style from curly to straight
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = function()
          -- Change from undercurl to underline for diagnostics
          vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { underline = true, sp = "Red" })
          vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { underline = true, sp = "Orange" })
          vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { underline = true, sp = "Blue" })
          vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { underline = true, sp = "Green" })
        end,
      })

      -- Apply immediately for current colorscheme
      vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { underline = true, sp = "Red" })
      vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { underline = true, sp = "Orange" })
      vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { underline = true, sp = "Blue" })
      vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { underline = true, sp = "Green" })

      -- Get capabilities
      local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      if not ok_cmp then
        vim.notify("cmp_nvim_lsp not available yet", vim.log.levels.WARN)
        return
      end
      local capabilities = cmp_lsp.default_capabilities()

      -- Setup each server
      local ok_lspconfig, lspconfig = pcall(require, "lspconfig")
      if not ok_lspconfig then
        vim.notify("lspconfig not available yet", vim.log.levels.WARN)
        return
      end

      for server, server_opts in pairs(opts.servers) do
        -- Check if server config exists
        local ok_server = pcall(function()
          return lspconfig[server]
        end)

        if ok_server and lspconfig[server] then
          server_opts.capabilities = capabilities
          local setup_ok, err = pcall(lspconfig[server].setup, server_opts)
          if not setup_ok then
            vim.notify(
              string.format("Failed to setup LSP server '%s': %s", server, err),
              vim.log.levels.WARN
            )
          end
        end
      end

      -- LSP attach autocommand for keymaps
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
        callback = function(ev)
          -- Enable completion triggered by <c-x><c-o>
          vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

          local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, desc = desc })
          end

          -- Navigation
          map("n", "gd", "<cmd>Telescope lsp_definitions<CR>", "Перейти к определению")
          map("n", "gD", "<cmd>Telescope lsp_implementations<CR>", "Перейти к реализации")
          map("n", "gr", "<cmd>Telescope lsp_references<CR>", "Найти использования")
          map("n", "gy", "<cmd>Telescope lsp_type_definitions<CR>", "Перейти к типу")
          map("n", "K", vim.lsp.buf.hover, "Показать документацию")
          map("n", "gK", vim.lsp.buf.signature_help, "Показать сигнатуру")

          -- LSP actions
          map("n", "<leader>lr", vim.lsp.buf.rename, "Переименовать")
          map({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, "Действия кода")
          map("n", "<leader>lf", function()
            vim.lsp.buf.format({ async = true })
          end, "Форматировать")

          -- Diagnostics
          map("n", "<leader>le", function()
            local config = vim.diagnostic.config()
            vim.diagnostic.config({
              virtual_text = not config.virtual_text,
            })
            local state = config.virtual_text and "отключена" or "включена"
            vim.notify("Диагностика в строке " .. state, vim.log.levels.INFO)
          end, "Переключить диагностику в строке")

          map("n", "<leader>lc", function()
            local line = vim.fn.line(".")
            local diagnostics = vim.diagnostic.get(0, { lnum = line - 1 })

            if #diagnostics == 0 then
              vim.notify("На этой строке нет диагностических сообщений", vim.log.levels.WARN)
              return
            end

            local messages = {}
            for _, diagnostic in ipairs(diagnostics) do
              local prefix = ""
              if diagnostic.severity == vim.diagnostic.severity.ERROR then
                prefix = "[ОШИБКА] "
              elseif diagnostic.severity == vim.diagnostic.severity.WARN then
                prefix = "[ПРЕДУПРЕЖДЕНИЕ] "
              elseif diagnostic.severity == vim.diagnostic.severity.INFO then
                prefix = "[ИНФО] "
              elseif diagnostic.severity == vim.diagnostic.severity.HINT then
                prefix = "[ПОДСКАЗКА] "
              end
              table.insert(messages, prefix .. diagnostic.message)
            end

            local full_message = table.concat(messages, "\n")
            vim.fn.setreg("+", full_message)
            vim.notify("Диагностическое сообщение скопировано", vim.log.levels.INFO)
          end, "Копировать текст ошибки")

          map("n", "]d", vim.diagnostic.goto_next, "Следующая ошибка")
          map("n", "[d", vim.diagnostic.goto_prev, "Предыдущая ошибка")
          map("n", "<leader>ld", vim.diagnostic.open_float, "Показать диагностику")
        end,
      })
    end,
  },
}
