-- ******************************
-- *         DASHBOARD          *
-- ******************************

local config_location = require('config.utils').config_location
local status_ok, db = pcall(require, 'dashboard')
if not status_ok then
  print('Error in db config')
  return
end

local custom_center = {
  {
    icon = '  ',
    desc = 'New File                                 ',
    action = 'enew',
    shortcut = 'SPC f f',
  },
  {
    icon = '  ',
    desc = 'Recently opened files                    ',
    action = 'Telescope oldfiles',
    shortcut = 'SPC f h',
  },
  {
    icon = '  ',
    desc = 'Find  File                               ',
    action = 'Telescope find_files find_command=rg,--hidden,--files',
    shortcut = 'SPC f f',
  },
  {
    icon = '  ',
    desc = 'File Browser                             ',
    action = 'Neotree toggle',
    shortcut = 'SPC f b',
  },
  {
    icon = '  ',
    desc = 'Find  word                               ',
    action = 'Telescope live_grep',
    shortcut = 'SPC f w',
  },
  {
    icon = '  ',
    desc = 'Open Vim Config                   ',
    action = 'Telescope dotfiles path=' .. config_location,
    shortcut = 'SPC f d',
  },
  {
    icon = '  ',
    desc = 'Exit Neovim                              ',
    action = 'quit',
    shortcut = 'SPC s-q',
  },
}

local custom_shortcuts = {
  {
    desc = ' new file',
    action = 'enew',
    group = 'DiagnosticHint',
    key = 'N',
  },
  -- {
  --   desc = ' Recently opened files',
  --   action = 'Telescope oldfiles',
  --   group = 'Label',
  --   key = 'fh',
  -- },
  {
    desc = ' Find File',
    action = 'Telescope find_files find_command=rg,--hidden,--files',
    group = 'Label',
    key = 'ff',
  },
  {
    desc = ' File Browser',
    group = 'Label',
    action = 'Neotree toggle',
    key = 'F',
  },
  {
    desc = ' Find word',
    action = 'Telescope live_grep',
    group = 'Label',
    shortcut = 'fg',
  },
  {
    desc = ' Open Vim Config',
    action = 'Telescope find_files path=' .. config_location,
    group = 'Number',
    key = '<leader>v',
  },
  {
    desc = ' Upgrade',
    action = 'PackerSync',
    group = '@property',
    key = 'u',
  },
  {
    desc = ' Mason',
    action = 'Mason',
    group = '@property',
    key = 'M',
  },
  {
    desc = ' Exit Neovim',
    action = 'quit',
    group = '@property',
    key = '<leader>q',
  },
}

--- For more checkout https://github.com/glepnir/dashboard-nvim/wiki/Ascii-Header-Text
-- local custom_header = {
--   [[      ___                                    ___     ]],
--   [[     /__/\          ___        ___          /__/\    ]],
--   [[     \  \:\        /__/\      /  /\        |  |::\   ]],
--   [[      \  \:\       \  \:\    /  /:/        |  |:|:\  ]],
--   [[  _____\__\:\       \  \:\  /__/::\      __|__|:|\:\ ]],
--   [[ /__/::::::::\  ___  \__\:\ \__\/\:\__  /__/::::| \:\]],
--   [[ \  \:\~~\~~\/ /__/\ |  |:|    \  \:\/\ \  \:\~~\__\/]],
--   [[  \  \:\  ~~~  \  \:\|  |:|     \__\::/  \  \:\      ]],
--   [[   \  \:\       \  \:\__|:|     /__/:/    \  \:\     ]],
--   [[    \  \:\       \__\::::/      \__\/      \  \:\    ]],
--   [[     \__\/           ~~~~                   \__\/    ]],
-- }

-- local custom_header = {
-- [[  ________   _______   ________  ___      ___ ___  _____ _______]],
-- [[ |\   ___  \|\  ____\ |\   __  \|\  \    /  /|\  \|\   _ \  _   \]],
-- [[ \ \  \\ \  \ \  \___ \ \  \|\  \ \  \  /  / | \  \ \  \\\__\ \  \]],
-- [[  \ \  \\ \  \ \   __\ \ \  \\\  \ \  \/  / / \ \  \ \  \\|__| \  \]],
-- [[   \ \  \\ \  \ \  \____\ \  \\\  \ \    / /   \ \  \ \  \    \ \  \]],
-- [[    \ \__\\ \__\ \______\\ \_______\ \__/ /     \ \__\ \__\    \ \__\]],
-- [[     \|__| \|__|\|_______|\|_______|\|__|/       \|__|\|__|     \|__|]]
-- }

