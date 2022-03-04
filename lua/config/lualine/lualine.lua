LSP_Name = {
  -- Lsp server name .
  function()
    local msg = 'No Active Lsp'
    local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
    local clients = vim.lsp.get_active_clients()
    if next(clients) == nil then
      return msg
    end
    for _, client in ipairs(clients) do
      local filetypes = client.config.filetypes
      if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
        return client.name
      end
    end
    return msg
  end,
  icon = ' LSP:',
  color = { fg = '#ffffff', gui = 'bold' },
}

require('lualine').setup({
  options = {
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
      LSP_Name,
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
