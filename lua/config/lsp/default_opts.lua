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
  local setDesc = require('config.utils').getDescWithMapOptsSetter(mapOpts)

  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- Mappings for Trouble
  vim.keymap.set(
    'n',
    '<leader>xx',
    '<cmd>TroubleToggle<cr>',
    setDesc('Toggles Trouble')
  )
  vim.keymap.set(
    'n',
    '<leader>xw',
    '<cmd>Trouble workspace_diagnostics<cr>',
    setDesc('Opens workspace diagnostics')
  )
  vim.keymap.set(
    'n',
    '<leader>xd',
    '<cmd>Trouble document_diagnostics<cr>',
    setDesc('Opens document diagnostics')
  )
  vim.keymap.set(
    'n',
    '<leader>xl',
    '<cmd>Trouble loclist<cr>',
    setDesc('Opens Loclist')
  )
  vim.keymap.set(
    'n',
    '<leader>xq',
    '<cmd>Trouble quickfix<cr>',
    setDesc('Opens quickfix')
  )
  vim.keymap.set(
    'n',
    'gr',
    '<cmd>Trouble lsp_references<cr>',
    setDesc('Gets lsp references')
  )
  -- vim.keymap.set(
  --   'v',
  --   '<leader>ca',
  --   "<cmd>'<,'>lua vim.lsp.buf.range_code_action()<CR>",
  --   Opts
  -- )
  -- buf_set_keymap('n', 'gr',         '<cmd>lua vim.lsp.buf.references()<CR>',                                 mapOpts)
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.keymap.set(
    'n',
    'gD',
    vim.lsp.buf.declaration,
    setDesc('Go to declaration')
  )
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, setDesc('Go to definition'))
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, setDesc('Opens hover doc'))
  vim.keymap.set(
    'n',
    'gi',
    vim.lsp.buf.implementation,
    setDesc('Go to implemntation')
  )
  vim.keymap.set(
    'n',
    '<C-k>',
    vim.lsp.buf.signature_help,
    setDesc('Opens signature help')
  )
  vim.keymap.set(
    'n',
    '<leader>Wa',
    vim.lsp.buf.add_workspace_folder,
    setDesc('Adds the folder to the workspace.')
  )
  vim.keymap.set(
    'n',
    '<leader>Wr',
    vim.lsp.buf.remove_workspace_folder,
    setDesc('Removes the folder from workspace.')
  )
  vim.keymap.set('n', '<space>Wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, setDesc('Lists workspace folders'))
  vim.keymap.set(
    'n',
    '<leader>gt',
    vim.lsp.buf.type_definition,
    setDesc('Go to type definition')
  )
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, setDesc('Rename'))
  vim.keymap.set(
    'n',
    '<leader>ca',
    vim.lsp.buf.code_action,
    setDesc('Code action')
  )
  vim.keymap.set(
    'n',
    '<leader>e',
    vim.diagnostic.open_float,
    setDesc('Opens diagnostics in float')
  )
  vim.keymap.set(
    'n',
    '[c',
    vim.diagnostic.goto_prev,
    setDesc('Go to next diagnostics')
  )
  vim.keymap.set(
    'n',
    ']c',
    vim.diagnostic.goto_next,
    setDesc('Go to prev diagnostics')
  )
  vim.keymap.set('n', '<leader>F', function()
    vim.lsp.buf.format({ async = true })
  end, setDesc('Formats file'))
  vim.keymap.set(
    'n',
    '<leader>fs',
    require('telescope.builtin').lsp_document_symbols,
    setDesc('Opens document symbols')
  )

  vim.cmd([[
  " Lightblub for code action
  autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()
  " Adds the commands to nvim
  command! LspCodeAction execute 'lua vim.lsp.buf.code_action()'
  ]])

  vim.api.nvim_buf_create_user_command(bufnr, 'LspFormat', function(_)
    if vim.lsp.buf.format then
      vim.lsp.buf.format()
    elseif vim.lsp.buf.formatting then
      vim.lsp.buf.formatting()
    end
  end, { desc = 'Format current buffer with LSP' })

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
