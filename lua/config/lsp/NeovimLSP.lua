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
    opts.settings = {
      publish_diagnostic_on = 'insert_leave',
      -- WARNING: Experimental feature also in VSCode, because it might hit performance of server.
      -- possible values: ("off"|"all"|"implementations_only"|"references_only")
      code_lens = 'all',
      tsserver_file_preferences = {
        --[[ * If enabled, completions for class members (e.g. methods and properties) will include ]]
        --[[ * a whole declaration for the member. ]]
        --[[ * E.g., `class A { f| }` could be completed to `class A { foo(): number {} }`, instead of ]]
        --[[ * `class A { foo }`. ]]
        includeCompletionsWithClassMemberSnippets = true,
        --[[ * If enabled, object literal methods will have a method declaration completion entry in addition ]]
        --[[ * to the regular completion entry containing just the method name. ]]
        --[[ * E.g., `const objectLiteral: T = { f| }` could be completed to `const objectLiteral: T = { foo(): void {} }`, ]]
        --[[ * in addition to `const objectLiteral: T = { foo }`. ]]
        includeCompletionsWithObjectLiteralMethodSnippets = true,
        --[[ * Enables auto-import-style completions on partially-typed import statements. E.g., allows ]]
        --[[ * `import write|` to be completed to `import { writeFile } from "fs"`. ]]
        includeCompletionsForImportStatements = true,
        generateReturnInDocTemplate = true,
        -- inlay hints
        includeInlayParameterNameHints = 'literal',
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayVariableTypeHintsWhenTypeMatchesName = false,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    }

    opts.flags = {
      allow_incremental_sync = true,
      debounce_text_changes = 225,
    }
    opts.go_to_source_definition = {
      fallback = true, -- fall back to standard LSP definition on failure
    }

    require('typescript-tools').setup(opts)
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
          checkThirdParty = false,
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
        hint = { enable = true },
      },
      format = false, -- use stylua
    }
    lspconfig['lua_ls'].setup(opts)
  end,
})

-- for debugging
--[[ vim.lsp.set_log_level("debug") ]]
