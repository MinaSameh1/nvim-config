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
    'lua_ls',
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
local utils = require('config.lsp.utils')
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
    require('typescript-tools').setup({
      flags = { allow_incremental_sync = true, debounce_text_changes = 225 },
      go_to_source_definition = {
        fallback = true, -- fall back to standard LSP definition on failure
      },
      autoSetHints = true,
      format = false,
      noremap = true,
      silent = true,
      handlers = handlers,
      on_attach,
      capabilities = vim.lsp.protocol.make_client_capabilities(),
      commands = {
        Renamefile = {
          utils.rename_file,
          description = 'Rename file',
        },
      },
      settings = {
        publish_diagnostic_on = 'insert_leave',
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
      emmetCompletions = true,
    }
    lspconfig['tailwindcss'].setup(opts)
  end,
  ['intelephense'] = function()
    local opts = default_opts
    opts.settings = {
      intelephense = {
        stubs = {
          'bcmath',
          'bz2',
          'calendar',
          'Core',
          'curl',
          'zip',
          'zlib',
          'wordpress',
          'woocommerce',
          'acf-pro',
          'wordpress-globals',
          'wp-cli',
          'genesis',
          'polylang',
        },
      },
    }
    lspconfig['intelephense'].setup(opts)
  end,
  ['lua_ls'] = function()
    local opts = default_opts
    opts.settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = 'LuaJIT',
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { 'vim' },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file('', true),
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
      format = false, -- use stylua
    }
    lspconfig['lua_ls'].setup(opts)
  end,
})

-- for debugging
--[[ vim.lsp.set_log_level("debug") ]]
