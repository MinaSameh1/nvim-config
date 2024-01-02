--- @type LazyPluginKind
return {
  'eandrju/cellular-automaton.nvim',
  cmd = 'CellularAutomaton',
  keys = {
    {
      '<leader>fml',
      '<cmd>CellularAutomaton make_it_rain<CR>',
      desc = 'Makes it rain',
    },
    {
      '<leader>fml',
      '<cmd>CellularAutomaton game_of_life<CR>',
      desc = 'Lets play',
    },
  },
}
