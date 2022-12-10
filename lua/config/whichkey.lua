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
})
