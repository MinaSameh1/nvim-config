local s = require('snippets.helpers')
local d = s.d
local i = s.i
local parse = s.parse
local sn = s.snippet_node
local fmta = require('luasnip.extras.fmt').fmta

-- 'recursive' dynamic snippet. Expands to some text followed by itself.
local rec_ls = {}
---@diagnostic disable-next-line: cast-local-type
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

-- See https://www.ejmastnak.com/tutorials/vim-latex/luasnip.html#tldr-hello-world-example
-- Summary: If `SELECT_RAW` is populated with a visual selection, the function
-- returns an insert node whose initial text is set to the visual selection.
-- If `SELECT_RAW` is empty, the function simply returns an empty insert node.
local get_visual = function(args, parent)
  if #parent.snippet.env.SELECT_RAW > 0 then
    return sn(nil, i(1, parent.snippet.env.SELECT_RAW))
  else -- If SELECT_RAW is empty, return a blank insert node
    return sn(nil, i(1))
  end
end

-- Some LaTeX-specific conditional expansion functions (requires VimTeX)
local tex_utils = {}
tex_utils.in_mathzone = function()
  --[[ return vim.fn['vimtex#syntax#in_mathzone']() == 1 ]]
  return vim.api.nvim_eval('vimtex#syntax#in_mathzone()') == 1
end

tex_utils.in_env = function(name)
  local is_inside = vim.fn['vimtex#env#is_inside'](name)
  return (is_inside[1] > 0 and is_inside[2] > 0)
end

tex_utils.in_tikz = function()
  return tex_utils.in_env('tikzpicture')
end

tex_utils.in_itemize = function()
  return tex_utils.in_env('itemize')
end

function tex_utils.table_node(args)
  local tabs = {}
  local count
  local table = args[1][1]:gsub('%s', ''):gsub('|', '')
  count = table:len()
  for j = 1, count do
    local iNode
    iNode = i(j)
    tabs[2 * j - 1] = iNode
    if j ~= count then
      tabs[2 * j] = s.t(' & ')
    end
  end
  return sn(nil, tabs)
end

