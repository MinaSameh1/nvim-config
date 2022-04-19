local s = require('snippets.shorthands')

-- 'recursive' dynamic snippet. Expands to some text followed by itself.
local rec_ls = {}
rec_ls = function()
  return s.sn(
    nil,
    s.c(1, {
      -- Order is important, sn(...) first would cause infinite loop of expansion.
      s.t(''),
      s.sn(nil, { s.t({ '', '\t\\item ' }), s.i(1), s.d(2, rec_ls, {}) }),
    })
  )
end

return {
  -- rec_ls is self-referencing. That makes this snippet 'infinite' eg. have as many
  -- \item as necessary by utilizing a choiceNode.
  s.s('ls', {
    s.t({ '\\begin{itemize}', '\t\\item ' }),
    s.i(1),
    s.d(2, rec_ls, {}),
    s.t({ '', '\\end{itemize}' }),
  }),
  s.s('lls', {
    s.t({ '\\begin{enumerate}', '\t\\item ' }),
    s.i(1),
    s.d(2, rec_ls, {}),
    s.t({ '', '\\end{enumerate}' }),
  }),
  s.s(
    'gather',
    s.fmt(
      [[
    \begin{{gather*}}
    {}
    \end{{gather*}}
    ]],
      {
        s.i(1),
      }
    )
  ),
  s.s(
    'hr',
    s.fmt(
      [[
    \href{{{}}}{{{}}}
    ]],
      {
        s.i(1, 'Link(Require hyperref package)'),
        s.i(2, 'display name'),
      }
    )
  ),
  s.s(
    'vskip',
    s.fmt(
      [[
  \noalign{{\vskip{}pt}}
  ]],
      {
        s.i(1, '10'),
      }
    )
  ),
  s.s(
    'gather',
    s.fmt(
      [[
    \begin{{bmatrix}}
    {}
    \end{{bmatrix}}
    ]],
      {
        s.i(1),
      }
    )
  ),
  s.s('ff', {
    s.t('\\frac{'),
    s.i(1, 'first'),
    s.t('}{'),
    s.i(2, 'second'),
    s.t('}'),
  }, {
    condition = function()
      return vim.api.nvim_eval('vimtex#syntax#in_mathzone()') == 1
    end,
  }),
  s.s('rar', { s.t('$\\rightarrow$') }),
  s.s('bf', { s.t('\\textbf{'), s.i(1, 'bold'), s.t('}') }),
  s.s('tt', { s.t('\\texttt{'), s.i(1, 'bold'), s.t('}') }),
}
