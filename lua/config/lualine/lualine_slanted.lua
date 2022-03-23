local empty = require('lualine.component'):extend()
function empty:draw(default_highlight)
  self.status = ''
  self.applied_separator = ''
  self:apply_highlights(default_highlight)
  self:apply_section_separators()
  return self.status
end

-- Put proper separators and gaps between components in sections
local function process_sections(sections)
  for name, section in pairs(sections) do
    local left = name:sub(9, 10) < 'x'
    for pos = 1, name ~= 'lualine_z' and #section or #section - 1 do
      table.insert(section, pos * 2, { empty })
    end
    for id, comp in ipairs(section) do
      if type(comp) ~= 'table' then
        comp = { comp }
        section[id] = comp
      end
      comp.separator = left and { right = '' } or { left = '' }
    end
  end
  return sections
end

local function search_result()
  if vim.v.hlsearch == 0 then
    return ''
  end
  local last_search = vim.fn.getreg('/')
  if not last_search or last_search == '' then
    return ''
  end
  local searchcount = vim.fn.searchcount({ maxcount = 9999 })
  return last_search
    .. '('
    .. searchcount.current
    .. '/'
    .. searchcount.total
    .. ')'
end

require('lualine').setup({
  options = {
    globalstatus = true,
    icons_enabled = true,
    theme = 'auto',
    -- theme = 'pywal-nvim',
    -- component_separators = { left = '', right = ''},
    -- section_separators = { left = '', right = ''},
    -- section_separators = { left = '', right = '' },
    -- component_separators = { left = '', right = '' },
    component_separators = '',
    section_separators = { left = '', right = '' },
    disabled_filetypes = {}, -- NONE
    always_divide_middle = true,
  },
  sections = process_sections({
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
    lualine_x = { 'encoding', 'fileformat', search_result, 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  }),
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
    'aerial',
  },
})
