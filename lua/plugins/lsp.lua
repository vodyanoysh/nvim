local lspconfig = require("lspconfig")
local capabilities = require('cmp_nvim_lsp').default_capabilities()


-- Python
lspconfig.pyright.setup({
    settings = {
      python = {
        analysis = {
          typeCheckingMode = "off",          -- Режим строгой проверки типов
          autoImportCompletions = true,      -- Автодополнение для импортов
          diagnosticMode = "workspace",      -- Анализирует сразу весь проект
          useLibraryCodeForTypes = true,     -- Учитывает типы из внешних библиотек
        },
      },
    },
  })

-- Golang
lspconfig.gopls.setup({
  capabilities = capabilities, -- Добавляем capabilities здесь
  settings = {
    gopls = {
      usePlaceholders = true,
      completeUnimported = true,
    },
  },
})

lspconfig.ts_ls.setup({
  settings = {
    typescript = {
      preferences = {
        importModuleSpecifierPreference = "non-relative",
      },
    },
  },
})

lspconfig.html.setup({
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
})

lspconfig.cssls.setup({
  settings = {
    css = {
      validate = true,
    },
  },
})

lspconfig.volar.setup({
  settings = {
    vetur = {
      completion = {
        autoImport = true,
        tagCasing = "kebab",
      },
    },
  },
})


vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        local opts = {buffer = ev.buf}
        -- vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        -- vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        -- vim.keymap
        --     .set('n', '<Leader>sa', vim.lsp.buf.add_workspace_folder, opts)
        -- vim.keymap.set('n', '<Leader>sr', vim.lsp.buf.remove_workspace_folder,
        --                opts)
        -- vim.keymap.set('n', '<Leader>sl', function()
        --     print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        -- end, opts)
        -- vim.keymap.set('n', '<Leader>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<Leader>lr', vim.lsp.buf.rename, opts, { desc = "Rename" })
        vim.keymap.set({'n', 'v'}, '<Leader>la', vim.lsp.buf.code_action, opts, { desc = "Code action" })
        -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<Leader>lf',
                       function() vim.lsp.buf.format {async = true} end, opts, { desc = "Format" })
    end
})
