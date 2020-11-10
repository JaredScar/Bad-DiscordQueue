Citizen.CreateThread(function()
	while true do 
		Citizen.Wait(0);
		TriggerServerEvent('DiscordQueue:Activated'); -- They got past queue, deactivate them in it
		return 
	end
end)