local mapOpts = { noremap = true, silent = true }

local function lsp_highlight_document(client)
  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec(
      [[
      augroup lsp_document_highlight
      autocmd! * <buffer>
      autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
      autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
      ]],
      false
    )
  end
end
-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
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

  if client.name == 'tsserver' then
    local ts_utils = require('config.lsp.tsutils')
    ts_utils.setup_client(client)
    client.resolved_capabilities.document_formatting = false -- I use prettier for now :)
  end
  -- Mappings.
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
    '<cmd>lua vim.lsp.buf.formatting()<CR>',
    mapOpts
  )
  buf_set_keymap(
    'n',
    '<leader>so',
    [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]],
    mapOpts
  )

  vim.cmd([[
  " Lightblub for code action
  autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()
  " Show line diagnostics automatically in hover window
  " autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})
  " For diagnostics for specific cursor position
  autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false, scope="cursor", border="rounded"})
	" Adds the commands to nvim
  command! LspCodeAction execute 'lua vim.lsp.buf.code_action()'
  command! LspFormat execute 'lua vim.lsp.buf.formatting()'
  ]])
  -- AutoFormat on save
  if client.resolved_capabilities.document_formatting then
    vim.cmd([[
      augroup lsp_format_on_save
      autocmd! * <buffer>
      autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()
      augroup END
      ]])
  end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
  -- Highlight used words
  lsp_highlight_document(client)
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local lsp_installer = require('nvim-lsp-installer')

-- Set the signs to this
local signs = {
  { name = 'DiagnosticSignError', text = '' },
  { name = 'DiagnosticSignWarn', text = '' },
  { name = 'DiagnosticSignHint', text = '' },
  { name = 'DiagnosticSignInfo', text = '' },
}

vim.diagnostic.config({
  float = {
    source = 'always', -- Or "if_many"
  },
})
-- Register a handler that will be called for all installed servers.
-- Alternatively, you may also register handlers on specific server instances instead (see example below).
lsp_installer.on_server_ready(function(server)
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

  -- -- LSP settings (for overriding per client)
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
        -- This sets the spacing and the prefix, obviously.
        virtual_text = {
          spacing = 2,
          prefix = '',
        },
      }
    ),
  }

  local opts = {
    autoSetHints = true,
    handlers = handlers,
    noremap = true,
    silent = true,
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
    float = {
      style = 'minimal',
      border = 'rounded',
      source = 'always',
      header = '',
      prefix = '',
    },
    settings = {
      Lua = {
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { 'vim' },
        },
      },
    },
    capabilities = vim.lsp.protocol.make_client_capabilities(),
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(
      sign.name,
      { texthl = sign.name, text = sign.text, numhl = '' }
    )
  end

  lsp_installer.capabilities = require('cmp_nvim_lsp').update_capabilities(
    opts.capabilities
  )

  -- If the server is eslint override the settings
  if server.name == 'eslint' or server.name == 'tsserver' then
    opts.init_options = require('nvim-lsp-ts-utils').init_options
    opts.settings = {
      codeAction = {
        disableRuleComment = {
          location = 'separateLine',
        },
        showDocumentation = {
          enable = true,
        },
        format = { enable = false }, -- Use Prettier using null-ls
      },
    }
    -- If the server is Rust analyzer use the plugin
  elseif server.name == 'rust_analyzer' then
    -- Initialize the LSP via rust-tools instead
    require('rust-tools').setup({
      -- The "server" property provided in rust-tools setup function are the
      -- settings rust-tools will provide to lspconfig during init.            --
      -- We merge the necessary settings from nvim-lsp-installer (server:get_default_options())
      -- with the user's own settings (opts).
      server = vim.tbl_deep_extend('force', server:get_default_options(), opts),
    })
    server:attach_buffers()
    return
  elseif server.name == 'clangd' or server.name == 'ccls' then
    opts.capabilities.offsetEncoding = { 'utf-16' } -- Fixes problem with clang
  end
  server:setup(opts)
end)

-- for debugging
-- vim.lsp.set_log_level("debug")

local Key = vim.api.nvim_set_keymap

-- Mappings for Trouble
Key('n', '<leader>xx', '<cmd>TroubleToggle<cr>', mapOpts)
Key('n', '<leader>xw', '<cmd>Trouble workspace_diagnostics<cr>', mapOpts)
Key('n', '<leader>xd', '<cmd>Trouble document_diagnostics<cr>', mapOpts)
Key('n', '<leader>xl', '<cmd>Trouble loclist<cr>', mapOpts)
Key('n', '<leader>xq', '<cmd>Trouble quickfix<cr>', mapOpts)
Key('n', 'gr', '<cmd>Trouble lsp_references<cr>', mapOpts)
