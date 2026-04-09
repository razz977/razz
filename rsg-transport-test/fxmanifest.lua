fx_version 'cerulean'
game 'rdr3'
lua54 'yes'

name 'rsg-transport-test'
author 'razz'
description 'Test transport job with npc, ox_target and random routes'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'locales/ro.lua'
}

client_scripts {
    'client/client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/server.lua'
}

dependencies {
    'rsg-core',
    'ox_target',
    'ox_lib'
}
