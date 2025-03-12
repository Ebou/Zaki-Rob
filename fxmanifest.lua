fx_version 'adamant'
games { 'gta5' }

author 'Resmon - FH & EN'
description 'Drugphone'
version '1.0.0'
lua54 'yes'

shared_scripts {
	'@ox_lib/init.lua',
	'config.lua',
	'@es_extended/imports.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/server.lua',
}

client_scripts {
	'client/utils.lua',
	'client/client.lua',
}

dependency '/assetpacks'

