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
    vim.ui.select({
      'current',
      'package.json',
      'selene.toml',
      'gradlew',
      'pom.xml',
      'mvnw',
      'other',
    }, {
      prompt = 'Select directory to navigate:',
    }, function(choice)
      if choice == 'other' then
        choice = vim.fn.input('File to search for: ')
      end
      if choice == 'current' then
        vim.g.root_spec = { 'cwd' }
        utils.cd_current_file()
        return
      end
      utils.search_and_cd_for_file(choice)
    end)
  end,
  { nargs = 0, desc = 'Changes to package.json directory if found in parent' }
)

vim.api.nvim_create_user_command('JumpsToQf', function()
  utils.jumps_to_qf()
end, { nargs = 0, desc = 'Jumps to quickfix list' })
