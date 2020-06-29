----------------------
--- Bad-ServerList ---
----------------------
AddEventHandler('playerSpawned', function()
	if not alreadySet then 
		TriggerServerEvent('Bad-ServerList:SetupImg')
		alreadySet = true;
	end 
end)
alreadySet = false;
nui = false;
pageSize = Config.PageSize;
pageCount = 1;
count = 0;
function mod(a, b)
    return a - (math.floor(a/b)*b)
end

curCount = 0;
Citizen.CreateThread(function()
	local key = 27;
	nui = false;
	local col = true;
	while true do 
		Wait(1);
		if IsControlPressed(0, key) then 
			if not nui then 
				local left = "";
				local right = "";
				col = true;
				local maxCount = 0;
				for id, ava in pairs(avatarss) do
					maxCount = maxCount + 1;
				end
				local counter = 0;
				local keys = {}
				for key, ava in pairs(avatarss) do 
					table.insert(keys, tonumber(key));
				end
				table.sort(keys);
				for key = 1, #keys do
					local id = tostring(keys[key]);
					local ava = avatarss[id];
					if (count < (pageSize * pageCount) and counter >= curCount) then 
						if (pingss[id] ~= nil and playerNames[id] ~= nil and discordNames[id] ~= nil) then 
							if col then 
								-- Left col 
								col = false;
								left = left .. '<tr class="player-box">' ..
							'<td><img src="' .. ava .. '" /></td>' ..
							'<td>' .. discordNames[id] .. '</td>' ..
							"<td>" .. playerNames[id] .. "</td>" .. 
							"<td>" .. id .. "</td>" ..
							"<td>" .. pingss[id] .. " ms</td>" ..
							"</tr>";
							else
								-- Right col 
								col = true;
								right = right .. '<tr class="player-box">' ..
							'<td><img src="' .. ava .. '" /></td>' ..
							'<td>' .. discordNames[id] .. '</td>' ..
							"<td>" .. playerNames[id] .. "</td>" .. 
							"<td>" .. id .. "</td>" ..
							"<td>" .. pingss[id] .. " ms</td>" ..
							"</tr>";
							end
							count = count + 1;
							print("Count is now: " .. count)
						end
					end 
					counter = counter + 1;
				end
				SendNUIMessage({
								addRowLeft = left,
								addRowRight = right,
								playerCount = maxCount .. " / " .. "64",
								page = "Page " .. pageCount,
								serverName = Config.ServerName
							})
				if (count >= maxCount) then 
					print("Count is=" .. count .. " and maxCount=" .. maxCount)
					count = 0;
					pageCount = 1;
					col = true;
					curCount = 0;
				end
				if (count >= (pageSize * pageCount)) then 
					pageCount = pageCount + 1;
					curCount = (pageSize * pageCount) - 10;
					col = true;
				end
				SendNUIMessage({
					display = true;
				})
				
				nui = true
		        while nui do
		            Wait(0)
		            if(IsControlPressed(0, key) == false) then
		                nui = false
		                SendNUIMessage({
		                    display = false;
		                })
		                break
		            end
	        	end
	        end 
		end
	end
end)
avatarss = {}
pingss = {}
playerNames = {}
discordNames = {}
RegisterNetEvent('Bad-ServerList:DiscordUpdate')
AddEventHandler('Bad-ServerList:DiscordUpdate', function(players)
	discordNames = {};
	for id, discordName in pairs(players) do 
		--print("[" .. id .. "] Avatar == " .. ava)
		discordNames[id] = discordName;
	end
end)
RegisterNetEvent('Bad-ServerList:PlayerUpdate')
AddEventHandler('Bad-ServerList:PlayerUpdate', function(players)
	playerNames = {};
	for id, playerName in pairs(players) do 
		--print("[" .. id .. "] Avatar == " .. ava)
		playerNames[id] = playerName;
	end
end)
RegisterNetEvent('Bad-ServerList:PingUpdate')
AddEventHandler('Bad-ServerList:PingUpdate', function(pingList)
	pingss = {};
	for id, ping in pairs(pingList) do 
		--print("[" .. id .. "] Avatar == " .. ava)
		pingss[id] = ping;
	end
end)
RegisterNetEvent('Bad-ServerList:ClientUpdate')
AddEventHandler('Bad-ServerList:ClientUpdate', function(avas)
	avatarss = {};
	for id, ava in pairs(avas) do 
		--print("[" .. id .. "] Avatar == " .. ava)
		avatarss[id] = ava;
	end
end)