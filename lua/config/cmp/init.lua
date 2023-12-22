local cmp_status_ok, cmp = pcall(require, 'cmp')
if not cmp_status_ok then
  return
end

local luasnip_ok, luasnip = pcall(require, 'luasnip')
if not luasnip_ok then
  return
end

local kindIcons = {
  Text = '',
  Method = '',
  Function = '',
  Constructor = '',
  Field = '',
  Variable = '',
  Class = 'ﴯ',
  Interface = '',
  Module = '',
  Property = 'ﰠ',
  Unit = '',
  Value = '',
  Enum = '',
  Keyword = '',
  Snippet = '',
  Color = '',
  File = '',
  Reference = '',
  Folder = '',
  EnumMember = '',
  Constant = '',
  Struct = '',
  Event = '',
  Operator = '',
  TypeParameter = '',
}

local check_backspace = function()
  local col = vim.fn.col('.') - 1
  return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s')
end

local signs = {
  { name = 'DiagnosticSignError', text = '' },
  { name = 'DiagnosticSignWarn', text = '' },
  { name = 'DiagnosticSignHint', text = '' },
  { name = 'DiagnosticSignInfo', text = '' },
}

cmp.setup({
  completion = { completeopt = 'menu,menuone,noselect' },
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      luasnip.lsp_expand(args.body) -- For `luasnip` users.
      -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    end,
  },
  mapping = {
    ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-e>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      select = true,
    }),
    ['<C-n>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<C-p>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
    -- Expand or confirm
    ['<C-Space>'] = cmp.mapping(function(fallback)
      if luasnip.expand_or_jumpable() then
        return luasnip.expand_or_jump()
      elseif cmp.visible() then
        return cmp.confirm({
          behavior = cmp.ConfirmBehavior.Insert,
          select = true,
        })
      else
        fallback()
      end
    end, { 'i', 's' }),
    -- select next or jump snippet
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif vim.b._copilot_suggestion ~= nil then
        vim.fn.feedkeys(
          vim.api.nvim_replace_termcodes(
            vim.fn['copilot#Accept'](),
            true,
            true,
            true
          ),
          ''
        )
      else
        fallback()
      end
    end, { 'i', 's' }),
    -- select prev or jump snippet
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer', max_item_count = 10 },
    { name = 'path', max_item_count = 5 },
  },
  signs = {
    active = signs,
  },
  update_in_insert = true,
  underline = true,
  severity_sort = true,
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  float = {
    focusable = false,
    style = 'minimal',
    border = 'rounded',
    source = 'always',
    header = '',
    prefix = '',
  },
  formatting = {
    format = function(entry, vim_item)
      local alias = {
        -- buffer = '[Buf]',
        -- path = '[Path]',
        -- nvim_lsp = '[LSP]',
        -- luasnip = '[LuaSnip]',
        -- ultisnips = '[UltiSnips]',
        -- nvim_lua = '[Lua]',
        -- latex_symbols = '[Latex]',
        nvim_lua = '',
        latex_symbols = '',
        nvim_lsp = 'λ',
        luasnip = '⋗',
        ultisnips = '⋗',
        buffer = 'Ω',
        path = '🖫',
      }
      -- Kind icons
      vim_item.kind = string.format(
        '%s %s',
        kindIcons[vim_item.kind],
        vim_item.kind
      ) -- This concatonates the icons with the name of the item kind

      --  I like to know my lsp names :v
      if entry.source.name == 'nvim_lsp' then
        -- I can add '['.. lspname .. ']'
        -- But decided against it, I like its look that way.
        vim_item.menu = entry.source.source.client.name
      else
        vim_item.menu = alias[entry.source.name] or entry.source.name
      end
      ---- This sorta of works but now the menu is too large,
      ---- removed for clarity.
      -- local detail = entry:get_completion_item().detail
      -- if detail then
      --   local item_detail = vim.split(detail, '%s', { trimempty = true })
      --   vim_item.menu = vim_item.menu .. ' (' .. item_detail[1] .. ')'
      -- end
      return vim_item
    end,
  },
  performance = {
    trigger_debounce_time = 150,
    throttle = 50,
    fetching_timeout = 80,
  },
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  completion = { completeopt = 'menu,menuone,noselect' },
  sources = cmp.config.sources({
    { name = 'path' },
  }, {
    { name = 'cmdline' },
  }),
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  completion = { completeopt = 'menu,menuone,noselect' },
  sources = {
    { name = 'buffer' },
  },
})

vim.api.nvim_create_autocmd('CmdWinEnter', {
  callback = function()
    require('cmp').close()
  end,
})

cmp.setup.filetype({ 'markdown', 'pandoc', 'text', 'latex' }, {
  sources = {
    {
      name = 'nvim_lsp',
      keyword_length = 8,
      group_index = 1,
      max_item_count = 20,
    },
    { name = 'luasnip' },
    { name = 'path' },
    { name = 'buffer' },
    { name = 'dictionary', keyword_length = 2 },
    { name = 'latex_symbols' },
  },
})
