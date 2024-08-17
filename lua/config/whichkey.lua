local ok, wk = pcall(require, 'which-key')
if not ok then
  print('which key config failed.')
  return
end

wk.setup({
  win = {
    border = 'single', -- none, single, double, shadow
    -- don't allow the popup to overlap with the cursor
    no_overlap = true,
    height = { min = 4, max = 80 }, -- min and max height of the columns
    width = { min = 20, max = 120 }, -- min and max width of the columns
    -- col = 0,
    -- row = math.huge,
    -- border = "none",
    padding = { 1, 2 }, -- extra window padding [top/bottom, right/left]
  },
  layout = {
    spacing = 3, -- spacing between columns
    align = 'center', -- align columns left, center or right
  },
})
