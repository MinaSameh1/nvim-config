local parse_snippet = require('snippets.shorthands').parse_snippet
return {
  parse_snippet('trig', 'loaded!!'),
  parse_snippet(
    { trig = 'ternary', wordTrig = false },
    '${1:cond} ? ${2:true} : ${3:false}'
  ),
}
