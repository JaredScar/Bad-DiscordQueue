----------------------
--- Bad-ServerList ---
----------------------
--- CONFIG ---
token = Config.BotToken;
guildID = Config.GuildID;



--- CODE ---
function DiscordRequest(method, endpoint, jsondata)
    local data = nil
    PerformHttpRequest("https://discordapp.com/api/"..endpoint, function(errorCode, resultData, resultHeaders)
        data = {data=resultData, code=errorCode, headers=resultHeaders}
    end, method, #jsondata > 0 and json.encode(jsondata) or "", {["Content-Type"] = "application/json", ["Authorization"] = "Bot " .. token})

    while data == nil do
        Citizen.Wait(0)
    end
    
    return data
end
avatars = {}
discordNames = {}
RegisterNetEvent('Bad-ServerList:SetupImg')
AddEventHandler('Bad-ServerList:SetupImg', function()
    -- Add their avatar 
    local src = source;
    local license = ExtractIdentifiers(src).license;
    -- Only run this code if they have not been set up already 
    if avatars[license] == nil then 
        local ava = GetAvatar(src);
        local discordName = GetDiscordName(src);
        if (ava ~= nil) then 
            avatars[license] = ava;
        else 
            avatars[license] = Config.Default_Profile;
        end
        if (discordName ~= nil) then 
            discordNames[license] = discordName;
        else 
            discordNames[license] = Config.Discord_Not_Found;
        end
    end
end)
AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
        -- It's this resource 
        for _, id in pairs(GetPlayers()) do 
            TriggerEvent('Bad-ServerList:SetupRestart', id);
        end
    end
end)
RegisterNetEvent('Bad-ServerList:SetupRestart')
AddEventHandler('Bad-ServerList:SetupRestart', function(src)
    -- Add their avatar 
    local ava = GetAvatar(src);
    local discordName = GetDiscordName(src);
    local license = ExtractIdentifiers(src).license;
    if (ava ~= nil) then 
        avatars[license] = ava;
    else 
        avatars[license] = Config.Default_Profile;;
    end
    if (discordName ~= nil) then 
        discordNames[license] = discordName;
    else 
        discordNames[license] = Config.Discord_Not_Found;
    end
end)
Citizen.CreateThread(function()
    while true do 
        Wait((1000 * 5)); -- Every 5 seconds, update 
        local avatarIDs = {};
        local pings = {};
        local players = {};
        local discords = {};
        for _, id in ipairs(GetPlayers()) do 
            local license = ExtractIdentifiers(id).license;
            local ping = GetPlayerPing(id); 
            players[id] = GetPlayerName(id);
            pings[id] = ping;
            if (avatars[license] ~= nil) then 
                avatarIDs[id] = avatars[license];
            else 
                avatarIDs[id] = Config.Default_Profile;
            end
            if (discordNames[license] ~= nil) then 
                discords[id] = discordNames[license]
            else 
                discords[id] = Config.Discord_Not_Found;
            end
        end
        TriggerClientEvent('Bad-ServerList:PlayerUpdate', -1, players)
        TriggerClientEvent('Bad-ServerList:PingUpdate', -1, pings)
        TriggerClientEvent('Bad-ServerList:ClientUpdate', -1, avatarIDs)
        TriggerClientEvent('Bad-ServerList:DiscordUpdate', -1, discords)
    end
end)


function GetAvatar(user) 
    local discordId = nil
    local imgURL = nil;
    for _, id in ipairs(GetPlayerIdentifiers(user)) do
        if string.match(id, "discord:") then
            discordId = string.gsub(id, "discord:", "")
            print("Found discord id: "..discordId)
            break
        end
    end
    if discordId then 
        local endpoint = ("users/%s"):format(discordId)
        local member = DiscordRequest("GET", endpoint, {})
        if member.code == 200 then
            local data = json.decode(member.data)
            if data ~= nil and data.avatar ~= nil then 
                -- It is valid data 
                --print("The data for User " .. GetPlayerName(user) .. " is: ");
                --print(data.avatar);
                if (data.avatar:sub(1, 1) and data.avatar:sub(2, 2) == "_") then 
                    --print("IMG URL: " .. "https://cdn.discordapp.com/avatars/" .. discordId .. "/" .. data.avatar .. ".gif")
                    imgURL = "https://cdn.discordapp.com/avatars/" .. discordId .. "/" .. data.avatar .. ".gif";
                else 
                    --print("IMG URL: " .. "https://cdn.discordapp.com/avatars/" .. discordId .. "/" .. data.avatar .. ".png")
                    imgURL = "https://cdn.discordapp.com/avatars/" .. discordId .. "/" .. data.avatar .. ".png"
                end
                --print("---")
            end
        end
    end
    return imgURL;
end
function GetDiscordName(user) 
    local discordId = nil
    local nameData = nil;
    for _, id in ipairs(GetPlayerIdentifiers(user)) do
        if string.match(id, "discord:") then
            discordId = string.gsub(id, "discord:", "")
            print("Found discord id: "..discordId)
            break
        end
    end
    if discordId then 
        local endpoint = ("users/%s"):format(discordId)
        local member = DiscordRequest("GET", endpoint, {})
        if member.code == 200 then
            local data = json.decode(member.data)
            if data ~= nil then 
                -- It is valid data 
                --print("The data for User " .. GetPlayerName(user) .. " is: ");
                --print(data.avatar);
                nameData = data.username .. "#" .. data.discriminator;
                --print("---")
            end
        end
    end
    return nameData;
end

function ExtractIdentifiers(src)
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
        live = ""
    }

    --Loop over all identifiers
    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)

        --Convert it to a nice table.
        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "ip") then
            identifiers.ip = id
        elseif string.find(id, "discord") then
            identifiers.discord = id
        elseif string.find(id, "license") then
            identifiers.license = id
        elseif string.find(id, "xbl") then
            identifiers.xbl = id
        elseif string.find(id, "live") then
            identifiers.live = id
        end
    end

    return identifiers
end