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
    'json-lsp',
    'pyright',
    'sumneko_lua',
    'yamlls',
    'ltex',
    'texlab',
    'clangd',
    'cssls',
    'sqlls',
    'marksman',
    'grammerly',
    'jdtls',
    'cmake',
  },
  automatic_installation = true,
})

local mapOpts = { noremap = true, silent = true }

-- document_highlight
local function lsp_highlight_document(client, bufnr)
    vim.cmd([[
      hi! LspReferenceRead cterm=underline ctermbg=red gui=underline guibg=#24283b
      hi! LspReferenceText cterm=underline ctermbg=red guibg=#24283b
      hi! LspReferenceWrite cterm=underline ctermbg=red  guibg=#24283b
    ]])
    vim.api.nvim_create_augroup('lsp_document_highlight', {
      clear = false,
    })
    vim.api.nvim_clear_autocmds({
      buffer = bufnr,
      group = 'lsp_document_highlight',
    })
    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      group = 'lsp_document_highlight',
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd('CursorMoved', {
      group = 'lsp_document_highlight',
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  require('aerial').on_attach(client, bufnr)

  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end

  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  require('vim.lsp.protocol').CompletionItemKind = {
    '', -- Text
    '', -- Method
    '', -- Function
    '', -- Constructor
    '', -- Field
    '', -- Variable
    '', -- Class
    'ﰮ', -- Interface
    '', -- Module
    '', -- Property
    '', -- Unit
    '', -- Value
    '', -- Enum
    '', -- Keyword
    '﬌', -- Snippet
    '', -- Color
    '', -- File
    '', -- Reference
    '', -- Folder
    '', -- EnumMember
    '', -- Constant
    '', -- Struct
    '', -- Event
    'ﬦ', -- Operator
    '', -- TypeParameter
  }

  -- Mappings.
  -- Mappings for Trouble
  buf_set_keymap('n', '<leader>xx', '<cmd>TroubleToggle<cr>', mapOpts)
  buf_set_keymap(
    'n',
    '<leader>xw',
    '<cmd>Trouble workspace_diagnostics<cr>',
    mapOpts
  )
  buf_set_keymap(
    'n',
    '<leader>xd',
    '<cmd>Trouble document_diagnostics<cr>',
    mapOpts
  )
  buf_set_keymap('n', '<leader>xl', '<cmd>Trouble loclist<cr>', mapOpts)
  buf_set_keymap('n', '<leader>xq', '<cmd>Trouble quickfix<cr>', mapOpts)
  buf_set_keymap('n', 'gr', '<cmd>Trouble lsp_references<cr>', mapOpts)
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', mapOpts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', mapOpts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', mapOpts)
  buf_set_keymap(
    'n',
    'gi',
    '<cmd>lua vim.lsp.buf.implementation()<CR>',
    mapOpts
  )
  buf_set_keymap(
    'n',
    '<C-k>',
    '<cmd>lua vim.lsp.buf.signature_help()<CR>',
    mapOpts
  )
  buf_set_keymap(
    'n',
    '<leader>Wa',
    '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>',
    mapOpts
  )
  buf_set_keymap(
    'n',
    '<leader>Wr',
    '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>',
    mapOpts
  )
  buf_set_keymap(
    'n',
    '<leader>Wl',
    '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>',
    mapOpts
  )
  buf_set_keymap(
    'n',
    '<leader>gt',
    '<cmd>lua vim.lsp.buf.type_definition()<CR>',
    mapOpts
  )
  buf_set_keymap(
    'n',
    '<leader>rn',
    '<cmd>lua vim.lsp.buf.rename()<CR>',
    mapOpts
  )
  buf_set_keymap(
    'n',
    '<leader>ca',
    '<cmd>Telescope lsp_code_actions theme=cursor<CR>',
    mapOpts
  )
  buf_set_keymap(
    'v',
    '<leader>ca',
    "<cmd>'<,'>lua vim.lsp.buf.range_code_action()<CR>",
    mapOpts
  )
  buf_set_keymap(
    'n',
    '<leader>I',
    "<cmd>lua require('nvim-lsp-installer.extras.tsserver').organize_imports(bufname)<CR>",
    mapOpts
  )
  -- buf_set_keymap('n', 'gr',         '<cmd>lua vim.lsp.buf.references()<CR>',                                 mapOpts)
  buf_set_keymap(
    'n',
    '<leader>e',
    '<cmd>lua vim.diagnostic.open_float({ border = "rounded" })<CR>',
    mapOpts
  )
  buf_set_keymap(
    'n',
    '[c',
    '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>',
    mapOpts
  )
  buf_set_keymap(
    'n',
    ']c',
    '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>',
    mapOpts
  )
  buf_set_keymap(
    'n',
    '<leader>q',
    '<cmd>lua vim.diagnostic.setloclist()<CR>',
    mapOpts
  )
  buf_set_keymap(
    'n',
    '<leader>f',
    '<cmd>lua vim.lsp.buf.format { async = true }<CR>',
    mapOpts
  )
  buf_set_keymap(
    'n',
    '<leader>fs',
    [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]],
    mapOpts
  )

  vim.cmd([[
  " Lightblub for code action
  autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()
  " Adds the commands to nvim
  command! LspCodeAction execute 'lua vim.lsp.buf.code_action()'
  command! LspFormat execute 'lua vim.lsp.buf.format { async = true }'
  ]])
  -- AutoFormat on save
  if client.server_capabilities.documentFormattingProvider then
    vim.cmd([[
      augroup lsp_format_on_save
      autocmd! * <buffer>
      autocmd BufWritePre <buffer> lua vim.lsp.buf.format { async = true }
      augroup END
      ]])
  end

  -- Highlight used words
  if client.server_capabilities.documentHighlightProvider then
    lsp_highlight_document(client, bufnr)
  end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  vim.api.nvim_create_autocmd('CursorHold', {
    buffer = bufnr,
    callback = function()
      local opts = {
        focusable = false,
        close_events = {
          'BufLeave',
          'CursorMoved',
          'InsertEnter',
          'FocusLost',
        },
        border = 'rounded',
        source = 'always',
        prefix = ' ',
        scope = 'cursor',
      }
      vim.diagnostic.open_float(nil, opts)
    end,
  })
end

-- Set the signs to this
local signs = {
  { name = 'DiagnosticSignError', text = '' },
  { name = 'DiagnosticSignWarn', text = '' },
  { name = 'DiagnosticSignHint', text = '' },
  { name = 'DiagnosticSignInfo', text = '' },
}

for _, sign in ipairs(signs) do
  vim.fn.sign_define(
    sign.name,
    { texthl = sign.name, text = sign.text, numhl = '' }
  )
end

vim.diagnostic.config({
  float = { source = 'always' },
  underline = true,
  signs = true,
  severity_sort = true,
  virtual_text = {
    prefix = '●',
  },
})

local path = vim.fn.stdpath('config') .. '/spell/en.utf-8.add'
local words = {}

for word in io.open(path, 'r'):lines() do
  table.insert(words, word)
end

-- Default settings
-- local border = {
-- {"╭", "FloatBorder"},
-- {"─", "FloatBorder"},
-- {"╮", "FloatBorder"},
-- {"│", "FloatBorder"},
-- {"╯", "FloatBorder"},
-- {"─", "FloatBorder"},
-- {"╰", "FloatBorder"},
-- {"│", "FloatBorder"},
-- }

local handlers = {
  ['textDocument/hover'] = vim.lsp.with(
    vim.lsp.handlers.hover,
    { border = 'rounded' }
  ),
  ['textDocument/signatureHelp'] = vim.lsp.with(
    vim.lsp.handlers.signature_help,
    { border = 'rounded' }
  ),
  ['textDocument/publishDiagnostics'] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    {
      underline = true,
      virtual_text = {
        spacing = 2,
        prefix = '',
      },
    }
  ),
}

local default_opts = {
  autoSetHints = true,
  handlers = handlers,
  noremap = true,
  silent = true,
  on_attach = on_attach,
  flags = {
    debounce_text_changes = 150,
  },
  capabilities = vim.lsp.protocol.make_client_capabilities(),
}

default_opts.capabilities = require('cmp_nvim_lsp').update_capabilities(
  default_opts.capabilities
)

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
      format = { enable = true }, -- Use Prettier using null-ls
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
      format = { enable = false }
    }
    lspconfig['sumneko_lua'].setup(opts)
  end,
})

-- for debugging
--[[ vim.lsp.set_log_level("debug") ]]
