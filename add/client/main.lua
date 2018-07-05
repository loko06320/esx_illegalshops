local GUI                       = {}
GUI.Time                        = 0
local generalLoaded 		        = false

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(1)
  end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
  CreateWeed()
end)


local WeedPNJ = {
	{id=1, Name=PnjWeed, VoiceName="GENERIC_INSULT_HIGH", Ambiance="AMMUCITY", Weapon=1649403952, modelHash="g_m_m_chicold_01", x = 182.35203552246, y = -938.38549804688, z = 29.091911315918, heading=53.4745941},
}

Citizen.CreateThread(function()
	Citizen.Wait(1)
	if (not generalLoaded) then
		for i=1, #WeedPNJ do
			RequestModel(GetHashKey(WeedPNJ[i].modelHash))
			while not HasModelLoaded(GetHashKey(WeedPNJ[i].modelHash)) do
			Citizen.Wait(1)
			end

			RequestAnimDict('creatures@rottweiler@amb@world_dog_sitting@base')
			while not HasAnimDictLoaded('creatures@rottweiler@amb@world_dog_sitting@base') do
				Citizen.Wait(1)
			end

      WeedPNJ[i].id = CreatePed(28, WeedPNJ[i].modelHash, WeedPNJ[i].x, WeedPNJ[i].y, WeedPNJ[i].z, WeedPNJ[i].heading, false, false)
      TaskStartScenarioInPlace(WeedPNJ[i].id,'WORLD_HUMAN_DRUG_DEALER', 0 , false )
    end
	end
  generalLoaded = true
end)
