# Documentation as well as updates to this resource have been moved to: https://docs.badger.store/fivem-discord-scripts/bad-discordqueue

## Jared's Developer Community [Discord]
[![Developer Discord](https://discordapp.com/api/guilds/597445834153525298/widget.png?style=banner4)](https://discord.com/invite/WjB5VFz)

## All I ask

All I ask is that if you enjoy this resource, please give it a like on the forum page, on GitHub (if you have an account), and pop me a follow over on GitHub.

## What is it?

This is basically a discord queue for logging into a server. When you connect to the server, you get added to a queue. Depending on your priority, you can be at the back of the queue or added to the top automatically. This all depends on what discord roles you have considering it works off of priority numbers. I'm not the best at writing descriptions. I'll be honest, I personally am probably not going to use this script, but I had a lot of people request this script from me, so here it is. Why not increase my rep within the Fivem community?

## Dependencies

https://github.com/sadboilogan/discord_perms

## Installation

https://www.youtube.com/watch?v=sjbFzkII2T0

## Screenshots 

![Queue Gif](https://i.gyazo.com/3606be50c8770850b86a83fd8efbec18.gif)

## Configuration

```
Config = {
	Default_Prio = 500000, -- This is the default priority value if a discord isn't found
	Displays = {
		Prefix = '[BadgerDiscordQueue]',
		ConnectingLoop = { 
			'🦡🌿🦡🌿🦡🌿',
			'🌿🦡🌿🦡🌿🦡',
			'🦡🌿🦡🌿🦡🥦',
			'🌿🦡🌿🦡🥦🦡',
			'🦡🌿🦡🥦🦡🥦',
			'🌿🦡🥦🦡🥦🦡',
			'🦡🥦🦡🥦🦡🥦',
			'🥦🦡🥦🦡🥦🦡',
			'🦡🥦🦡🥦🦡🌿',
			'🥦🦡🥦🦡🌿🦡',
			'🦡🥦🦡🌿🦡🌿',
			'🥦🦡🌿🦡🌿🦡',
		},
		Messages = {
			MSG_CONNECTING = 'You are being connected [{QUEUE_NUM}/{QUEUE_MAX}]: ',
			MSG_CONNECTED = 'You are up! You are being connected now :)'
		}
	}
}

Config.Rankings = {
	-- LOWER NUMBER === HIGHER PRIORITY 
	['1'] = 500, -- Discord User 
	['1'] = 400, -- Donator 
	['1'] = 300, -- Trial Mod 
	['1'] = 200, -- Mod 
	['1'] = 100, -- Admin 
	['1'] = 1, -- Management
}
```
- Replace the `'1'`s in the configuration with the discord role ID you want to set up priority for 

## Download

https://github.com/JaredScar/Bad-DiscordQueue
