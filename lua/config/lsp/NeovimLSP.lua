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
    'pyright',
    'sumneko_lua',
    'yamlls',
    'ltex',
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
    require('typescript').setup({
      disable_commands = false, -- prevent the plugin from creating Vim commands
      debug = false, -- enable debug logging for commands
      go_to_source_definition = {
        fallback = true, -- fall back to standard LSP definition on failure
      },
      server = {
        autoSetHints = true,
        handlers = handlers,
        noremap = true,
        silent = true,
        on_attach = on_attach,
        format = false,
        flags = {
          debounce_text_changes = 150,
        },
        settings = {
          ltex = {
            dictionary = {
              ['en-US'] = words,
            },
          },
        },
        capabilities = vim.lsp.protocol.make_client_capabilities(),
      },
    })
  end,
  ['rust_analyzer'] = function()
    -- Initialize the LSP via rust-tools instead
    require('rust-tools').setup({
      server = {
        on_attach = on_attach,
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
