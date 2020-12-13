Queue = {}
Queue.Players = {}
Queue.SortedKeys = {}
Queue.Messages = {}
debugg = false;
function getKeysSortedByValue(tbl, sortFunction)
  local keys = {}
  for key in pairs(tbl) do
    table.insert(keys, key)
  end

  table.sort(keys, function(a, b)
    return sortFunction(tbl[a], tbl[b])
  end)

  return keys
end
queueIndex = 0;
function Queue:SetupPriority(user) 
	local discordId = nil;
	local license = nil;

	for _, id in ipairs(GetPlayerIdentifiers(user)) do
	    if string.match(id, "discord:") then
	        discordId = string.gsub(id, "discord:", "")
	        --print("Found discord id: "..discordId)
	    end
	    if string.match(id, "license:") then 
	    	license = string.gsub(id, "license:", "")
	    end
	end
	local identifierDiscord = discordId;
	queueIndex = queueIndex + 1;
	theirPrios = {};
	msgs = {};
	if identifierDiscord and (Queue.Players[license] == nil) then
        local roles = exports.Badger_Discord_API:GetDiscordRoles(user)
        local lastRolePrio = 99999999999999999999;
        local msg = nil;
        if not (roles == false) then
            for i = 1, #roles do
                for roleID, list in pairs(Config.Rankings) do
                	local rolePrio = list[1];
                	if exports.Badger_Discord_API:CheckEqual(roles[i], roleID) then
                        -- Return the index back to the Client script
                      	table.insert(theirPrios, rolePrio);
                      	if lastRolePrio > tonumber(rolePrio) then 
                      		msg = list[2];
                      		lastRolePrio = rolePrio;
                      	end 
                    end
                end
            end
        else
            Queue.Players[license] = tonumber(Config.Default_Prio) + queueIndex;;
            Queue.Messages[license] = Config.Displays.Messages.MSG_CONNECTING;
        end
        if #theirPrios > 0 then 
	        table.sort(theirPrios);
	        Queue.Players[license] = tonumber(theirPrios[1])  + queueIndex;
	    end 
	    if msg ~= nil then 
	    	Queue.Messages[license] = msg;
	    end
    elseif identifierDiscord == nil then
        Queue.Players[license] = tonumber(Config.Default_Prio) + queueIndex;
        Queue.Messages[license] = Config.Displays.Messages.MSG_CONNECTING;
    end
    if Queue.Players[license] == nil then 
    	Queue.Players[license] = tonumber(Config.Default_Prio) + queueIndex;
    end
    if Queue.Messages[license] == nil then 
    	Queue.Messages[license] = Config.Displays.Messages.MSG_CONNECTING;
    end
    local SortedKeys = getKeysSortedByValue(Queue.Players, function(a, b) return a < b end)
    Queue.SortedKeys = SortedKeys;
    if debugg then 
	    for identifier, prio in pairs(Queue.Players) do 
	    	print("[DEBUG] " .. identifier .. " has priority of: " .. prio);
	    end
	end 
end
function GetMessage(user)
	local discordId = nil;
	local license = nil;

	for _, id in ipairs(GetPlayerIdentifiers(user)) do
	    if string.match(id, "discord:") then
	        discordId = string.gsub(id, "discord:", "")
	        --print("Found discord id: "..discordId)
	    end
	    if string.match(id, "license:") then 
	    	license = string.gsub(id, "license:", "")
	    end
	end
	local msg = Config.Displays.Messages.MSG_CONNECTING;
	if (Queue.Messages[license] ~= nil) then 
		return Queue.Messages[license];
	else 
		return msg;
	end
end

function Queue:IsSetUp(user)
	local discordId = nil;
	local license = nil;

	for _, id in ipairs(GetPlayerIdentifiers(user)) do
	    if string.match(id, "discord:") then
	        discordId = string.gsub(id, "discord:", "")
	        --print("Found discord id: "..discordId)
	    end
	    if string.match(id, "license:") then 
	    	license = string.gsub(id, "license:", "")
	    end
	end
	if (Queue.Players[license] ~= nil) then 
		return true;
	end 
	return false;
end

function Queue:CheckQueue(user, currentConnectors) 
	local discordId = nil;
	local license = nil;

	for _, id in ipairs(GetPlayerIdentifiers(user)) do
	    if string.match(id, "discord:") then
	        discordId = string.gsub(id, "discord:", "")
	        --print("Found discord id: "..discordId)
	    end
	    if string.match(id, "license:") then 
	    	license = string.gsub(id, "license:", "")
	    end
	end
	if (Queue.SortedKeys[1] == license) then 
		return true; -- They can login 
	end
	local maxConnectors = Config.AllowedPerTick - currentConnectors;
	-- Added 12/10/20
	local count = 1;
	for k, v in pairs(Queue.SortedKeys) do 
		if Queue.SortedKeys[count] == license and count <= maxConnectors then 
			return true;
		end
		count = count + 1;
	end
	-- End add
	return false; -- Still waiting in queue, not next in line 
end 

function Queue:GetMax()
	local cout = 0;
	for identifier, prio in pairs(Queue.Players) do 
		cout = cout + 1;
	end
	return cout;
end

function Queue:GetQueueNum(user)
	local discordId = nil;
	local license = nil;
	for _, id in ipairs(GetPlayerIdentifiers(user)) do
	    if string.match(id, "discord:") then
	        discordId = string.gsub(id, "discord:", "")
	        --print("Found discord id: "..discordId)
	    end
	    if string.match(id, "license:") then 
	    	license = string.gsub(id, "license:", "")
	    end
	end
	local cout = 0;
	for i = 1, #Queue.SortedKeys do 
		local identifier = Queue.SortedKeys[i];
		if identifier == license then 
			return cout;
		end
		cout = cout + 1;
	end
	return 0;
end

function Queue:Pop(user)
	-- Pop them off the Queue 
	local discordId = nil;
	local license = nil;

	for _, id in ipairs(GetPlayerIdentifiers(user)) do
	    if string.match(id, "discord:") then
	        discordId = string.gsub(id, "discord:", "")
	        --print("Found discord id: "..discordId)
	    end
	    if string.match(id, "license:") then 
	    	license = string.gsub(id, "license:", "")
	    end
	end
	local tempQueue = {};
	for id, prio in pairs(Queue.Players) do 
		if not (id == license) then 
			tempQueue[id] = prio;
		end
	end
	Queue.Messages[license] = nil;
	Queue.Players = tempQueue;
	local SortedKeys = getKeysSortedByValue(Queue.Players, function(a, b) return a < b end)
    Queue.SortedKeys = SortedKeys;
    if debugg then 
    	print("[DEBUG] " .. GetPlayerName(user) .. " has been POPPED from QUEUE")
    end
    if debugg then 
	    for identifier, prio in pairs(Queue.Players) do 
	    	print("[DEBUG] " .. identifier .. " has priority of: " .. prio);
	    end
	end 
end