Queue = {}
Queue.Players = {}
Queue.SortedKeys = {}
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
	if identifierDiscord and not (Queue.Players[license] ~= nil) then
        local roles = exports.discord_perms:GetRoles(user)
        if not (roles == false) then
            for i = 1, #roles do
                for roleID, rolePrio in pairs(Config.Rankings) do
                    if tonumber(roles[i]) == tonumber(roleID) then
                        -- Return the index back to the Client script
                      	table.insert(theirPrios, rolePrio);
                    end
                end
            end
        else
            Queue.Players[license] = tonumber(Config.Default_Prio);
        end
        if #theirPrios > 0 then 
	        table.sort(theirPrios);
	        Queue.Players[license] = tonumber(theirPrios[1]) + queueIndex;
	    end 
    elseif identifierDiscord == nil then
        Queue.Players[license] = tonumber(Config.Default_Prio);
    end
    local SortedKeys = getKeysSortedByValue(Queue.Players, function(a, b) return a < b end)
    Queue.SortedKeys = SortedKeys;
    if debugg then 
	    for identifier, prio in pairs(Queue.Players) do 
	    	print("[DEBUG] " .. identifier .. " has priority of: " .. prio);
	    end
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

function Queue:CheckQueue(user) 
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
	return false; -- Still waiting in queue, not next in line 
end 

function Queue:GetMax()
	local cout = 0;
	for identifier, prio in pairs(Queue.Players) do 
		cout = cout + 1;
	end
	return cout;
end

function Queue:Config.DisplayCount(user)
	local discordId = nil;
	local license = nil;

	for _, id in ipairs(GetPlayerIdentifiers(user)) do
	    if string.match(id, "discord:") then
	        discordId = string.gsub(id, "discord:", "")
	        print("changed server title to queue count)
	    end
	    if string.match(id, "license:") then 
	    	license = string.gsub(id, "license:", "")
				if queue.count = nil
					return message.channel.send("Succesfull!")
					elseif = queue.count not = nil
					then return change server.title.queue.count
	    end
	end
	if (Queue.Players[license] ~= nil) then 
		return true;
	end 
	return false;
end

function Queue:GetQueueNum(user)
	local cout = 0;
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
	for identifier, prio in pairs(Queue.Players) do 
		cout = cout + 1;
		if identifier == license then 
			return cout;
		end
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
