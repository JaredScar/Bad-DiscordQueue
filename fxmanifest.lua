fx_version 'cerulean'
game 'gta5'

author 'JaredScar'
description 'DiscordQueue-AdaptiveCards Fork'
version '2.0'
url 'https://github.com/crusopaul/Bad-DiscordQueue'

client_scripts {
    'client.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'config.lua',
    'server.lua'
}
