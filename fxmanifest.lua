-- Credits:
-- UI build process (vite, rollup): https://github.com/JustLazzy
-- initial idea for svelte boilerplate: https://github.com/project-error
fx_version 'cerulean'

game 'gta5'

author 'qw-scripts'
version '0.2.0'
description 'standalone reporting system for FiveM'

lua54 'yes'

shared_scripts {
    'shared/config.lua',
    '@ox_lib/init.lua'
}

client_scripts { 'client/*.lua' }

server_scripts { 'server/*.lua' }

ui_page 'html/index.html'

files { 'html/index.html', 'html/js/index.js', 'html/assets/index.css' }
