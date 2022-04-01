local Snip = require('snippets.shorthands')

-- 'recursive' dynamic snippet. Expands to some text followed by itself.
local rec_ls
rec_ls = function()
	return Snip.sn(
		nil,
		Snip.c(1, {
			-- Order is important, sn(...) first would cause infinite loop of expansion.
			Snip.t(""),
			Snip.sn(nil, { t({ "", "\t\\item " }), i(1), d(2, rec_ls, {}) }),
		})
	)
end

return {
  {
    -- rec_ls is self-referencing. That makes this snippet 'infinite' eg. have as many
    -- \item as necessary by utilizing a choiceNode.
    Snip.s('ls', {
      Snip.t({ '\\begin{itemize}', '\t\\item ' }),
      Snip.i(1),
      Snip.d(2, rec_ls, {}),
      Snip.t({ '', '\\end{itemize}' }),
    }),
  },
  {
    key = 'tex',
  },
}
