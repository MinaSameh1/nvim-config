-- Taken from https://github.com/towry/nvim and modified
local utils = require('config.utils')
local au = require('config.au')

local M = {}

-- taken from AstroNvim
local definitions = {
  {
    { 'VimLeavePre' },
    {
      group = 'force_shutdown_clients',
      callback = function()
        vim.lsp.stop_client(vim.lsp.get_clients(), true)
      end,
    },
  },
  {
    { 'BufReadPost' },
    {
      group = '_clear_fugitive_bufs',
      pattern = 'fugitive://*',
      callback = function()
        vim.cmd('set bufhidden=delete')
      end,
    },
  },
  {
    { 'BufWinEnter' },
    {
      group = '_disable_diagnostic_on_sth',
      pattern = '*',
      callback = function(args)
        local buf = args.buf
        if
          vim.b[buf].diagnostic_disable
          or vim.api.nvim_buf_line_count(0) > 40000
        then
          vim.diagnostic.disable(buf)
          return
        end
      end,
    },
  },
  {
    { 'ExitPre' },
    {
      group = '_check_exit',
      callback = function()
        local disable = true
        if disable then
          return
        end
        --- https://github.com/neovim/neovim/issues/17256
        -- local tabs_count = #vim.api.nvim_list_tabpages()
        local tabs_count = 0
        local terms_count = require('userlib.terminal').terms_count()

        if tabs_count >= 2 or terms_count >= 1 then
          print(' ')
          print('  Are you sure to quit vim ? press `c` to cancel.')
          print(' ')
          local is_true_modifed = vim.bo.modified
          vim.cmd('set modified')
          vim.defer_fn(function()
            if not is_true_modifed then
              vim.cmd('set nomodified')
            end
          end, 1)
        end
      end,
    },
  },
  -- disable something on large buffer.
  {
    { 'BufReadPre' },
    {
      group = '_disable_on_large_buf',
      callback = function(ctx)
        local buf = ctx.buf
        -- if file size is big than 100000
        if utils.is_big_file(ctx.buf) then
          vim.b[buf].is_big_file = true
          vim.b[buf].copilot_enabled = false
          vim.b[buf].autoformat_disable = true
          vim.b[buf].minicursorword_disable = true
          vim.b[buf].diagnostic_disable = true
          vim.b[buf].lsp_disable = true

          --- Handle Big Files
          vim.opt_local.filetype = ''
          vim.opt_local.syntax = 'OFF'
          vim.opt_local.swapfile = false
          vim.opt_local.foldmethod = 'manual'
          vim.opt_local.undolevels = -1
          vim.opt_local.undoreload = 0
          vim.opt_local.list = false

          vim.api.nvim_create_augroup(
            'disable_syntax_on_buf_' .. buf,
            { clear = true }
          )
          vim.api.nvim_create_autocmd('BufReadPost', {
            group = 'disable_syntax_on_buf_' .. buf,
            buffer = buf,
            once = true,
            callback = vim.schedule_wrap(function()
              local current_buf = vim.api.nvim_get_current_buf()
              if current_buf == buf then
                vim.bo[buf].syntax = ''
              end
            end),
          })
        end
      end,
    },
  },
  -- enable foldexpr
  {
    { 'BufReadPost' },
    {
      group = 'enable_foldexpr_for_buf',
      callback = function(ctx)
        local buf = ctx.buf
        local lines = vim.api.nvim_buf_line_count(buf)
        if not vim.b[buf].is_big_file and lines < 10000 then
          vim.wo.foldmethod = 'indent'
          vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        else
          vim.wo.foldmethod = 'manual'
          vim.wo.foldexpr = ''
        end
      end,
    },
  },
  -- Emit `User FileOpened` event, used by the plugins.
  {
    { 'BufRead', 'BufWinEnter', 'BufNewFile' },
    {
      group = '_file_opened',
      nested = true,
      callback = function(args)
        local buftype =
          vim.api.nvim_get_option_value('buftype', { buf = args.buf })
        if not (vim.fn.expand('%') == '' or buftype == 'nofile') then
          vim.api.nvim_del_augroup_by_name('_file_opened')
          au.do_useraucmd(au.user_autocmds.FileOpened_User)

          vim.defer_fn(function()
            vim.schedule(function()
              au.do_useraucmd(au.user_autocmds.FileOpenedAfter_User)
            end)
          end, 1)
        end
      end,
    },
  },
  {
    'ColorScheme',
    {
      group = '_colorscheme',
      callback = function()
        au.fire_event(au.events.AfterColorschemeChanged)
      end,
    },
  },
  {
    'LspAttach',
    {
      group = '_lsp_attach_event',
      callback = function(args)
        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        au.fire_event(au.events.onLspAttach, {
          client = client,
          bufnr = bufnr,
        })
      end,
    },
  },
  {
    { 'BufReadPre', 'BufNewFile' },
    {
      group = '_no_lsp_diagnostic_inside_folders',
      pattern = '*/node_modules/*',
      callback = function(args)
        local bufnr = args.buf
        assert(bufnr ~= nil)
        vim.b[bufnr].diagnostic_disable = true
        vim.b[bufnr].autoformat_disable = true
        vim.b[bufnr].lsp_disable = true
      end,
    },
  },
  {
    { 'BufWritePost' },
    {
      group = 'Notify_about_config_change',
      pattern = '*/lua/user/plugins/*',
      callback = function()
        -- may being called two times due to the auto format write.
        vim.notify(
          "Config changed, do not forget to run 'PrebundlePlugins' command!"
        )
      end,
    },
  },
  {
    { 'BufWinEnter' },
    {
      group = 'clear_search_hl_on_buf_enter',
      callback = function()
        vim.schedule(function()
          vim.cmd('nohl')
        end)
      end,
    },
  },
  {
    { 'BufDelete', 'BufNew' },
    {
      group = '_after_buf_rename',
      pattern = '*',
      callback = function(ctx)
        vim.b[ctx.buf].project_nvim_cwd = nil
      end,
    },
  },
}

au.define_autocmds(definitions)

function M.setup_events_on_startup() end

---resize kitty window, no padding when neovim is present.
local function resize_kitty()
  local kitty_aug = vim.api.nvim_create_augroup('kitty_aug', { clear = true })
  local resized = false
  vim.api.nvim_create_autocmd({ 'UIEnter' }, {
    group = kitty_aug,
    pattern = '*',
    callback = function()
      if resized then
        return
      end
      vim.schedule(function()
        resized = true
        vim.cmd(
          ':silent !kitty @ --to=$KITTY_LISTEN_ON set-spacing padding=0 margin=0'
        )
      end)
    end,
  })
  vim.api.nvim_create_autocmd('UILeave', {
    group = kitty_aug,
    pattern = '*',
    callback = function()
      if not resized then
        return
      end
      vim.cmd(
        ':silent !kitty @ --to=$KITTY_LISTEN_ON set-spacing padding=8 margin=0'
      )
    end,
  })
end

---@param opts? {resize_kitty?: boolean,on_very_lazy?:function}
function M.setup(opts)
  opts = vim.tbl_deep_extend('force', {
    resize_kitty = false,
  }, opts or {})

  M.setup_events_on_startup()

  if opts.resize_kitty then
    resize_kitty()
  end
  if type(opts.on_very_lazy) == 'function' then
    au.define_user_autocmd({
      pattern = 'VeryLazy',
      group = 'setup_on_very_lazy',
      once = true,
      callback = opts.on_very_lazy,
    })
  end
end

return M
