local M = {}

local mapOpts = { noremap = true, silent = true }

-- document_highlight
local function lsp_highlight_document(bufnr)
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
M.on_attach = function(client, bufnr)
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

  -- Highlight used words
  if client.server_capabilities.documentHighlightProvider then
    lsp_highlight_document(bufnr)
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
  -- For formatting
  if client.supports_method('textDocument/formatting') then
    local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = augroup,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({
          -- async = true,
          bufnr = bufnr,
          filter = function(client_format)
            -- Use only null_ls for now.
            return client_format.name == 'null-ls'
          end,
        })
      end,
    })
  end
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
M.words = {}

for word in io.open(path, 'r'):lines() do
  table.insert(M.words, word)
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

M.handlers = {
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

M.default_opts = {
  autoSetHints = true,
  handlers = M.handlers,
  noremap = true,
  silent = true,
  on_attach = M.on_attach,
  flags = {
    debounce_text_changes = 150,
  },
  format = true,
  capabilities = vim.lsp.protocol.make_client_capabilities(),
}

M.default_opts.capabilities = require('cmp_nvim_lsp').update_capabilities(
  M.default_opts.capabilities
)
M.default_opts.capabilities.textDocument.completion.completionItem.snippetSupport =
  true

return M
