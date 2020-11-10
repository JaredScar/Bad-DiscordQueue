displayIndex = 1;
displays = Config.Displays.ConnectingLoop;
prefix = Config.Displays.Prefix;
currentConnectors = 1;
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
        print(prefix .. " " .. "Player " .. GetPlayerName(user) .. " has been set to the QUEUE [" .. GetMessage(user) .. "]");
      end
      while ( not (Queue:CheckQueue(user)) and (currentConnectors == maxConnectors) ) or (GetPlayerCount() == slots) do 
        -- They are still in the queue 
        Wait(1000);
        if displayIndex > #displays then
          displayIndex = 1;
        end 
        local message = GetMessage(user);
        local msg = message:gsub("{QUEUE_NUM}", Queue:GetQueueNum(user)):gsub("{QUEUE_MAX}", Queue:GetMax());
        deferrals.update(prefix .. " " .. msg .. displays[displayIndex]);
        displayIndex = displayIndex + 1;
      end
      -- If it got down here, they are now allowed to join the server 
      currentConnectors = currentConnectors + 1;
      print(prefix .. " " .. "Player " .. GetPlayerName(user) .. " is allowed to join now!");
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
      local message = GetMessage(user);
      local msg = message:gsub("{QUEUE_NUM}", Queue:GetQueueNum(user)):gsub("{QUEUE_MAX}", Queue:GetMax());
      print(prefix .. " " .. "Player " .. GetPlayerName(user) .. " has been set to the QUEUE [" .. msg .. "]");
    end
    while ( not (Queue:CheckQueue(user) and (currentConnectors == maxConnectors)) or (GetPlayerCount() == slots) ) do 
      -- They are still in the queue 
      Wait(1000);
      if displayIndex > #displays then
        displayIndex = 1;
      end 
      local message = GetMessage(user);
      local msg = message:gsub("{QUEUE_NUM}", Queue:GetQueueNum(user)):gsub("{QUEUE_MAX}", Queue:GetMax());
      deferrals.update(prefix .. " " .. msg .. displays[displayIndex]);
      displayIndex = displayIndex + 1;
    end
    -- If it got down here, they are now allowed to join the server 
    currentConnectors = currentConnectors + 1;
    print(prefix .. " " .. "Player " .. GetPlayerName(user) .. " is allowed to join now!");
    local msg = Config.Displays.Messages.MSG_CONNECTED;
    deferrals.update(prefix .. " " .. msg);
    Wait(1);
    deferrals.done();
  end
end)
AddEventHandler('playerDropped', function (reason)
  local user = source;
  if (Queue:IsSetUp(user)) then 
    Queue:Pop(user);
    if currentConnectors > 1 then 
      currentConnectors = currentConnectors - 1;
    end
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
  currentConnectors = currentConnectors - 1;
end)