-- local custom_header = {
-- [[ ███╗   ██╗██╗   ██╗██╗███╗   ███╗ ]],
-- [[ ████╗  ██║██║   ██║██║████╗ ████║ ]],
-- [[ ██╔██╗ ██║██║   ██║██║██╔████╔██║ ]],
-- [[ ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║ ]],
-- [[ ██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║ ]],
-- [[ ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝ ]]
-- }

local custom_header = {
  [[                                                       ]],
  [[ ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗]],
  [[ ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║]],
  [[ ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║]],
  [[ ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║]],
  [[ ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║]],
  [[ ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝]],
  [[                                                       ]],
}

-- local custom_header = {
-- [[ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡀⠀⠀⠀⠀⢀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
-- [[ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡖⠁⠀⠀⠀⠀⠀⠀⠈⢲⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
-- [[ ⠀⠀⠀⠀⠀⠀⠀⠀⣼⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣧⠀⠀⠀⠀⠀⠀⠀⠀]],
-- [[ ⠀⠀⠀⠀⠀⠀⠀⣸⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⣇⠀⠀⠀⠀⠀⠀⠀]],
-- [[ ⠀⠀⠀⠀⠀⠀⠀⣿⣿⡇⠀⢀⣀⣤⣤⣤⣤⣀⡀⠀⢸⣿⣿⠀⠀⠀⠀⠀⠀⠀]],
-- [[ ⠀⠀⠀⠀⠀⠀⠀⢻⣿⣿⣔⢿⡿⠟⠛⠛⠻⢿⡿⣢⣿⣿⡟⠀⠀⠀⠀⠀⠀⠀]],
-- [[ ⠀⠀⠀⠀⣀⣤⣶⣾⣿⣿⣿⣷⣤⣀⡀⢀⣀⣤⣾⣿⣿⣿⣷⣶⣤⡀⠀⠀⠀⠀]],
-- [[ ⠀⠀⢠⣾⣿⡿⠿⠿⠿⣿⣿⣿⣿⡿⠏⠻⢿⣿⣿⣿⣿⠿⠿⠿⢿⣿⣷⡀⠀⠀]],
-- [[ ⠀⢠⡿⠋⠁⠀⠀⢸⣿⡇⠉⠻⣿⠇⠀⠀⠸⣿⡿⠋⢰⣿⡇⠀⠀⠈⠙⢿⡄⠀]],
-- [[ ⠀⡿⠁⠀⠀⠀⠀⠘⣿⣷⡀⠀⠰⣿⣶⣶⣿⡎⠀⢀⣾⣿⠇⠀⠀⠀⠀⠈⢿⠀]],
-- [[ ⠀⡇⠀⠀⠀⠀⠀⠀⠹⣿⣷⣄⠀⣿⣿⣿⣿⠀⣠⣾⣿⠏⠀⠀⠀⠀⠀⠀⢸⠀]],
-- [[ ⠀⠁⠀⠀⠀⠀⠀⠀⠀⠈⠻⢿⢇⣿⣿⣿⣿⡸⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠈⠀]],
-- [[ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣼⣿⣿⣿⣿⣧⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
-- [[ ⠀⠀⠀⠐⢤⣀⣀⢀⣀⣠⣴⣿⣿⠿⠋⠙⠿⣿⣿⣦⣄⣀⠀⠀⣀⡠⠂⠀⠀⠀]],
-- [[ ⠀⠀⠀⠀⠀⠈⠉⠛⠛⠛⠛⠉⠀⠀⠀⠀⠀⠈⠉⠛⠛⠛⠛⠋⠁⠀⠀⠀⠀⠀]],
-- }

-- local custom_header = {
--   [[                        .,,cc,,,.                                ]],
--   [[                   ,c$$$$$$$$$$$$cc,                             ]],
--   [[                ,c$$$$$$$$$$??""??$?? ..                         ]],
--   [[             ,z$$$$$$$$$$$P xdMMbx  nMMMMMb                      ]],
--   [[            r")$$$$??$$$$" dMMMMMMb "MMMMMMb                     ]],
--   [[          r",d$$$$$>;$$$$ dMMMMMMMMb MMMMMMM.                    ]],
--   [[         d'z$$$$$$$>'"""" 4MMMMMMMMM MMMMMMM>                    ]],
--   [[        d'z$$$$$$$$h $$$$r`MMMMMMMMM "MMMMMM                     ]],
--   [[        P $$$$$$$$$$.`$$$$.'"MMMMMP',c,"""'..                    ]],
--   [[       d',$$$$$$$$$$$.`$$$$$c,`""_,c$$$$$$$$h                    ]],
--   [[       $ $$$$$$$$$$$$$.`$$$$$$$$$$$"     "$$$h                   ]],
--   [[      ,$ $$$$$$$$$$$$$$ $$$$$$$$$$%       `$$$L                  ]],
--   [[      d$c`?$$$$$$$$$$P'z$$$$$$$$$$c       ,$$$$.                 ]],
--   [[      $$$cc,"""""""".zd$$$$$$$$$$$$c,  .,c$$$$$F                 ]],
--   [[     ,$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$                 ]],
--   [[     d$$$$$$$$$$$$$$$$c`?$$$$$$$$$$$$$$$$$$$$$$$                 ]],
--   [[     ?$$$$$$$$$."$$$$$$c,`..`?$$$$$$$$$$$$$$$$$$.                ]],
--   [[     <$$$$$$$$$$. ?$$$$$$$$$h $$$$$$$$$$$$$$$$$$>                ]],
--   [[      $$$$$$$$$$$h."$$$$$$$$P $$$$$$$$$$$$$$$$$$>                ]],
--   [[      `$$$$$$$$$$$$ $$$$$$$",d$$$$$$$$$$$$$$$$$$>                ]],
--   [[       $$$$$$$$$$$$c`""""',c$$$$$$$$$$$$$$$$$$$$'                ]],
--   [[       "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$F                 ]],
--   [[        "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$'                  ]],
--   [[        ."?$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$P'                   ]],
--   [[     ,c$$c,`?$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"  THE TIME HE WASTES ]],
--   [[   z$$$$$P"   ""??$$$$$$$$$$$$$$$$$$$$$$$"  IN RICING NVIM IS    ]],
--   [[,c$$$$$P"          .`""????????$$$$$$$$$$c  DRIVING ME CRAZY.    ]],
--   [[`"""              ,$$$L.        "?$$$$$$$$$.   WHAT'S THE MATTER ]],
--   [[               ,cd$$$$$$$$$hc,    ?$$$$$$$$$c    WITH HIM ?????? ]],
--   [[              `$$$$$$$$$$$$$$$.    ?$$$$$$$$$h                   ]],
--   [[               `?$$$$$$$$$$$$P      ?$$$$$$$$$   GO DO SOMETHING ]],
--   [[                 `?$$$$$$$$$P        ?$$$$$$$$$$$$hc WITH YOUR   ]],
--   [[                   "?$$$$$$"         <$$$$$$$$$$$$$$r    TIME!   ]],
--   [[                     `""""           <$$$$$$$$$$$$$$F            ]],
--   [[                                      $$$$$$$$$$$$$F             ]],
--   [[                                      `?$$$$$$$$P"               ]],
--   [[                                        "????""                  ]],
-- }

db.setup({
  theme = 'hyper', -- 'doom' or 'hyper'
  config = {
    header = custom_header,
    -- week_header = { enable = true }, -- Show week name
    center = custom_center,
    shortcut = custom_shortcuts,
    packages = { enable = true },
    -- limit how many projects list, action when you press key or enter it will run this action.
    project = { -- only for hyper
      limit = 8,
      icon = '',
      label = 'Projects',
      action = 'Telescope find_files cwd=',
      key = '<leader>fp',
    },
    mru = { limit = 6, icon = '', label = 'Recent Files' },
    hide = { -- Hide stuff
      statusline = { enable = false },
      tabline = { enable = false },
      winbar = { enable = false },
    },
  },
})
