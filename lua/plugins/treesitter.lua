return {
  'nvim-treesitter/nvim-treesitter',
  opts = {
    ensure_installed = {
      'astro',
      'cmake',
      'cpp',
      'css',
      'fish',
      'gitignore',
      'go',
      'graphql',
      'http',
      'java',
      'php',
      'rust',
      'sql',
    },
  },
  config = function(opts)
    require('nvim-treesitter.configs').setup(opts)

    vim.filetype.add({
      executable = {
        mdx = 'mdx',
      },
    })

    vim.treesitter.language.register('markdown', 'mdx')
  end,
}
