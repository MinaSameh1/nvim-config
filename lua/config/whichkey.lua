local ok, wk = pcall(require, 'which-key')
if not ok then
  print('which key config failed.')
  return
end

wk.setup({
  window = {
    position = 'bottom', -- 'bottom', 'top'
    border = 'single', -- none, single, double, shadow
    margin = { 2, 2, 2, 2 }, -- extra window margin [top, right, bottom, left]
  },
  layout = {
    height = { min = 4, max = 80 }, -- min and max height of the columns
    width = { min = 20, max = 120 }, -- min and max width of the columns
    spacing = 3, -- spacing between columns
    align = 'center', -- align columns left, center or right
  },
})
