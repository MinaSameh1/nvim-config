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
    textobjects = {
      swap = {
        enable = true,
        swap_next = {
          ['<leader>a'] = '@parameter.inner',
        },
        swap_previous = {
          ['<leader>A'] = '@parameter.inner',
        },
      },
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
