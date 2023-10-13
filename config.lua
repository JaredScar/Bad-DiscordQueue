Config = {
    PollDelayInSeconds = 5,
    GracePeriodInSeconds = 300, -- 5 min
    Displays = {
        Prefix = '[FiveM Server]',
        Messages = {
            MSG_DETERMINING_PRIO = 'Your information has been located. Attempting to place you in queue.',
            MSG_DETERMINING_PRIO = 'Your information has been located. Attempting to place you in queue.',
            MSG_DISCORD_REQUIRED = 'Your Discord ID was not detected. You are required to have Discord to play on this server.',
            MSG_DUPLICATE_LICENSE = 'Your Discord ID is already connected to this server.',
            MSG_MISSING_WHITELIST = 'Your Discord ID is not whitelisted.',
            MSG_PLACED_IN_QUEUE = 'You have been placed in queue with priority: %s.',
            MSG_QUEUE_PLACEMENT = 'You are in position %d / %d in queue.',
        },
        LoadingText = {
            "[█████]",
            "[████🎃]",
            "[███🎃🦇]",
            "[██🎃🦇👻]",
            "[█🎃🦇👻🐈]",
            "[🎃🦇👻🐈🧟]",
            "[🦇👻🐈🧟🐈]",
            "[👻🐈🧟🐈👻]",
            "[🐈🧟🐈👻🦇]",
            "[🧟🐈👻🦇🎃]",
            "[🐈👻🦇🎃█]",
            "[👻🦇🎃██]",
            "[🦇🎃███]",
            "[🎃████]",
        },
    },
    Rankings = {
        -- LOWER NUMBER === HIGHER PRIORITY
        -- rolePriority should be between 0 and 10000
        ['Resident'] = 10000,
        ['Dev Team'] = 5000,
        ['Admin'] = 0,
    },
}
