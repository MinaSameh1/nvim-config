local types = require('luasnip.util.types')
local ls = require('luasnip')
local config = require('config.utils').config_location

ls.config.setup({
  history = true,
  delete_check_events = 'TextChanged',
  updateevents = 'TextChanged, TextChangedI',
  region_check_events = 'CursorHold',
  enable_autosnippets = true,
  store_selection_keys = '<TAB>',
  ext_opts = {
    [types.choiceNode] = {
      active = {
        virt_text = { { '●', 'DiffAdd' } },
      },
    },
    [types.insertNode] = {
      active = {
        virt_text = { { '●', 'DiffDelete' } },
      },
    },
  },
  -- Use treesitter for getting the current filetype. This allows correctly resolving
  -- the current filetype in eg. a markdown-code block or `vim.cmd()`.
  ft_func = require('luasnip.extras.filetype_functions').from_cursor,
})

-- Loading any vscode snippets from plugins
require('luasnip.loaders.from_vscode').lazy_load()

vim.keymap.set({ 'i', 's' }, '<C-k>', function()
  require('luasnip').jump(-1)
end)
vim.keymap.set({ 'i', 's' }, '<C-j>', function()
  require('luasnip').jump(1)
end)
vim.keymap.set({ 'i', 's' }, '<C-l>', function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end)
vim.keymap.set({ 'i', 's' }, '<C-h>', function()
  if ls.choice_active() then
    ls.change_choice(-1)
  end
end)
vim.keymap.set({ 'i', 's' }, '<C-u>', function()
  require('luasnip.extras.select_choice')()
end)

-- A command to edit the snippet file
vim.api.nvim_create_user_command('LuaSnipEdit', function()
  require('luasnip.loaders.from_lua').edit_snippet_files()
end, { nargs = 0, desc = 'Edits current file snippets' })

require('luasnip.loaders.from_lua').lazy_load({
  paths = config .. '/lua/snippets',
})

-- Luasnip popups
local current_nsid = vim.api.nvim_create_namespace(
  'LuaSnipChoiceListSelections'
)
local current_win = nil

local function window_for_choiceNode(choiceNode)
  local buf = vim.api.nvim_create_buf(false, true)
  local buf_text = {}
  local row_selection = 0
  local row_offset = 0
  local text
  for _, node in ipairs(choiceNode.choices) do
    text = node:get_docstring()
    -- find one that is currently showing
    if node == choiceNode.active_choice then
      -- current line is starter from buffer list which is length usually
      row_selection = #buf_text
      -- finding how many lines total within a choice selection
      row_offset = #text
    end
    vim.list_extend(buf_text, text)
  end

  vim.api.nvim_buf_set_text(buf, 0, 0, 0, 0, buf_text)
  ---@diagnostic disable-next-line: missing-parameter
  local w, h = vim.lsp.util._make_floating_popup_size(buf_text)

  -- adding highlight so we can see which one is been selected.
  local extmark = vim.api.nvim_buf_set_extmark(
    buf,
    current_nsid,
    row_selection,
    0,
    { hl_group = 'incsearch', end_line = row_selection + row_offset }
  )

  -- shows window at a beginning of choiceNode.
  local win = vim.api.nvim_open_win(buf, false, {
    relative = 'win',
    width = w,
    height = h,
    bufpos = choiceNode.mark:pos_begin_end(),
    style = 'minimal',
    border = 'rounded',
  })

  -- return with 3 main important so we can use them again
  return { win_id = win, extmark = extmark, buf = buf }
end

function _G.choice_popup(choiceNode)
  -- build stack for nested choiceNodes.
  if current_win then
    vim.api.nvim_win_close(current_win.win_id, true)
    vim.api.nvim_buf_del_extmark(
      current_win.buf,
      current_nsid,
      current_win.extmark
    )
  end
  local create_win = window_for_choiceNode(choiceNode)
  current_win = {
    win_id = create_win.win_id,
    prev = current_win,
    node = choiceNode,
    extmark = create_win.extmark,
    buf = create_win.buf,
  }
end

function _G.update_choice_popup(choiceNode)
  if not current_win then
    return
  end
  vim.api.nvim_win_close(current_win.win_id, true)
  vim.api.nvim_buf_del_extmark(
    current_win.buf,
    current_nsid,
    current_win.extmark
  )
  local create_win = window_for_choiceNode(choiceNode)
  current_win.win_id = create_win.win_id
  current_win.extmark = create_win.extmark
  current_win.buf = create_win.buf
end

function _G.choice_popup_close()
  if not current_win then
    return
  end
  vim.api.nvim_win_close(current_win.win_id, true)
  vim.api.nvim_buf_del_extmark(
    current_win.buf,
    current_nsid,
    current_win.extmark
  )
  -- now we are checking if we still have previous choice we were in after exit nested choice
  current_win = current_win.prev
  if current_win then
    -- reopen window further down in the stack.
    local create_win = window_for_choiceNode(current_win.node)
    current_win.win_id = create_win.win_id
    current_win.extmark = create_win.extmark
    current_win.buf = create_win.buf
  end
end

vim.cmd([[
augroup choice_popup
au!
au User LuasnipChoiceNodeEnter lua _G.choice_popup(require("luasnip").session.event_node)
au User LuasnipChoiceNodeLeave lua _G.choice_popup_close()
au User LuasnipChangeChoice lua _G.update_choice_popup(require("luasnip").session.event_node)
augroup END
]])

--- For some reason the events are not working on load.
--[[ vim.api.nvim_create_augroup('choice_popup', {
  clear = true,
})
vim.api.nvim_create_autocmd({ 'LuasnipChoiceNodeEnter' }, {
  group = 'choice_popup',
  callback = function()
    _G.choice_popup(require('luasnip').session.event_node)
  end,
  desc = 'Choice popup',
})
vim.api.nvim_create_autocmd({ 'LuasnipChoiceNodeLeave' }, {
  group = 'choice_popup',
  callback = function()
    _G.choice_popup_close()
  end,
  desc = 'Choice popup close',
})
vim.api.nvim_create_autocmd({ 'LuasnipChangeChoice' }, {
  group = 'choice_popup',
  callback = function()
    _G.update_choice_popup(require('luasnip').session.event_node)
  end,
  desc = 'Choice popup update',
}) ]]
