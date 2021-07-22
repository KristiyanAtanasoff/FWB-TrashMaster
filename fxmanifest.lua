fx_version 'adamant'

game 'gta5'

description 'FWB-TrashMaster'

version '0.0.1'

server_scripts {
    --mysql
	'@async/async.lua',
	'@mysql-async/lib/MySQL.lua',
	'trash-s.lua'
}

client_scripts {
	'trash-c.lua',
	'config.lua'

}

dependencies {
	'mysql-async',
	'async'
}