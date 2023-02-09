local status_ok_lsp, lspconfig = pcall(require, 'lspconfig')
if not status_ok_lsp then
  vim.notify('Problem with lsp!')
  return
end

local status_ok_mason, mason = pcall(require, 'mason')
if not status_ok_mason then
  vim.notify('Problem with mason!')
  return
end

mason.setup({
  log_level = vim.log.levels.INFO,
  max_concurrent_installers = 2,
  ui = {
    -- Whether to automatically check for new versions when opening the :Mason window.
    check_outdated_packages_on_open = true,
  },
})

local status_ok_mason_lsp, mason_lspconfig = pcall(require, 'mason-lspconfig')
if not status_ok_mason_lsp then
  vim.notify('Problem with mason-lspconfig!')
  return
end

mason_lspconfig.setup({
  ensure_installed = {
    'tsserver',
    'kotlin_language_server',
    'jsonls',
    'dockerls',
    'pyright',
    'sumneko_lua',
    'yamlls',
    'ltex',
    'yamlls',
    'texlab',
    'clangd',
    'cssls',
    'sqlls',
    'marksman',
    'grammarly',
    'jdtls',
    'cmake',
  },
  automatic_installation = true,
})

local default_opts = require('config.lsp.default_opts').default_opts
local on_attach = require('config.lsp.default_opts').on_attach
local handlers = require('config.lsp.default_opts').handlers
local words = require('config.lsp.default_opts').words

mason_lspconfig.setup_handlers({
  function(server_name) -- default
    lspconfig[server_name].setup(default_opts)
  end,
  ['ltex'] = function()
    local opts = default_opts
    opts.settings = {
      ltex = {
        dictionary = {
          ['en-US'] = words,
        },
      },
    }
    lspconfig.ltex.setup(opts)
  end,
  ['eslint'] = function()
    local opts = default_opts
    opts.codeAction = {
      disableRuleComment = {
        location = 'separateLine',
      },
      showDocumentation = {
        enable = true,
      },
      format = false, -- Use Prettier using null-ls
      workingDirectory = {
        mode = 'location',
      },
    }
    lspconfig['eslint'].setup(opts)
  end,
  ['tsserver'] = function()
    vim.api.nvim_set_keymap(
      'n',
      '<Leader>xc',
      ':g/console.lo/d<cr>',
      { desc = 'Remove console.log' }
    )
    local opts = default_opts
    opts.format = false
    require('typescript').setup({
      disable_commands = false, -- prevent the plugin from creating Vim commands
      debug = false, -- enable debug logging for commands
      server = {
        flags = { allow_incremental_sync = true, debounce_text_changes = 225 },
        go_to_source_definition = {
          fallback = true, -- fall back to standard LSP definition on failure
        },
        settings = {
          tsserver = {
            diagnosticsDelay = '150ms',
            experimentalWatchedFileDelay = '100ms',
            perferences = {
              importModuleSpecifierEnding = 'minimal',
            },
          },
        },
        autoSetHints = true,
        format = false,
        noremap = true,
        silent = true,
        handlers = handlers,
        on_attach,
        capabilities = vim.lsp.protocol.make_client_capabilities(),
      },
    })
  end,
  ['rust_analyzer'] = function()
    -- Initialize the LSP via rust-tools instead
    require('rust-tools').setup({
      server = {
        on_attach,
        handlers = handlers,
        flags = {
          debounce_text_changes = 150,
        },
      },
    })
  end,
  ['clangd'] = function()
    local opts = default_opts
    opts.capabilities.offsetEncoding = { 'utf-16' } -- Fixes problem with clang
    lspconfig['clangd'].setup(opts)
  end,
  ['jdtls'] = function() end,
  ['tailwindcss'] = function()
    local opts = default_opts
    opts.settings = {
      emmetCompletions = true
    }
    lspconfig['tailwindcss'].setup(opts)
  end,
  ['sumneko_lua'] = function()
    local opts = default_opts
    opts.settings = {
      Lua = {
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { 'vim' },
        },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file('', true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
      format = false, -- use stylua
    }
    lspconfig['sumneko_lua'].setup(opts)
  end,
})

-- for debugging
--[[ vim.lsp.set_log_level("debug") ]]
