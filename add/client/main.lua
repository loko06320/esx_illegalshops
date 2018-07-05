ESX = nil
local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local GUI                       = {}
GUI.Time                        = 0
local Weed                      = {}
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

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1)
    for i=1, #WeedPNJ do

      distanceWeedPNJ = GetDistanceBetweenCoords(WeedPNJ[i].x, WeedPNJ[i].y, WeedPNJ[i].z, GetEntityCoords(GetPlayerPed(-1)))

      if distanceWeedPNJ <= 2 then
        headsUp('Appuyez sur ~INPUT_CONTEXT~ pour acheter des objets illégaux')
        if IsControlJustPressed(1, Keys["E"]) then
          OpenMenuWeed()
        end
      end

    end
  end
end)

function OpenMenuWeed()

  local elements = {
    {label = 'Acheter des serflex',  value = 'handcuff'},
    {label = 'Acheter truelle',  value = 'truelle'}
  }

  ESX.UI.Menu.CloseAll()
  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'weed_shop',
    {
      title    = 'Marchand illégal',
      elements = elements
    },
    function(data, menu)
      if data.current.value == 'handcuff' then
        menu.close()
        TriggerServerEvent('shopillegal:buyhandcuff')
      elseif data.current.value == 'truelle' then
        menu.close()
        TriggerServerEvent('shopillegal:buytruelle')
      end
    end,
    function(data, menu)
      menu.close()
    end
  )
end

function headsUp(text)

	SetTextComponentFormat('STRING')
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
