Config = {
	Default_Prio = 500000, -- This is the default priority value if a discord isn't found
	AllowedPerTick = 5, -- How many players should we allow to connect at a time?
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