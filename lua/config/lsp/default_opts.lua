local M = {}

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
  local mapOpts = { noremap = true, silent = true, buffer = bufnr }

  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

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
  vim.keymap.set('n', '<leader>xx', '<cmd>TroubleToggle<cr>', mapOpts)
  vim.keymap.set(
    'n',
    '<leader>xw',
    '<cmd>Trouble workspace_diagnostics<cr>',
    mapOpts
  )
  vim.keymap.set(
    'n',
    '<leader>xd',
    '<cmd>Trouble document_diagnostics<cr>',
    mapOpts
  )
  vim.keymap.set('n', '<leader>xl', '<cmd>Trouble loclist<cr>', mapOpts)
  vim.keymap.set('n', '<leader>xq', '<cmd>Trouble quickfix<cr>', mapOpts)
  vim.keymap.set('n', 'gr', '<cmd>Trouble lsp_references<cr>', mapOpts)
  -- vim.keymap.set(
  --   'v',
  --   '<leader>ca',
  --   "<cmd>'<,'>lua vim.lsp.buf.range_code_action()<CR>",
  --   Opts
  -- )
  -- buf_set_keymap('n', 'gr',         '<cmd>lua vim.lsp.buf.references()<CR>',                                 mapOpts)
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, mapOpts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, mapOpts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, mapOpts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, mapOpts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, mapOpts)
  vim.keymap.set('n', '<leader>Wa', vim.lsp.buf.add_workspace_folder, mapOpts)
  vim.keymap.set(
    'n',
    '<leader>Wr',
    vim.lsp.buf.remove_workspace_folder,
    mapOpts
  )
  vim.keymap.set('n', '<space>Wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, mapOpts)
  vim.keymap.set('n', '<leader>gt', vim.lsp.buf.type_definition, mapOpts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, mapOpts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, mapOpts)
  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, mapOpts)
  vim.keymap.set('n', '[c', vim.diagnostic.goto_prev, mapOpts)
  vim.keymap.set('n', ']c', vim.diagnostic.goto_next, mapOpts)
  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, mapOpts)
  vim.keymap.set('n', '<leader>f', function()
    vim.lsp.buf.format({ async = true })
  end, mapOpts)
  vim.keymap.set(
    'n',
    '<leader>fs',
    require('telescope.builtin').lsp_document_symbols,
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

local path = vim.fn.stdpath('config') .. '/spell/en.utf-8.add'
M.words = {}

for word in io.open(path, 'r'):lines() do
  table.insert(M.words, word)
end

-- -- Default settings
-- local border = {
--   { '╭', 'FloatBorder' },
--   { '─', 'FloatBorder' },
--   { '╮', 'FloatBorder' },
--   { '│', 'FloatBorder' },
--   { '╯', 'FloatBorder' },
--   { '─', 'FloatBorder' },
--   { '╰', 'FloatBorder' },
--   { '│', 'FloatBorder' },
-- }

vim.diagnostic.config({
  float = {
    source = 'always',
    focusable = true,
    style = 'minimal',
    border = 'rounded',
  },
  underline = true,
  signs = true,
  severity_sort = true,
  virtual_text = {
    spacing = 2,
    prefix = '',
  },
})

M.handlers = {
  ['textDocument/hover'] = vim.lsp.with(
    vim.lsp.handlers.hover,
    { border = 'rounded' }
  ),
  ['textDocument/signatureHelp'] = vim.lsp.with(
    vim.lsp.handlers.signature_help,
    { border = 'rounded' }
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
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
}

M.default_opts.capabilities.textDocument.completion.completionItem.snippetSupport =
  true

return M
