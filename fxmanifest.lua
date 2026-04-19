fx_version 'cerulean'
game 'gta5'
lua54 'yes'

description 'Lavan Identity - Custom Whitelist Registration'
version '1.0.0'
author 'Lavan Community'

shared_script '@es_extended/imports.lua'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

client_scripts {
    'client/main.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js'
}