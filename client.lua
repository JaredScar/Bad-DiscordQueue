alreadyTriggered = false
AddEventHandler('playerSpawned', function()
	if not alreadyTriggered then 
		alreadyTriggered = true
		 TriggerServerEvent('DiscordQueue:Activated'); -- They got past queue, deactivate them in it
	end
end)