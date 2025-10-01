return {
  'folke/sidekick.nvim',
  opts = {
    -- add any options here
    cli = {
      mux = {
        backend = 'tmux',
        enabled = true,
      },
    },
  },
  keys = {
    {
      '<tab>',
      function()
        -- if there is a next edit, jump to it, otherwise apply it if any
        if not require('sidekick').nes_jump_or_apply() then
          return '<Tab>' -- fallback to normal tab
        end
      end,
      expr = true,
      desc = 'Goto/Apply Next Edit Suggestion',
    },
    {
      '<c-.>',
      function()
        require('sidekick.cli').focus()
      end,
      mode = { 'n', 'x', 'i', 't' },
      desc = 'Sidekick Switch Focus',
    },
    {
      '<leader>as',
      function()
        require('sidekick.cli').select()
        -- Or to select only installed tools:
        -- require("sidekick.cli").select({ filter = { installed = true } })
      end,
      desc = 'Sidekick Select CLI',
      mode = { 'n', 'v' },
    },
    {
      '<leader>ac',
      function()
        require('sidekick.cli').toggle({ name = 'codex', focus = true })
      end,
      desc = 'Sidekick Codex Toggle',
      mode = { 'n', 'v' },
    },
    {
      '<leader>ar',
      function()
        require('sidekick.cli').prompt()
      end,
      desc = 'Sidekick Ask Prompt',
      mode = { 'n', 'v' },
    },
  },
}
