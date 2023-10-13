-- Exports
local BadgerDiscordAPI = exports['Badger_Discord_API']

-- Functions
local function getDiscordId(src)
    local identifier
    local whitelisted
    local id

    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        id = GetPlayerIdentifier(src, i)

        if string.find(id, 'discord') then
            identifier = id:gsub('discord:', '')
            break
        end
    end

    return identifier
end

-- Events
local connectedDiscordIds = {}
local grace = {}
local graceCount = 0
local connections = {}
local connCount = 0

AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    deferrals.defer()
    local src = source
    local discordId = getDiscordId(src)
    local prioRoles = BadgerDiscordAPI:GetDiscordRoles(src)
    print(name..' is connecting with deferred source '..tostring(src)..' and discord '..discordId)
    Wait(0)

    if not discordId then
        deferrals.done(Config.Displays.Prefix .. ' ' .. Config.Displays.Messages.MSG_DISCORD_REQUIRED)
        print(name..' disconnected for lack of Discord')
    elseif not prioRoles then
        deferrals.done(Config.Displays.Prefix .. ' ' .. Config.Displays.Messages.MSG_MISSING_WHITELIST)
        print(name..' disconnected for lack of whitelisted role')
    elseif connectedDiscordIds[discordId] then
        deferrals.done(Config.Displays.Prefix .. ' ' .. Config.Displays.Messages.MSG_DUPLICATE_LICENSE)
        print(name..' disconnected for duplicate Discord')
    else
        local priority
        local priorityLabel

        if grace[discordId] then
            grace[discordId] = GetGameTimer()
            print('Grace prio timer reset for '..name)
            priority = -1
            priorityLabel = 'Grace'
        else
            priority = 10000

            for _,v in pairs(prioRoles) do
                for l,q in pairs(Config.Rankings) do
                    if BadgerDiscordAPI:CheckEqual(v, l) then
                        if q < priority then
                            priority = q
                            priorityLabel = l
                        end
                    end
                end
            end
        end

        deferrals.update(Config.Displays.Prefix .. ' ' .. string.format(Config.Displays.Messages.MSG_PLACED_IN_QUEUE, priorityLabel))
        print(name..' placed in queue with prio '..tostring(priorityLabel))

        MySQL.prepare.await(
            'INSERT into queueStats ( discordId, queueStartTime, queueStopTime, queueType ) values ( ?, now(), null, ? );', {
            discordId,
            priorityLabel
        })

        local dbEntryData = MySQL.prepare.await(
            'SELECT id, queueStartTime from queueStats where discordId = ? and queueStopTime is null order by queueStartTime;', {
            discordId
        })

        if dbEntryData[1] then
            local numRecords = #dbEntryData

            if numRecords > 1 then
                for i=1,(numRecords-1) do
                    MySQL.prepare.await(
                        'UPDATE queueStats a set queueStopTime = \'12/31/9999\' where id = ?;', {
                        dbEntryData[i].id
                    })
                end
            end

            dbEntryData = dbEntryData[numRecords]
        end

        local dbEntry = dbEntryData.id
        local queueStartTime = dbEntryData.queueStartTime

        connections[discordId] = {
            Priority = priority,
            Deferral = deferrals,
            Name = name,
            Source = src,
            dbEntry = dbEntry,
        }

        connCount = connCount + 1
    end
end)

AddEventHandler('playerDropped', function (reason)
    local src = source
    local discordId = getDiscordId(src)

    if discordId then
        grace[discordId] = GetGameTimer()
        graceCount = graceCount + 1
        print(GetPlayerName(src)..' disconnected')
    end
end)

RegisterNetEvent('DiscordQueue:Activated', function()
    local src = source
    local playerName = GetPlayerName(src)
    local discordId = getDiscordId(src)

    if connections[discordId] then
        MySQL.prepare.await(
            'UPDATE queueStats a set queueStopTime = now() where id = ?;', {
            connections[discordId].dbEntry
        })

        connections[discordId] = nil
        connCount = connCount - 1
        grace[discordId] = nil
        graceCount = graceCount - 1
        print(playerName..' granted Grace prio for next disconnect')
    end
end)

-- Queue Thread
CreateThread(function()
    local playerCount
    local PollDelayInMS = Config.PollDelayInSeconds * 1000
    local GracePeriodInMS = Config.GracePeriodInSeconds * 1000
    local maxConnections = GetConvarInt('sv_maxclients', 10)
    local textCount = 0
    local loadingText
    local priority

    while true do
        priority = {}

        for k,v in pairs(grace) do
            if GetGameTimer() - v > GracePeriodInMS then
                print('Grace prio removed from '..k)
                grace[k] = nil
            end
        end

        for k,v in pairs(connections) do
            if v.Name == GetPlayerName(v.Source) then
                table.insert(priority, {
                    DiscordId = k,
                    Priority = v.Priority,
                    Deferral = v.Deferral,
                    Name = v.Name,
                    Source = v.Source,
                    Loading = v.Loading,
                })
            else
                MySQL.prepare.await(
                    'UPDATE queueStats a set queueStopTime = now() where id = ?;', {
                    connections[k].dbEntry
                })

                connections[k] = nil
                connCount = connCount - 1
            end
        end

        table.sort(priority, function(a, b)
            local loadingOrder

            if (not a.Loading) and b.Loading then
                loadingOrder = true
            else
                loadingOrder = false
            end

            local priorityOrder = a.Priority < b.Priority
            local ret = false

            if
                loadingOrder
                or (
                    priorityOrder
                    and (not loadingOrder)
                )
            then
                ret = true
            end

            return ret
        end)

        loadingText = Config.Displays.LoadingText[textCount + 1]
        textCount = (textCount + 1) % #Config.Displays.LoadingText

        for k,v in ipairs(priority) do
            if v.Deferral and not v.Loading then
                if k == 1 then
                    playerCount = GetNumPlayerIndices()

                    if
                        (
                            grace[v.DiscordId]
                            and connections[v.DiscordId]
                        )
                        or playerCount + graceCount + 1 <= maxConnections
                    then
                        v.Deferral.done()
                        connections[v.DiscordId].Loading = true
                    else
                        v.Deferral.update(Config.Displays.Prefix .. ' ' .. string.format(Config.Displays.Messages.MSG_QUEUE_PLACEMENT, k, connCount) .. ' ' .. loadingText)
                    end
                else
                    v.Deferral.update(Config.Displays.Prefix .. ' ' .. string.format(Config.Displays.Messages.MSG_QUEUE_PLACEMENT, k, connCount) .. ' ' .. loadingText)
                end
            end
        end

        Wait(PollDelayInMS)
    end
end)
