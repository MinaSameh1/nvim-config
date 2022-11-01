local status_ok, jdtls = pcall(require, 'jdtls')
if not status_ok then
  print('Error in jdtls config')
  return
end

local workspace_dir = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local opts = require('config.lsp.default_opts').default_opts

local home = os.getenv('HOME')

local root_markers = { 'gradlew', '.git', 'mvnw', 'pom.xml' }

-- extends default on attach
opts.capabilities.configuration = true

local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

local config = {
  cmd = {
    'java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.level=ALL',
    '-noverify',
    -- use 1gig ram
    '-Xmx1G',
    -- location of jdtls
    '-jar',
    home
      .. '/.local/share/jdtls/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar',
    -- config location
    '-configuration',
    home .. '/.local/share/jdtls/config_linux',
    -- Data location, set in cache
    '-data',
    home .. '/.cache/jdtls_workspaces/' .. workspace_dir,
  },
  root_dir = vim.fs.dirname(vim.fs.find(root_markers, { upward = true })[1]),
  capabilities = opts.capabilities,
  init_options = {
    bundles = {},
    extendedClientCapabilities = extendedClientCapabilities,
  },
  configuration = {
    runtimes = {
      {
        name = 'JavaSE-17',
        path = '/usr/lib/jvm/java-17-openjdk/',
      },
      {
        name = 'JavaSE-19',
        path = '/usr/lib/jvm/java-19-openjdk/',
      },
    },
  },
}

config['on_attach'] = function(client, bufnr)
  -- Call default  on attach
  local mapOpts = { noremap = true, silent = true, buffer = bufnr }
  -- Java specific
  vim.keymap.set(
    'v',
    '<leader>ca',
    '<Cmd>lua require("jdtls").code_action(true)<CR>',
    mapOpts
  )
  vim.keymap.set(
    'n',
    '<leader>rr',
    '<Cmd>lua require("jdtls").code_action(false, "refactor")<CR>',
    mapOpts
  )
  vim.keymap.set(
    'n',
    '<leader>ji',
    "<Cmd>lua require'jdtls'.organize_imports()<CR>",
    mapOpts
  )
  vim.keymap.set(
    'n',
    '<leader>jt',
    "<Cmd>lua require'jdtls'.test_class()<CR>",
    mapOpts
  )
  vim.keymap.set(
    'n',
    '<leader>jn',
    "<Cmd>lua require'jdtls'.test_nearest_method()<CR>",
    mapOpts
  )
  vim.keymap.set(
    'v',
    '<leader>jm',
    "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>",
    mapOpts
  )
  vim.keymap.set(
    'v',
    '<leader>jE',
    "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>",
    mapOpts
  )
  vim.keymap.set(
    'n',
    '<leader>je',
    '<Cmd> lua require("jdtls").extract_variable()<CR>',
    mapOpts
  )
  vim.keymap.set(
    'n',
    '<leader>jc',
    '<Cmd> lua require("jdtls").extract_constant()',
    mapOpts
  )
  opts.on_attach(client, bufnr)
end

jdtls.start_or_attach(config)
