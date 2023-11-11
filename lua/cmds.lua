vim.api.nvim_create_user_command('TransparentEnable', function()
  require('config.colorscheme').TransparentEnable()
end, { nargs = 0, desc = 'Enables transparent background' })

vim.api.nvim_create_user_command('TransparentDisable', function()
  require('config.colorscheme').TransparentDisable()
end, { nargs = 0, desc = 'Disables transparent background' })

local utils = require('config.utils')

vim.api.nvim_create_user_command('CdCurrentFile', function()
  utils.cd_current_file()
end, { nargs = 0, desc = 'Changes to current file directory' })

vim.api.nvim_create_user_command(
  'CdPackageJson',
  function()
    utils.change_to_package_json_dir()
  end,
  { nargs = 0, desc = 'Changes to package.json directory if found in parent' }
)
