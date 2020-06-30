Config = {
	Default_Prio = 500000, -- This is the default priority value if a discord isn't found
	AllowedPerTick = 5, -- How many players should we allow to connect at a time?
	HostDisplayQueue = true,
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
		}
	}
}

Config.Rankings = {
	-- LOWER NUMBER === HIGHER PRIORITY 
	-- ['roleID'] = {rolePriority, connectQueueMessage},
	['1'] = {500, "You are being connected (donate for a better priority) [{QUEUE_NUM}/{QUEUE_MAX}]:"}, -- Discord User 
	['1'] = {400, "You are being connected (Donator Queue) [{QUEUE_NUM}/{QUEUE_MAX}]:"}, -- Donator 
	['1'] = {300, "You are being connected (Trial-Mod Queue) [{QUEUE_NUM}/{QUEUE_MAX}]:"}, -- Trial Mod 
	['1'] = {200, "You are being connected (Mod Queue) [{QUEUE_NUM}/{QUEUE_MAX}]:"}, -- Mod 
	['1'] = {100, "You are being connected (Admin Queue) [{QUEUE_NUM}/{QUEUE_MAX}]:"}, -- Admin 
	['1'] = {1, "You are being connected (Management Queue) [{QUEUE_NUM}/{QUEUE_MAX}]:"}, -- Management
}