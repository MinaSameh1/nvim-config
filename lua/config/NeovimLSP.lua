
-- Lightblub for code action
vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]

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
  local mapOpts = { noremap=true, silent=true }
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
  buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>',                                mapOpts)
  buf_set_keymap('v', '<leader>ca', '<cmd>\'<,\'>lua vim.lsp.buf.range_code_action()<CR>',                   mapOpts)
  buf_set_keymap('n', 'gr',         '<cmd>lua vim.lsp.buf.references()<CR>',                                 mapOpts)
  buf_set_keymap('n', '<leader>e',  '<cmd>lua vim.diagnostic.open_float()<CR>',                              mapOpts)
  buf_set_keymap('n', '[c',         '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>',         mapOpts)
  buf_set_keymap('n', ']c',         '<cmd>lua vim.diagnostic.goto_next()<CR>',                               mapOpts)
  buf_set_keymap('n', '<leader>q',  '<cmd>lua vim.diagnostic.setloclist()<CR>',                              mapOpts)
  buf_set_keymap('n', '<leader>f',  '<cmd>lua vim.lsp.buf.formatting()<CR>',                                 mapOpts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>so', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]], mapOpts)
  vim.cmd [[ command! LspCodeAction execute 'lua vim.lsp.buf.code_action()']]
  vim.cmd [[ command! LspFormat execute 'lua vim.lsp.buf.formatting()' ]]



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
    vim.cmd [[autocmd ColorScheme * highlight NormalFloat guibg=#1f2335]]
    vim.cmd [[autocmd ColorScheme * highlight FloatBorder guifg=white guibg=#1f2335]]


--     local border = {
--         {"🭽", "FloatBorder"},
--         {"▔", "FloatBorder"},
--         {"🭾", "FloatBorder"},
--         {"▕", "FloatBorder"},
--         {"🭿", "FloatBorder"},
--         {"▁", "FloatBorder"},
--         {"🭼", "FloatBorder"},
--         {"▏", "FloatBorder"},
--     }
--
-- -- LSP settings (for overriding per client)
--     local handlers =  {
--         ["textDocument/hover"] =  vim.lsp.with(vim.lsp.handlers.hover, {border = border}),
--         ["textDocument/signatureHelp"] =  vim.lsp.with(vim.lsp.handlers.signature_help, {border = border }),
-- }

    local opts = {
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
    -- (optional) Customize the options passed to the server
    -- if server.name == "tsserver" then
    --     opts.root_dir = function() ... end
    -- end

    -- This setup() function is exactly the same as lspconfig's setup function.
    -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    lsp_installer.capabilities = require'cmp_nvim_lsp'.update_capabilities(capabilities)
	if server.name == "eslintls" then
		opts.settings = {
			codeAction = {
				disableRuleComment = {
					location = "separateLine"
				},
				showDocumentation = {
					enable = true
				}
			}
		}
	end
    server:setup(opts)
end)

-- for debugging
-- vim.lsp.set_log_level("debug")



-- Show line diagnostics automatically in hover window
-- vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]
-- For diagnostics for specific cursor position
vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false, scope="cursor"})]]

local Key = vim.api.nvim_set_keymap

-- Mappings for Trouble
Key("n", "<leader>xx", "<cmd>Trouble<cr>",
  {silent = true, noremap = true}
)
Key("n", "<leader>xw", "<cmd>Trouble workspace_diagnostics<cr>",
  {silent = true, noremap = true}
)
Key("n", "<leader>xd", "<cmd>Trouble document_diagnostics<cr>",
  {silent = true, noremap = true}
)
Key("n", "<leader>xl", "<cmd>Trouble loclist<cr>",
  {silent = true, noremap = true}
)
Key("n", "<leader>xq", "<cmd>Trouble quickfix<cr>",
  {silent = true, noremap = true}
)
Key("n", "gR", "<cmd>Trouble lsp_references<cr>",
  {silent = true, noremap = true}
)