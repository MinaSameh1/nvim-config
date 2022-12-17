vim.api.nvim_create_user_command('TransparentEnable', function()
  require('config.colorscheme').TransparentEnable()
end, { nargs = 0 })

vim.api.nvim_create_user_command('TransparentDisable', function()
  require('config.colorscheme').TransparentDisable()
end, { nargs = 0 })
