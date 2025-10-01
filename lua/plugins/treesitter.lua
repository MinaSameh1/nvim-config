return {
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
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
      })

      -- Provide Treesitter info for MDX files.
      vim.filetype.add({ executable = { mdx = 'mdx' } })
      vim.treesitter.language.register('markdown', 'mdx')
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    opts = function(_, opts)
      opts.swap = opts.swap or {}
      opts.swap.enable = true
    end,
    keys = {
      {
        '<leader>a',
        function()
          require('nvim-treesitter-textobjects.swap').swap_next(
            '@parameter.inner'
          )
        end,
        desc = 'Swap Parameter with Next',
      },
      {
        '<leader>A',
        function()
          require('nvim-treesitter-textobjects.swap').swap_previous(
            '@parameter.inner'
          )
        end,
        desc = 'Swap Parameter with Previous',
      },
    },
  },
}
