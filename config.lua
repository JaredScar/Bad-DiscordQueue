Config = {
	Default_Prio = 500000, -- This is the default priority value if a discord isn't found
	AllowedPerTick = 1, -- How many players should we allow to connect at a time?
	HostDisplayQueue = true,
	onlyActiveWhenFull = false,
	Debug = true,
	Webhook = '',
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
			MSG_CONNECTING = 'You are being connected [{QUEUE_NUM}/{QUEUE_MAX}]: ', -- Default message if they have no discord roles 
			MSG_CONNECTED = 'You are up! You are being connected now :)'
		},
	},
}

Config.Rankings = {
	-- LOWER NUMBER === HIGHER PRIORITY 
	-- ['roleID'] = {rolePriority, connectQueueMessage},
	['Member'] = {500, "You are being connected (you are not as special as Badger) [{QUEUE_NUM}/{QUEUE_MAX}]:"}, -- Discord User 
	['Staff'] = {100, "You are being connected (Staff Queue) [{QUEUE_NUM}/{QUEUE_MAX}]:"}, -- Staff 
	['Admin'] = {50, "You are being connected (Admin Queue) [{QUEUE_NUM}/{QUEUE_MAX}]:"}, -- Admin
	['Founder'] = {1, "You are being connected (Founder Queue) [{QUEUE_NUM}/{QUEUE_MAX}]:"}, -- Founder
}