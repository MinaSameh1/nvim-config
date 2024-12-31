return {
  'folke/snacks.nvim',
  ---@type snacks.Config
  opts = {
    dashboard = {
      preset = {
        header = [[
          _____                   _______                   _____                    _____          
         /\    \                 /::\    \                 /\    \                  /\    \         
        /::\    \               /::::\    \               /::\    \                /::\    \        
       /::::\    \             /::::::\    \             /::::\    \              /::::\    \       
      /::::::\    \           /::::::::\    \           /::::::\    \            /::::::\    \      
     /:::/\:::\    \         /:::/~~\:::\    \         /:::/\:::\    \          /:::/\:::\    \     
    /:::/__\:::\    \       /:::/    \:::\    \       /:::/__\:::\    \        /:::/__\:::\    \    
    \:::\   \:::\    \     /:::/    / \:::\    \     /::::\   \:::\    \      /::::\   \:::\    \   
  ___\:::\   \:::\    \   /:::/____/   \:::\____\   /::::::\   \:::\    \    /::::::\   \:::\    \  
 /\   \:::\   \:::\    \ |:::|    |     |:::|    | /:::/\:::\   \:::\    \  /:::/\:::\   \:::\____\ 
/::\   \:::\   \:::\____\|:::|____|     |:::|    |/:::/  \:::\   \:::\____\/:::/  \:::\   \:::|    |
\:::\   \:::\   \::/    / \:::\    \   /:::/    / \::/    \:::\  /:::/    /\::/   |::::\  /:::|____|
 \:::\   \:::\   \/____/   \:::\    \ /:::/    /   \/____/ \:::\/:::/    /  \/____|:::::\/:::/    / 
  \:::\   \:::\    \        \:::\    /:::/    /             \::::::/    /         |:::::::::/    /  
   \:::\   \:::\____\        \:::\__/:::/    /               \::::/    /          |::|\::::/    /   
    \:::\  /:::/    /         \::::::::/    /                /:::/    /           |::| \::/____/    
     \:::\/:::/    /           \::::::/    /                /:::/    /            |::|  ~|          
      \::::::/    /             \::::/    /                /:::/    /             |::|   |          
       \::::/    /               \::/____/                /:::/    /              \::|   |          
        \::/    /                 ~~                      \::/    /                \:|   |          
         \/____/                                           \/____/                  \|___|          
                                                                                                    
      ]],
      },
    },
    terminal = {
      win = {
        position = 'float',
      },
    },
    scratch = {
      win_by_ft = {
        typescript = {
          keys = {
            ['source'] = {
              '<cr>',
              function(self)
                local file = vim.api.nvim_buf_get_name(0)

                -- TSX only accepts .ts files, not .typescript
                local tsFile = file:gsub('%.typescript$', '.ts')
                os.rename(file, tsFile)

                local command = 'tsx'
                local shell_command = { command, tsFile }

                local res = vim.system(shell_command, { text = true }):wait()

                os.rename(tsFile, file)
                if res.code ~= 0 then
                  Snacks.notify.error(res.stderr or 'Unknown error.')
                  return
                end

                Snacks.notify(res.stdout)
              end,
              desc = 'Source buffer',
              mode = { 'n', 'x' },
            },
          },
        },
        javascript = {
          keys = {
            ['clearBuf'] = {
              '<leader>C',
              function(self)
                local namespace = vim.api.nvim_create_namespace('node_result')
                vim.api.nvim_buf_set_lines(self.buf, 0, -1, false, {})
                vim.api.nvim_buf_clear_namespace(self.buf, namespace, 0, -1)
              end,
              desc = 'Clear buffer',
              mode = { 'n', 'x' },
            },
            ['clearVirtText'] = {
              '<leader>c',
              function(self)
                local namespace = vim.api.nvim_create_namespace('node_result')
                vim.api.nvim_buf_clear_namespace(self.buf, namespace, 0, -1)
              end,
              desc = 'Clear buffer',
              mode = { 'n', 'x' },
            },
            ['source'] = {
              '<cr>',
              function(self)
                local namespace = vim.api.nvim_create_namespace('node_result')
                vim.api.nvim_buf_clear_namespace(self.buf, namespace, 0, -1)

                -- Inject script that makes console log output line numbers.
                local script = [[
                  'use strict';

                  const path = require('path');

                  ['debug', 'log', 'warn', 'error'].forEach((methodName) => {
                      const originalLoggingMethod = console[methodName];
                      console[methodName] = (firstArgument, ...otherArguments) => {
                          const originalPrepareStackTrace = Error.prepareStackTrace;
                          Error.prepareStackTrace = (_, stack) => stack;
                          const callee = new Error().stack[1];
                          Error.prepareStackTrace = originalPrepareStackTrace;
                          const relativeFileName = path.relative(process.cwd(), callee.getFileName());
                          const prefix = `${relativeFileName}:${callee.getLineNumber()}:`;
                          if (typeof firstArgument === 'string') {
                              originalLoggingMethod(prefix + ' ' + firstArgument, ...otherArguments);
                          } else {
                              originalLoggingMethod(prefix, firstArgument, ...otherArguments);
                          }
                      };
                  });
                ]]
                for _, line in
                  pairs(vim.api.nvim_buf_get_lines(self.buf, 0, -1, true))
                do
                  script = script .. line .. '\n'
                end

                local result = require('plenary.job')
                  :new({
                    command = 'node',
                    args = { '-e', script },
                  })
                  :sync()

                if result then
                  for _, line in pairs(result) do
                    local line_number, output =
                      line:match('%[eval%]:(%d+): (.*)')
                    -- Subtract the lines of the injected script.
                    vim.api.nvim_buf_set_extmark(
                      0,
                      namespace,
                      line_number - 21,
                      0,
                      {
                        virt_text = { { output, 'Comment' } },
                      }
                    )
                  end
                end
              end,
              desc = 'Source buffer',
              mode = { 'n', 'x' },
            },
          },
        },
      },
    },
  },
}
