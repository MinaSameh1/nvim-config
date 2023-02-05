local status_ok, silicon = pcall(require, 'silicon')
if not status_ok then
  print('Error in silicon config')
  return
end

silicon.setup({
  output = os.getenv('HOME')
    .. '/Pictures/code/SILICON_${year}-${month}-${date}_${time}.png',
  lineOffset = 1, -- from where to start line number
  linePad = 2, -- padding between lines
  padHoriz = 80, -- Horizontal padding
  gobble = true, -- enable lsautogobble like featurepadVert = 100, -- vertical padding
})

vim.api.nvim_create_augroup('SiliconRefresh', { clear = true })
vim.api.nvim_create_autocmd({ 'ColorScheme' }, {
  group = 'SiliconRefresh',
  callback = function()
    require('silicon.utils').build_tmTheme()
    require('silicon.utils').reload_silicon_cache({ async = true })
  end,
  desc = 'Reload silicon themes cache on colorscheme switch',
})

local mapOpts = { noremap = true, silent = true }
local setDes = require('config.utils').getDescWithMapOptsSetter(mapOpts)

-- Generate image of lines in a visual selection
vim.keymap.set('v', '<Leader>S', function()
  silicon.visualise_cmdline({ to_clip = true })
end, setDes('Generate image of lines in a visual selection'))
-- Generate image of a whole buffer, with lines in a visual selection highlighted
vim.keymap.set('v', '<Leader>Ss', function()
  silicon.visualise_cmdline({ to_clip = true, show_buf = true })
end, setDes('Generate image of a whole buffer with visual highlighted'))
-- Generate visible portion of a buffer
vim.keymap.set('n', '<Leader>S', function()
  silicon.visualise_api({ to_clip = true, visible = true })
end, setDes('Generate visible portion of a buffer'))
-- Generate whole buffer
vim.keymap.set('n', '<Leader>SS', function()
  silicon.visualise_api({ to_clip = true, show_buf = true })
end, setDes('Generate visible portion of a buffer'))
-- Generate current buffer line in normal mode
vim.keymap.set('n', '<Leader>Ss', function()
  silicon.visualise_api({ to_clip = true })
end, setDes('Generate current buffer line in normal mode'))
