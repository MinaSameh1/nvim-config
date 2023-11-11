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

vim.api.nvim_create_user_command('SearchForFileInParentDirs', function()
  utils.search_for_file_in_parent_dirs(vim.fn.input('File to search for: '))
end, { nargs = 0, desc = 'Searches for file in parent directories' })

vim.api.nvim_create_user_command(
  'SearchAndCdForFile',
  function()
    -- add vim.select.ui prompt
    vim.ui.select({ 'package.json', 'gradlew', 'pom.xml', 'mvnw', 'other' }, {
      prompt = 'Select directory to navigate:',
    }, function(choice)
      if choice == 'other' then
        choice = vim.fn.input('File to search for: ')
      end
      utils.search_and_cd_for_file(choice)
    end)
  end,
  { nargs = 0, desc = 'Changes to package.json directory if found in parent' }
)
