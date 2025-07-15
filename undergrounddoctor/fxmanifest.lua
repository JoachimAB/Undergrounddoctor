fx_version 'cerulean'
game 'gta5'

author 'Joachim'
description 'Underground Doctor for Future'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    '@qbx_core/modules/lib.lua', 
    'config.lua',
}

client_scripts {
    'client/*.lua',
}

server_scripts {
    'server/*.lua',
}

lua54 'yes'

dependencies {
    'ox_target',
    'ox_lib',      
}
