require('lualine').setup({
  options = {
		globalstatus = true,
    icons_enabled = true,
    theme = 'auto',
    -- theme = 'pywal-nvim',
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    -- section_separators = { left = '', right = '' },
    -- component_separators = { left = '', right = '' },
    -- component_separators = '',
    -- section_separators = { left = '', right = '' },
    disabled_filetypes = {}, -- NONE
    always_divide_middle = true,
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = {
      'branch',
      'diff',
      {
        'diagnostics',
        sources = { 'nvim_lsp' },
        -- Displays diagnostics for the defined severity types
        sections = { 'error', 'warn', 'info', 'hint' },
      },
    },
    lualine_c = {
      'filename',
      {
        '%w',
        cond = function()
          return vim.wo.previewwindow
        end,
      },
      {
        '%r',
        cond = function()
          return vim.bo.readonly
        end,
      },
      {
        '%q',
        cond = function()
          return vim.bo.buftype == 'quickfix'
        end,
      },
      '%=',
      require('config.utils').LSP_Name,
    },
    lualine_x = { 'encoding', 'fileformat', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
  inactive_sections = {
    lualine_a = { 'mode' },
    lualine_b = {},
    lualine_c = { 'filename' },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = { '%y %m' },
  },
  tabline = {},
  extensions = {
    'fugitive',
    'nvim-tree',
    'toggleterm',
  },
})