function tex_utils.rec_table()
  return sn(nil, {
    s.c(1, {
      s.t({ '' }),
      sn(nil, {
        s.t({ '\\\\', '' }),
        s.d(1, s.table_node, { s.ai[1] }),
        s.d(2, s.rec_table, { s.ai[1] }),
      }),
    }),
  })
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
  s.s('table', {
    s.t('\\begin{tabular}{'),
    s.i(1, '0'),
    s.t({ '}', '' }),
    s.d(2, tex_utils.table_node, { 1 }, {}),
    s.d(3, tex_utils.rec_table, { 1 }),
    s.t({ '', '\\end{tabular}' }),
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
    {
      trig = 'hr',
      dscr = "The hyperref package's href{}{} command (for url links)",
    },
    fmta([[\href{<>}{<>}]], {
      i(1, 'url'),
      i(2, 'display name'),
    })
  ),

  s.s(
    { trig = 'emph', dscr = '\\emph{$VISUAL}' },
    fmta('\\emph{<>}', {
      d(1, get_visual),
    })
  ),

  s.s(
    { trig = 'textbf', dscr = '\\textbf{$VISUAL}' },
    fmta('\\textbf{<>}', {
      d(1, get_visual),
    })
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
    'bmatrix',
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
    condition = tex_utils.in_mathzone,
    show_condition = tex_utils.in_mathzone,
  }),
  -- autosnippets expand only in_mathzone or in_env except $ and ...
  s.s(
    {
      trig = 'ip',
      wordTrig = false,
      snippetType = 'autosnippet',
      dscr = 'Inner product',
    },
    fmta('\\langle <>, <> \\rangle <>', {
      i(1),
      i(2),
      i(0),
    }),
    {
      condition = tex_utils.in_mathzone,
      show_condition = tex_utils.in_mathzone,
    }
  ),

  s.s(
    {
      trig = 'fr',
      wordTrig = false,
      snippetType = 'autosnippet',
      dscr = '\frac{}{}',
    },
    fmta('\\frac{<>}{<>} <>', {
      i(1),
      i(2),
      i(0),
    }),
    {
      condition = tex_utils.in_mathzone,
      show_condition = tex_utils.in_mathzone,
    }
  ),

  s.s(
    {
      trig = 'top',
      wordTrig = false,
      snippetType = 'autosnippet',
      dscr = '^\top',
    },
    fmta('^\\top <>', {
      i(0),
    }),
    {
      condition = tex_utils.in_mathzone,
      show_condition = tex_utils.in_mathzone,
    }
  ),

  s.s('rar', { s.t('$\\rightarrow$') }),
  s.s('bf', { s.t('\\textbf{'), s.i(1, 'bold'), s.t('}') }),
  s.s('tt', { s.t('\\texttt{'), s.i(1, 'teletext?'), s.t('}') }),
  -- parse({
  --   trig = '$',
  --   wordTrig = true,
  --   snippetType = 'autosnippet',
  --   dscr = 'in-line math',
  -- }, '$ $1 $ $0'),

  parse({
    trig = '...',
    wordTrig = true,
    snippetType = 'autosnippet',
    dscr = '\\ldots',
  }, '\\ldots $0'),

  s.s(
    {
      trig = '^',
      wordTrig = true,
      snippetType = 'autosnippet',
      dscr = 'superscript box',
    },
    fmta('^{<>} <>', {
      i(1),
      i(0),
    }),
    {
      condition = tex_utils.in_mathzone,
      show_condition = tex_utils.in_mathzone,
    }
  ),

  s.s(
    {
      trig = '_',
      wordTrig = true,
      snippetType = 'autosnippet',
      dscr = 'subscript box',
    },
    fmta('_{<>} <>', {
      i(1),
      i(0),
    }),
    {
      condition = tex_utils.in_mathzone,
      show_condition = tex_utils.in_mathzone,
    }
  ),

  s.s(
    {
      trig = 'mbr',
      wordTrig = true,
      snippetType = 'autosnippet',
      dscr = '\\mathbf{R}{$1}',
    },
    fmta('\\mathbf{R}^{<>} <>', { i(1), i(0) }),
    {
      condition = tex_utils.in_mathzone,
      show_condition = tex_utils.in_mathzone,
    }
  ),

  parse(
    { trig = 'bitemize', wordTrig = false, dscr = 'begin itemize' },
    '\\begin{itemize} \n \\item $1 \n \\end{itemize}'
  ),
  s.s(
    {
      trig = 'it',
      wordTrig = false,
      --[[ snippetType = 'autosnippet', ]]
      dscr = '\\item',
    },
    fmta('\\item <>', { i(0) }),
    { condition = tex_utils.in_itemize, show_condition = tex_utils.in_itemize }
  ),

  parse(
    { trig = 'beg', wordTrig = false, dscr = 'begin env' },
    '\\begin{${1:ENV_NAME}} \n \t${2:$SELECT_DEDENT} \n \\end{$1}'
  ),
  parse(
    { trig = 'section', wordTrig = false, dscr = 'section' },
    '\\section{${1:NAME}} \n \\label{sec:$1}'
  ),

  parse(
    { trig = 'subsection', wordTrig = false, dscr = 'subsection' },
    '\\subsection{${1:NAME}} \n \\label{sec:$1}'
  ),
  parse(
    { trig = 'subsubsection', wordTrig = false, dscr = 'subsubsection' },
    '\\subsubsection{${1:NAME}} \n \\label{sec:$1}'
  ),
  parse(
    { trig = 'bequation', wordTrig = false, dscr = 'begin equation' },
    '\\begin{equation*}\n\t${1:$SELECT_DEDENT}\n\\end{equation*}'
  ),
  parse(
    { trig = 'baligned', wordTrig = false, dscr = 'begin aligned' },
    '\\begin{aligned} \n \t${1:$SELECT_DEDENT} \n \\end{aligned}'
  ),
  parse(
    { trig = 'bframe', wordTrig = false, dscr = 'begin frame' },
    '% Begin FRAME %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% \n \
    \\begin{frame} \n \\frametitle{$1} \n $2 \n \\end{frame}'
  ),
  parse(
    { trig = 'benumerate', wordTrig = false, dscr = 'begin enumerate' },
    ' \\begin{enumerate} \n \
      \\item  ${1} \n \
      \\end{enumerate}'
  ),

  parse(
    { trig = 'bmatrix', wordTrig = false, dscr = 'begin matrix' },
    ' \\begin{bmatrix} \n \
        $1 & $2 \\\\ \
        $3 & $4 \
      \\end{bmatrix}'
  ),

  parse(
    { trig = 'float_img', wordTrig = false, dscr = 'tikz float_img' },
    ' \\tikz[remember picture, overlay] \\node[anchor=center] \
      (img) at ($(current page.center)+(0,0)$) \
      {\\includegraphics[width=3.5cm]{$1}}; \n \
      \\tikz[remember picture, overlay] \\node (caption)\
      [below of=img, yshift=-0.6cm, xshift=0cm] {$0}; '
  ),
  parse(
    { trig = 'bfigure', wordTrig = false, dscr = 'begin figure' },
    ' \\begin{figure}[${1:htpb}] \
        \\centering \
        ${2:\\includegraphics[width=0.8\\textwidth]{$3}} \
        \\caption{${4:${3}}} \
        \\label{fig:${5:${3}}} \
      \\end{figure} '
  ),

  parse(
    { trig = 'bsubfigure', wordTrig = false, dscr = 'begin subfigure' },
    ' \\begin{figure}[${1:htpb}] \
         \\centering \
         \\begin{subfigure}[b]{0.3\\textwidth} \
             \\centering \
             \\includegraphics[width=\\textwidth]{${2:fig1}} \
             \\caption{${3:$2}} \
             \\label{fig:${4:$2}} \
         \\end{subfigure} \
         \\hfill \
         \\begin{subfigure}[b]{0.3\\textwidth} \
             \\centering \
             \\includegraphics[width=\\textwidth]{${5:fig2}} \
             \\caption{${6:$5}} \
             \\label{fig:${7:$5}} \
         \\end{subfigure} \
         \\hfill \
         \\begin{subfigure}[b]{0.3\\textwidth} \
             \\centering \
             \\includegraphics[width=\\textwidth]{${8:fig3}} \
             \\caption{${9:$8}} \
             \\label{fig:${10:$8}} \
         \\end{subfigure} \
            \\caption{${11:Three simple graphs}} \
            \\label{fig:${12:three graphs}} \
    \\end{figure} '
  ),

  parse(
    { trig = 'norm', wordTrig = false },
    '\\lvert ${1:$SELECT_DEDENT} \\rvert'
  ),

  parse({ trig = '*', wordTrig = false }, '\\cdot '),

  parse({ trig = 'sum', wordTrig = false }, [[\sum^{$1}_{$2}]]),

  parse(
    { trig = 'int', wordTrig = false },
    [[\int_{${1:lower}}^{${2:upper}} $3 \\,d$4]]
  ),

  parse(
    { trig = 'lim', wordTrig = false },
    [[\lim_{${1:lower}}^{${2:upper}} $3 \\,d$4]]
  ),
  parse({
    trig = 'partial_derivative',
    wordTrig = false,
    dscr = 'partial derivative',
  }, [[\frac{\partial ${1:f(x)}}{\partial ${2:x}} $0]]),

  parse(
    {
      trig = 'template_extarticle',
      wordTrig = false,
      dscr = 'standalone figure',
    },
    ' \
  \\documentclass[fontsize=14pt]{extarticle} \
\
  \\usepackage[export]{adjustbox} \
  \\usepackage{booktabs} \
  \\usepackage{geometry} \
  \\usepackage{graphicx} \
  \\usepackage{amssymb} \
  \\usepackage{amsmath} \
  \\usepackage{amsthm} \
  \\usepackage{array} \
  \\usepackage{color} \
  \\usepackage{tabu} \
  \\usepackage{multirow} \
  \\usepackage{multicol} \
  \\usepackage{makecell} \
 \
 \
  \\title{$1} \
  \\author{Mina Sameh Wadie} \
  \\date{\\today} \
 \
  \\begin{document} \
  \\maketitle \
  \\newpage \
  \\tableofcontents \
 \
  $0 \
  \\end{document} '
  ),
  parse(
    {
      trig = 'table_custom',
      wordTrig = false,
      dscr = 'Default Table look I use',
    },
    [[
\begin{tabular}{r r r r}
  \toprule
  Row & Row & Row & Row \\
  \midrule
  0       & 0       & 0           & 0          \\
  \bottomrule
\end{tabular}
  ]]
  ),
  s.parse(
    {
      trig = 'tikz_nfa',
      dscr = 'Tikz NFA Shape',
    },
    [[
\\begin{tikzpicture}
  \\draw[thick, ->] (0, 0) circle(3mm) node(q4)[anchor=center]{$q_4$};
  \\draw[thick, ->] (0, 0) circle(4mm);
  \\draw[thick, ->] (0.4, 0.15) -- (0.7, 0.15);
  \\draw[thick, ->] (0.7, -0.15) -- (0.4, -0.15);
  \\draw[thick, ->] (1,0) circle(3mm) node(q3)[anchor=center]{$q_3$};
  \\draw[thick, ->] (1.3,0.15) -- (1.7, 0.15);
  \\draw[thick, ->] (1.7, -0.15) -- (1.3, -0.15);
  \\draw[thick, ->] (2,0) circle(3mm) node(q1)[anchor=center]{$ q_1 $ };
  \\draw[thick, ->] (2.3,0.15) -- (2.7, 0.15);
  \\draw[thick, ->] (2.7, -0.15) -- (2.3, -0.15);
  \\draw[thick, ->] (3,0) circle(3mm) node(q0)[anchor=center]{$ q_0 $ };
  \\draw[thick, ->] (3, -0.7) -- (3,-0.3);
  \\draw[thick,->] (q1) +(80:-3mm) arc(80:-260:3mm) node[anchor=north]{b};
\\end{tikzpicture}
    ]]
  ),
}
