local mapOpts = { noremap=true, silent=true }

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
  if client.name == "tsserver" then
    client.resolved_capabilities.document_formatting = false
  end
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD',         '<cmd>lua vim.lsp.buf.declaration()<CR>',                                mapOpts)
  buf_set_keymap('n', 'gd',         '<cmd>lua vim.lsp.buf.definition()<CR>',                                 mapOpts)
  buf_set_keymap('n', 'K',          '<cmd>lua vim.lsp.buf.hover()<CR>',                                      mapOpts)
  buf_set_keymap('n', 'gi',         '<cmd>lua vim.lsp.buf.implementation()<CR>',                             mapOpts)
  buf_set_keymap('n', '<C-k>',      '<cmd>lua vim.lsp.buf.signature_help()<CR>',                             mapOpts)
  buf_set_keymap('n', '<leader>Wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>',                       mapOpts)
  buf_set_keymap('n', '<leader>Wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>',                    mapOpts)
  buf_set_keymap('n', '<leader>Wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', mapOpts)
  buf_set_keymap('n', '<leader>D',  '<cmd>lua vim.lsp.buf.type_definition()<CR>',                            mapOpts)
  buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>',                                     mapOpts)
  buf_set_keymap('n', '<leader>ca', '<cmd>Telescope lsp_code_actions theme=cursor<CR>',                      mapOpts)
  buf_set_keymap('v', '<leader>ca', '<cmd>\'<,\'>lua vim.lsp.buf.range_code_action()<CR>',                   mapOpts)
  buf_set_keymap('n', '<leader>I', 'require(\'nvim-lsp-installer.extras.tsserver\').organize_imports(bufname)',                   mapOpts)
  -- buf_set_keymap('n', 'gr',         '<cmd>lua vim.lsp.buf.references()<CR>',                                 mapOpts)
  buf_set_keymap('n', '<leader>e',  '<cmd>lua vim.diagnostic.open_float()<CR>',                              mapOpts)
  buf_set_keymap('n', '[c',         '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>',         mapOpts)
  buf_set_keymap('n', ']c',         '<cmd>lua vim.diagnostic.goto_next()<CR>',                               mapOpts)
  buf_set_keymap('n', '<leader>q',  '<cmd>lua vim.diagnostic.setloclist()<CR>',                              mapOpts)
  buf_set_keymap('n', '<leader>f',  '<cmd>lua vim.lsp.buf.formatting()<CR>',                                 mapOpts)
  buf_set_keymap('n', '<leader>so', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]],    mapOpts)
  vim.cmd [[
  " Lightblub for code action
  autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()
  autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false, scope="cursor"})
  " Show line diagnostics automatically in hover window
  " autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})
  " For diagnostics for specific cursor position
  command! LspCodeAction execute 'lua vim.lsp.buf.code_action()'
  command! LspFormat execute 'lua vim.lsp.buf.formatting()' 
  ]]
  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
  -- Highlight used words
  lsp_highlight_document(client)
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local lsp_installer = require("nvim-lsp-installer")

-- Set the signs to this
local signs = {
{ name = "DiagnosticSignError", text = "" },
{ name = "DiagnosticSignWarn", text = "" },
{ name = "DiagnosticSignHint", text = "" },
{ name = "DiagnosticSignInfo", text = "" },
}

-- Register a handler that will be called for all installed servers.
-- Alternatively, you may also register handlers on specific server instances instead (see example below).
lsp_installer.on_server_ready(function(server)

  -- local border = {
  --   {"🭽", "FloatBorder"},
  --   {"▔", "FloatBorder"},
  --   {"🭾", "FloatBorder"},
  --   {"▕", "FloatBorder"},
  --   {"🭿", "FloatBorder"},
  --   {"▁", "FloatBorder"},
  --   {"🭼", "FloatBorder"},
  --   {"▏", "FloatBorder"},
  -- }
  --
  -- -- LSP settings (for overriding per client)
  -- local handlers =  {
  --   ["textDocument/hover"] =  vim.lsp.with(vim.lsp.handlers.hover, {border = border}),
  --   ["textDocument/signatureHelp"] =  vim.lsp.with(vim.lsp.handlers.signature_help, {border = border }),
  -- }

  local opts = {
    autoSetHints = true,
    noremap = true,
    silent = true,
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
    float = {
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
    settings = {
      Lua = {
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = {'vim'},
        },
      }
    },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  lsp_installer.capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

  if server.name == "eslintls" then
    opts.on_attach = function(client, _)
      client.resolved_capabilities.document_formatting = true
    end
    opts.settings = {
      codeAction = {
        disableRuleComment = {
          location = "separateLine"
        },
        showDocumentation = {
          enable = true
        },
        format = { enable = true },
      }
    }
  elseif server.name == "rust_analyzer" then
    -- Initialize the LSP via rust-tools instead
    require("rust-tools").setup {
      -- The "server" property provided in rust-tools setup function are the
      -- settings rust-tools will provide to lspconfig during init.            --
      -- We merge the necessary settings from nvim-lsp-installer (server:get_default_options())
      -- with the user's own settings (opts).
      server = vim.tbl_deep_extend("force", server:get_default_options(), opts),
    }
    server:attach_buffers()
  else
    server:setup(opts)
  end
end)

-- for debugging
-- vim.lsp.set_log_level("debug")

local Key = vim.api.nvim_set_keymap

-- Mappings for Trouble
Key("n", "<leader>xx", "<cmd>Trouble<cr>",                       mapOpts)
Key("n", "<leader>xw", "<cmd>Trouble workspace_diagnostics<cr>", mapOpts)
Key("n", "<leader>xd", "<cmd>Trouble document_diagnostics<cr>",  mapOpts)
Key("n", "<leader>xl", "<cmd>Trouble loclist<cr>",               mapOpts)
Key("n", "<leader>xq", "<cmd>Trouble quickfix<cr>",              mapOpts)
Key("n", "gr",         "<cmd>Trouble lsp_references<cr>",        mapOpts)
