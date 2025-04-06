return {
  'L3MON4D3/LuaSnip',
  config = function(opts)
    local ls = require('luasnip')
    require('luasnip.loaders.from_lua').lazy_load({
      paths = { vim.fn.stdpath('config') .. '/lua/snippets' },
    })

    ls.config.set_config(opts)

    vim.api.nvim_create_user_command('LuaSnipEdit', function()
      require('luasnip.loaders.from_lua').edit_snippet_files()
    end, { nargs = 0, desc = 'Edits current file snippets' })
  end,
  keys = {
    {
      '<C-k>',
      '<cmd>lua require("luasnip").jump(-1)<CR>',
      mode = { 'i', 's' },
      desc = 'Jump to previous snippet',
    },
    {
      '<C-j>',
      '<cmd>lua require("luasnip").jump(1)<CR>',
      mode = { 'i', 's' },
      desc = 'Jump to next snippet',
    },
    {
      '<C-l>',
      '<cmd>lua if ls.choice_active() then ls.change_choice(1) end<CR>',
      mode = { 'i', 's' },
      desc = 'Change snippet choice',
    },
    {
      '<C-h>',
      '<cmd>lua if ls.choice_active() then ls.change_choice(-1) end<CR>',
      mode = { 'i', 's' },
      desc = 'Change snippet choice',
    },
    {
      '<C-u>',
      '<cmd>lua require("luasnip.extras.select_choice")()<CR>',
      mode = { 'i', 's' },
      desc = 'Select snippet choice',
    },
  },
}
