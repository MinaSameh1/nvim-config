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

local mapOpts = { noremap = true, silent = true }

vim.keymap.set(
  'v',
  '<leader>S',
  'require("silicon").visualise_api({ to_clip = true })',
  mapOpts
)

vim.keymap.set(
  'n',
  '<leader>S',
  'require("silicon").visualise_api({ show_buf = true })',
  mapOpts
)
