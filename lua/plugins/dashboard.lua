-- ******************************
-- *         DASHBOARD          *
-- ******************************

local config_location = require('config.utils').config_location

local custom_center = {
  {
    icon = '  ',
    desc = 'New File',
    action = 'enew',
    key = 'f f',
  },
  {
    icon = '  ',
    desc = 'Recently opened files',
    action = 'Telescope oldfiles',
    key = 'f h',
  },
  {
    icon = '  ',
    desc = 'Find  File',
    action = 'Telescope find_files find_command=rg,--hidden,--files',
    key = 'f f',
  },
  {
    icon = '  ',
    desc = 'File Browser',
    action = 'Neotree toggle',
    key = 'f b',
  },
  {
    icon = '  ',
    desc = 'Find  word',
    action = 'Telescope live_grep',
    key = 'f w',
  },
  {
    icon = '  ',
    desc = 'Open Vim Config',
    action = 'Telescope dotfiles path=' .. config_location,
    key = 'f d',
  },
  {
    icon = '  ',
    desc = 'Exit Neovim',
    action = 'quit',
    key = 'Q',
  },
}

local custom_shortcuts = {
  {
    desc = ' new file',
    action = 'enew',
    group = 'DiagnosticHint',
    key = 'N',
  },
  {
    desc = ' Open Vim Config',
    action = 'Telescope find_files cwd=' .. config_location,
    group = 'Number',
    key = 'C',
  },
  {
    desc = ' Upgrade',
    action = 'Lazy sync',
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
    key = 'q',
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

-- local custom_header = {
--   [[                                                       ]],
--   [[ ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗]],
--   [[ ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║]],
--   [[ ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║]],
--   [[ ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║]],
--   [[ ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║]],
--   [[ ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝]],
--   [[                                                       ]],
-- }

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

local custom_header = {
  [[           M                 M                                           ]],
  [[           MM               MM                                           ]],
  [[           MMM.           .MMM                                           ]],
  [[           MMMMMMMMMMMMMMMMMMM                                           ]],
  [[           MMMMMMMMMMMMMMMMMMM      ___________________________________  ]],
  [[          MMMMMMMMMMMMMMMMMMMMM    |                                   | ]],
  [[         MMMMMMMMMMMMMMMMMMMMMMM   |  Talk is cheap, show me the code! | ]],
  [[        MMMMMMMMMMMMMMMMMMMMMMMM   |_   _______________________________| ]],
  [[        MMMM::- -:::::::- -::MMMM    |/                                  ]],
  [[         MM~:~   ~:::::~   ~:~MM                                         ]],
  [[    .. MMMMM::. .:::+:::. .::MMMMM ..                                    ]],
  [[          .MM::::: ._. :::::MM.                                          ]],
  [[             MMMM;:::::;MMMM                                             ]],
  [[      -MM        MMMMMMM                                                 ]],
  [[      ^  M+     MMMMMMMMM                                                ]],
  [[          MMMMMMM MM MM MM                                               ]],
  [[               MM MM MM MM                                               ]],
  [[               MM MM MM MM                                               ]],
  [[            .~~MM~MM~MM~MM~~.                                            ]],
  [[         ~~~~MM:~MM~~~MM~:MM~~~~                                         ]],
  [[        ~~~~~~==~==~~~==~==~~~~~~                                        ]],
  [[         ~~~~~~==~==~==~==~~~~~~                                         ]],
  [[             :~==~==~==~==~~                                             ]],
}

return {
  'glepnir/dashboard-nvim',
  event = { 'VimEnter', 'GuiEnter' },
  config = {
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
        icon = ' ',
        label = 'Projects',
        action = function(path)
          vim.cmd('cd ' .. path)
          return vim.cmd('Telescope find_files cwd=' .. path)
        end,
        key = '<leader>fp',
      },
      mru = { limit = 6, icon = ' ', label = 'Recent Files' },
      hide = { -- Hide stuff
        statusline = { enable = false },
        tabline = { enable = false },
        winbar = { enable = false },
      },
    },
  },
}
