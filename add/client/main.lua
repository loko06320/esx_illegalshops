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


local PNJ = {
	{id=1, Name=PnjWeed, VoiceName="GENERIC_INSULT_HIGH", Ambiance="AMMUCITY", Weapon=1649403952, modelHash="g_m_m_chicold_01", x = 182.35203552246, y = -938.38549804688, z = 29.091911315918, heading=53.4745941},
}

Citizen.CreateThread(function()
	Citizen.Wait(1)
	if (not generalLoaded) then
		for i=1, #PNJ do
			RequestModel(GetHashKey(PNJ[i].modelHash))
			while not HasModelLoaded(GetHashKey(PNJ[i].modelHash)) do
			Citizen.Wait(1)
			end

			RequestAnimDict('creatures@rottweiler@amb@world_dog_sitting@base')
			while not HasAnimDictLoaded('creatures@rottweiler@amb@world_dog_sitting@base') do
				Citizen.Wait(1)
			end

      PNJ[i].id = CreatePed(28, PNJ[i].modelHash, PNJ[i].x, PNJ[i].y, PNJ[i].z, PNJ[i].heading, false, false)
      TaskStartScenarioInPlace(PNJ[i].id,'WORLD_HUMAN_DRUG_DEALER', 0 , false )
    end
	end
  generalLoaded = true
end)
