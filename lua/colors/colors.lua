-- local pywal_core = require('pywal.core')
-- local colors = pywal_core.get_colors()
-- local background = colors.background
-- local foreground = colors.foreground
-- local cursor     = colors.cursor
-- local color0  = colors.color0
-- local color1  = colors.color1
-- local color2  = colors.color2
-- local color3  = colors.color3
-- local color4  = colors.color4
-- local color5  = colors.color5
-- local color6  = colors.color6
-- local color7  = colors.color7
-- local color8  = colors.color8
-- local color9  = colors.color9
-- local color10 = colors.color10
-- local color11 = colors.color11
-- local color12 = colors.color12
-- local color13 = colors.color13
-- local color14 = colors.color14
-- local color15 = colors.color15

-- special
local foreground= '#c0caf5'
local background= '#16161e'
local cursorColor= '#c0caf5'
-- black
local color0= '#24283b'
local color8= '#24283b'
-- red
local color1= '#f7768e'
local color9= '#f7768e'
-- green
local color2= '#9ece6a'
local color10= '#9ece6a'
-- yellow
local color3= '#ffa86f'
local color11= '#ffa86f'
-- blue
local color4= '#88afff'
local color12= '#88afff'
-- magenta
local color5= '#c3a4f8'
local color13= '#c3a4f8'
-- cyan
local color6= '#09c1dc'
local color14= '#09c1dc'
-- white
local color7= '#c0caf5'
local color15= '#c0caf5'

-- Highlights functions
-- Define bg color
-- @param group Group
-- @param color Color
local bg = function(group, col)
   vim.cmd("hi " .. group .. " guibg=" .. col)
end

-- Define fg color
-- @param group Group
-- @param color Color
local fg = function(group, col)
   vim.cmd("hi " .. group .. " guifg=" .. col)
end

-- Define bg and fg color
-- @param group Group
-- @param fgcol Fg Color
-- @param bgcol Bg Color
local fg_bg = function(group, fgcol, bgcol)
   vim.cmd("hi " .. group .. " guifg=" .. fgcol .. " guibg=" .. bgcol)
end

-- Telescope
fg_bg("TelescopeSelection", color1, cursorColor)

bg("TelescopeNormal", background)

fg_bg("TelescopePreviewTitle", color4, color0)
fg_bg("TelescopeResultsTitle", color4, color0)


-- Telescope
fg_bg("TelescopePromptNormal", foreground, background)
