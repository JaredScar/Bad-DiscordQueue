displayIndex = 1;
displays = Config.Displays.ConnectingLoop;
prefix = Config.Displays.Prefix;
discords = {}
currentConnectors = 0;
maxConnectors = Config.AllowedPerTick;

AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
  deferrals.defer();
  local user = source;
  if not Queue:IsSetUp(user) then 
    -- Set them up 
    Queue:SetupPriority(user);
    print(prefix .. " " .. "Player " .. GetPlayerName(user) .. " has been set to the QUEUE");
  end
  while not (Queue:CheckQueue(user)) and (currentConnectors == maxConnectors) do -- Has max that can connect at a time 
    -- They are still in the queue 
    Wait(1000);
    if displayIndex > #displays then
      displayIndex = 1;
    end 
    local msg = Config.Displays.Messages.MSG_CONNECTING:gsub("{QUEUE_NUM}", Queue:GetQueueNum(user)):gsub("{QUEUE_MAX}", Queue:GetMax());
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
end)
AddEventHandler('playerDropped', function (reason)
  local user = source;
  if (Queue:IsSetUp(user)) then 
    Queue:Pop(user);
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