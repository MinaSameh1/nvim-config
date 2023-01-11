local status_ok, jdtls = pcall(require, 'jdtls')
if not status_ok then
  print('Error in jdtls config')
  return
end

local workspace_dir = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local opts = require('config.lsp.default_opts').default_opts

local home = os.getenv('HOME')

local root_markers = { 'gradlew', '.git', 'mvnw', 'pom.xml' }

local bundles = {
  vim.fn.glob(
    home
      .. '/.local/share/java/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar',
    1
  ),
  -- vim.fn.glob(
  --   home
  --     .. '~/.local/share/java/vscode-java-test/java-extension/com.microsoft.java.test.runner/lib/*.jar',
  --   1
  -- ),
  -- vim.fn.glob(
  --   home
  --     .. '~/.local/share/java/vscode-java-test/java-extension/com.microsoft.java.test.runner/target/*.jar',
  --   1
  -- ),
  -- vim.fn.glob(
  --   home
  --     .. '~/.local/share/java/java-debug/com.microsoft.java.debug.plugin/com.microsoft.java.debug.plugin-*.jar',
  --   1
  -- ),
  --
}

vim.list_extend(
  bundles,
  vim.split(
    vim.fn.glob(home .. '/.local/share/java/vscode-java-test/server/*.jar', 1),
    '\n'
  )
)

-- extends default on attach
opts.capabilities.configuration = true

local config = {
  cmd = {
    'java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.level=ALL',
    '-noverify',
    '-Xmx1G',
    '-Xmx2G',
    '--add-modules=ALL-SYSTEM',
    '--add-opens',
    'java.base/java.util=ALL-UNNAMED',
    '--add-opens',
    'java.base/java.lang=ALL-UNNAMED',
    -- location of jdtls
    '-jar',
    vim.fn.glob(
      home .. '/.local/share/jdtls/plugins/org.eclipse.equinox.launcher_*.jar'
    ),
    -- config location
    '-configuration',
    home .. '/.local/share/jdtls/config_linux',
    -- Data location, set in cache
    '-data',
    home .. '/.cache/jdtls_workspaces/' .. workspace_dir,
  },
  root_dir = vim.fs.dirname(vim.fs.find(root_markers, { upward = true })[1]),
  settings = {
    java = {
      signatureHelp = { enabled = true, description = { enabled = true } },
      referenceCodeLens = { enabled = true },
      import = { enabled = true },
      exclusions = {
        '**/node_modules/**',
        '**/.metadata/**',
        '**/archetype-resources/**',
        '**/META-INF/maven/**',
      },
      rename = { enabled = true },
      saveActions = { organizeImports = true },
      format = {
        enabled = true,
        settings = {
          profile = 'GoogleStyle',
          url = home .. '/.config/nvim/utils/java_format.xml',
        },
      },
      project = {
        resourceFilters = {
          'node_modules',
          '.metadata',
          'archetype-resources',
          'META-INF/maven',
        },
      },
      templates = {
        fileHeader = '${package_name}',
      },
      favoriteStaticMembers = {
        'org.junit.jupiter.api.DynamicTest.*',
        'org.junit.jupiter.api.Assertions.*',
        'org.junit.jupiter.api.Assumptions.*',
        'org.junit.jupiter.api.DynamicContainer.*',
        'org.junit.Assert.*',
        'org.junit.Assume.*',
        'java.util.Objects.*',
        'org.mockito.ArgumentMatchers.*',
        'org.mockito.Mockito.*',
        'org.mockito.Answers.*',
      },
      completion = {
        importOrder = {
          'javax',
          'java',
          'com',
          'org',
        },
        guessMethodArguments = true,
      },
      configuration = {
        runtimes = {
          {
            name = 'JavaSE-1.8',
            path = '/usr/lib/jvm/java-8-openjdk/',
          },
          {
            name = 'JavaSE-11',
            path = '/usr/lib/jvm/java-11-openjdk/',
          },
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
    },
    sources = {
      organizeImports = {
        starThreshold = 9999,
        staticStarThreshold = 9999,
      },
    },
    codeGeneration = {
      toString = {
        listArrayContents = true,
        skipNullValues = true,
        template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
      },
      useBlocks = true,
      hashCodeEquals = {
        useInstanceof = true,
        useJava7Objects = true,
      },
      generateComments = true,
      insertLocation = true,
    },
    inlayHints = { --  doesn't work with jdtls yet
      parameterNames = {
        enabled = 'none', -- literals, all, none
      },
    },
    autobuild = {
      enabled = true,
    },
    eclipse = {
      downloadSources = true,
    },
    maven = {
      downloadSources = true,
      updateSnapshots = true,
    },
  },
  flags = {
    allow_incremental_sync = true,
  },
  capabilities = opts.capabilities,
  init_options = {
    extendedClientCapabilities = {
      resolveAdditionalTextEditsSupport = true,
      classFileContentsSupport = true,
      generateToStringPromptSupport = true,
      hashCodeEqualsPromptSupport = true,
      advancedExtractRefactoringSupport = true,
      advancedOrganizeImportsSupport = true,
      generateConstructorsPromptSupport = true,
      generateDelegateMethodsPromptSupport = true,
      moveRefactoringSupport = true,
      overrideMethodsPromptSupport = true,
      inferSelectionSupport = {
        'extractMethod',
        'extractVariable',
        'extractConstant',
      },
    },
    bundles = bundles,
  },
}

config['on_attach'] = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  vim.cmd([[
      hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
      augroup lsp_document_highlight
        autocmd!
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
      augroup FormatAutogroup
        autocmd!
        autocmd BufWritePost *.java LspFormat
      augroup end
    ]])
  -- Call default  on attach
  opts.on_attach(client, bufnr)
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
  jdtls.setup_dap({ hotcodereplace = 'auto' })
  require('jdtls.setup').add_commands()
end

jdtls.start_or_attach(config)
