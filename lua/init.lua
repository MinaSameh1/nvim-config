require('config.plugins')
require('config.colorscheme')
require('colors.colors')
require('colors.colorpicker')

-- vimtex
vim.g.vimtex_view_method = 'zathura'
vim.g.tex_flavor = 'latex'
vim.opt.conceallevel = 1

-- DashBoard

-- For more checkout https://github.com/glepnir/dashboard-nvim/wiki/Ascii-Header-Text
vim.g.dashboard_custom_header = {
  [[      ___                                    ___     ]],
  [[     /__/\          ___        ___          /__/\    ]],
  [[     \  \:\        /__/\      /  /\        |  |::\   ]],
  [[      \  \:\       \  \:\    /  /:/        |  |:|:\  ]],
  [[  _____\__\:\       \  \:\  /__/::\      __|__|:|\:\ ]],
  [[ /__/::::::::\  ___  \__\:\ \__\/\:\__  /__/::::| \:\]],
  [[ \  \:\~~\~~\/ /__/\ |  |:|    \  \:\/\ \  \:\~~\__\/]],
  [[  \  \:\  ~~~  \  \:\|  |:|     \__\::/  \  \:\      ]],
  [[   \  \:\       \  \:\__|:|     /__/:/    \  \:\     ]],
  [[    \  \:\       \__\::::/      \__\/      \  \:\    ]],
  [[     \__\/           ~~~~                   \__\/    ]],
}

-- vim.g.dashboard_custom_header = {
-- [[  ________   _______   ________  ___      ___ ___  _____ _______]],
-- [[ |\   ___  \|\  ____\ |\   __  \|\  \    /  /|\  \|\   _ \  _   \]],
-- [[ \ \  \\ \  \ \  \___ \ \  \|\  \ \  \  /  / | \  \ \  \\\__\ \  \]],
-- [[  \ \  \\ \  \ \   __\ \ \  \\\  \ \  \/  / / \ \  \ \  \\|__| \  \]],
-- [[   \ \  \\ \  \ \  \____\ \  \\\  \ \    / /   \ \  \ \  \    \ \  \]],
-- [[    \ \__\\ \__\ \______\\ \_______\ \__/ /     \ \__\ \__\    \ \__\]],
-- [[     \|__| \|__|\|_______|\|_______|\|__|/       \|__|\|__|     \|__|]]
-- }

-- vim.g.dashboard_custom_header = {
-- [[ ███╗   ██╗██╗   ██╗██╗███╗   ███╗ ]],
-- [[ ████╗  ██║██║   ██║██║████╗ ████║ ]],
-- [[ ██╔██╗ ██║██║   ██║██║██╔████╔██║ ]],
-- [[ ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║ ]],
-- [[ ██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║ ]],
-- [[ ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝ ]]
-- }

-- vim.g.dashboard_custom_header = {
--   [[ ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗]],
--   [[ ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║]],
--   [[ ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║]],
--   [[ ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║]],
--   [[ ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║]],
--   [[ ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝]],
-- }

-- vim.g.dashboard_custom_header = {
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
