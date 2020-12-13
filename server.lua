displayIndex = 1;
displays = Config.Displays.ConnectingLoop;
prefix = Config.Displays.Prefix;
currentConnectors = 0;
maxConnectors = Config.AllowedPerTick;
hostname = GetConvar("sv_hostname")
slots = GetConvarInt('sv_maxclients', 32)

StopResource('hardcap')

AddEventHandler('onResourceStop', function(resource)
  if resource == GetCurrentResourceName() then
    if GetResourceState('hardcap') == 'stopped' then
      StartResource('hardcap')
    end
  end
end)

webhookURL = Config.Webhook;
function sendToDisc(title, message, footer)
	local embed = {}
	embed = {
		{
			["color"] = 65280, -- GREEN = 65280 --- RED = 16711680
			["title"] = "**".. title .."**",
			["description"] = "" .. message ..  "",
			["footer"] = {
				["text"] = footer,
			},
		}
	}
	-- Start
	-- TODO Input Webhook
	PerformHttpRequest(webhookURL, 
	function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
  -- END
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
function sendToDiscQueue(title, message, footer)
	local embed = {}
	embed = {
		{
			["color"] = 16711680, -- GREEN = 65280 --- RED = 16711680
			["title"] = "**".. title .."**",
			["description"] = "" .. message ..  "",
			["footer"] = {
				["text"] = footer,
			},
		}
	}
	-- Start
	-- TODO Input Webhook
	PerformHttpRequest(webhookURL, 
	function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
  -- END
end

Citizen.CreateThread(function()
  while true do 
    Wait((1000 * 15)); -- Every 15 seconds
    --print("sv_maxclients is set to: " .. tostring(slots));
    --print("Queue:GetMax() is set to: " .. tostring(Queue:GetMax())); 
    if Config.HostDisplayQueue then 
      if hostname ~= "default FXServer" and Queue:GetMax() > 0 then 
        SetConvar("sv_hostname", "[" .. Queue:GetMax() .. "/" .. (Queue:GetMax() + 1) .. "] " .. hostname);
        --print(prefix .. " Set server title: '" .. "[" .. "1" .. "/" .. (Queue:GetMax() + 1) .. "] " .. hostname .. "'")
      end
      if hostname ~= "default FXServer" and Queue:GetMax() == 0 then 
        SetConvar("sv_hostname", hostname);
        --print(prefix .. " Set server title: '" .. hostname .. "'")
      end
    end
  end
end)
notSet = true;
Citizen.CreateThread(function()
  while notSet do 
    if hostname == "default FXServer" then 
      hostname = GetConvar("sv_hostname");
    else 
      notSet = false;
    end
  end 
end)

function GetPlayerCount() 
  local cout = 0;
  for _, id in pairs(GetPlayers()) do 
    cout = cout + 1;
  end
  return cout;
end
local connecting = {}
AddEventHandler('playerConnecting', function(name, setKickReason, deferrals) 
  local user = source;
  if Config.onlyActiveWhenFull == true then 
    -- It's only active when server is full so lets check 
    if GetPlayerCount() == slots then  
      deferrals.defer();
      -- It's full, activate
      if not Queue:IsSetUp(user) then 
        -- Set them up 
        Queue:SetupPriority(user);
        sendToDiscQueue("QUEUED USER", "Player `" .. GetPlayerName(user):gsub("`", "") .. "` has been added to the queue...", "Bad-DiscordQueue created by Badger");
        local message = GetMessage(user);
        local msg = message:gsub("{QUEUE_NUM}", Queue:GetQueueNum(user)):gsub("{QUEUE_MAX}", Queue:GetMax());
        print(prefix .. " " .. "Player " .. GetPlayerName(user) .. " has been set to the QUEUE [" .. msg .. "]");
      end
      while ( ( (not Queue:CheckQueue(user, currentConnectors)) or (currentConnectors == maxConnectors) ) or (GetPlayerCount() == slots) ) do 
        -- They are still in the queue 
        Wait(1000);
        if displayIndex > #displays then
          displayIndex = 1;
        end 
        local message = GetMessage(user);
        local msg = message:gsub("{QUEUE_NUM}", Queue:GetQueueNum(user)):gsub("{QUEUE_MAX}", Queue:GetMax());
        deferrals.update(prefix .. " " .. msg .. displays[displayIndex]);
        CancelEvent();
        displayIndex = displayIndex + 1;
      end
      -- If it got down here, they are now allowed to join the server 
      currentConnectors = currentConnectors + 1;
      if Config.Debug then 
        print("[Bad-DiscordQueue] currentConnectors is == " .. tostring(currentConnectors) )
      end
      connecting[ExtractIdentifiers(user).license] = true;
      print(prefix .. " " .. "Player " .. GetPlayerName(user) .. " is allowed to join now!");
      Wait(1000);
      sendToDisc("NEW CONNECTOR", "Player `" .. GetPlayerName(user):gsub("`", "") .. "` is allowed to join now!", "Bad-DiscordQueue created by Badger");
      local msg = Config.Displays.Messages.MSG_CONNECTED;
      deferrals.update(prefix .. " " .. msg);
      Wait(1);
      deferrals.done();
    else	 
      deferrals.done();--deferrals done if server is not full as we don't want the queue
    end
  else 
    deferrals.defer();
    if not Queue:IsSetUp(user) then 
      -- Set them up 
      Queue:SetupPriority(user);
      sendToDiscQueue("QUEUED USER", "Player `" .. GetPlayerName(user):gsub("`", "") .. "` has been added to the queue...", "Bad-DiscordQueue created by Badger");
      local message = GetMessage(user);
      local msg = message:gsub("{QUEUE_NUM}", Queue:GetQueueNum(user)):gsub("{QUEUE_MAX}", Queue:GetMax());
      print(prefix .. " " .. "Player " .. GetPlayerName(user) .. " has been set to the QUEUE [" .. msg .. "]");
    end
    while ( ( (not Queue:CheckQueue(user, currentConnectors)) or (currentConnectors == maxConnectors) ) or (GetPlayerCount() == slots) ) do 
      -- They are still in the queue 
      Wait(1000);
      if displayIndex > #displays then
        displayIndex = 1;
      end 
      local message = GetMessage(user);
      local msg = message:gsub("{QUEUE_NUM}", Queue:GetQueueNum(user)):gsub("{QUEUE_MAX}", Queue:GetMax());
      deferrals.update(prefix .. " " .. msg .. displays[displayIndex]);
      CancelEvent();
      displayIndex = displayIndex + 1;
    end
    -- If it got down here, they are now allowed to join the server 
    currentConnectors = currentConnectors + 1;
    if Config.Debug then 
      print("[Bad-DiscordQueue] currentConnectors is == " .. tostring(currentConnectors) )
    end
    connecting[ExtractIdentifiers(user).license] = true;
    print(prefix .. " " .. "Player " .. GetPlayerName(user) .. " is allowed to join now!");
    Wait(1000);
    sendToDisc("NEW CONNECTOR", "Player `" .. GetPlayerName(user):gsub("`", "") .. "` is allowed to join now!", "Bad-DiscordQueue created by Badger");
    local msg = Config.Displays.Messages.MSG_CONNECTED;
    deferrals.update(prefix .. " " .. msg);
    Wait(1);
    deferrals.done();
  end
end)
AddEventHandler('playerDropped', function (reason)
  local user = source;
  if (connecting[ExtractIdentifiers(user).license] ~= nil) then 
    currentConnectors = currentConnectors - 1;
    connecting[ExtractIdentifiers(user).license] = nil;
  end
  if (Queue:IsSetUp(user)) then 
    Queue:Pop(user);
    sendToDiscQueue("REMOVED QUEUE USER", "Player `" .. GetPlayerName(user):gsub("`", "") .. "` has been removed from the queue...", "Bad-DiscordQueue created by Badger");
    print(prefix .. " " .. "Player " .. GetPlayerName(user) .. " has been removed from QUEUE");
  end
end)

function GetDiscord(user)
  local discordId = nil;

  for _, id in ipairs(GetPlayerIdentifiers(user)) do
      if string.match(id, "discord:") then
          discordId = string.gsub(id, "discord:", "")
          print("Found discord id: "..discordId)
          break
      end
  end
  return discordId;
end

RegisterNetEvent('DiscordQueue:Activated')
AddEventHandler('DiscordQueue:Activated', function()
  -- They were activated, pop them from Queue 
  Queue:Pop(source);
  local user = source;
  connecting[ExtractIdentifiers(user).license] = false;
  sendToDiscQueue("REMOVED QUEUE USER", "Player `" .. GetPlayerName(user):gsub("`", "") .. "` has been removed from the queue...", "Bad-DiscordQueue created by Badger");
  currentConnectors = currentConnectors - 1;
end)
