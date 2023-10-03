local M = {}

local util = require('lspconfig').util

M.getClient = function(bufnr)
  local clients = vim.lsp.get_clients({
    name = 'tsserver',
    bufnr = bufnr,
  })

  if #clients == 0 then
    clients = vim.lsp.get_clients({
      name = 'typescript-tools',
      bufnr = bufnr,
    })
    if #clients == 0 then
      return nil
    end
  end

  return clients[1]
end

M.makeTsExecuteCommand = function(bufnr, source, target)
  local params = {
    command = '_typescript.applyRenameFile',
    arguments = {
      {
        sourceUri = source,
        targetUri = target,
      },
    },
    title = '',
  }

  vim.lsp.buf.execute_command(params)
  return true
end

function M.rename_file()
  local source_file = vim.api.nvim_buf_get_name(0)
  local target_file

  vim.ui.input({
    prompt = 'Target : ',
    completion = 'file',
    default = source_file,
  }, function(input)
    target_file = input
  end)

  local reqOk = M.makeTsExecuteCommand(0, source_file, target_file)
  if not reqOk then
    print('Failed to rename file')
    return
  end
  vim.lsp.util.rename(source_file, target_file)
end

M.renameFile = function(opts)
  local source = vim.api.nvim_buf_get_name(0)
  local target
  vim.ui.input({ prompt = 'New path: ', default = source }, function(input)
    if input == '' or input == source or input == nil then
      return
    end
    target = input
  end)
  if opts == nil then
    opts = {}
  end
  local sourceBufnr = vim.fn.bufadd(source)
  vim.fn.bufload(sourceBufnr)
  if
    util.path.exists(target) and (opts.force == nil or opts.force == false)
  then
    local status = vim.fn.confirm('File exists! Overwrite?', '&Yes\n&No')
    if status ~= 1 then
      return false
    end
  end
  vim.fn.mkdir(vim.fn.fnamemodify(target, ':p:h'), 'p')
  local reqOk = M.makeTsExecuteCommand(
    0,
    vim.uri_from_fname(source),
    vim.uri_from_fname(target)
  )
  if not reqOk then
    print('Failed to rename file')
    return
  end
  if vim.api.nvim_get_option_value('modified', { buf = sourceBufnr }) then
    vim.api.nvim_buf_call(sourceBufnr, function()
      return vim.cmd('w!')
    end)
  end
  local didRename, renameError = vim.loop.fs_rename(source, target)
  if not didRename then
    error(
      (((('failed to move ' .. source) .. ' to ') .. target) .. ': ')
        .. renameError
    )
  end
  local targetBufnr = vim.fn.bufadd(target)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(win) == sourceBufnr then
      vim.api.nvim_win_set_buf(win, targetBufnr)
    end
  end
  vim.schedule(function()
    return vim.api.nvim_buf_delete(sourceBufnr, { force = true })
  end)
  return true
end

return M
