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

RegisterNetEvent('eden_drugs:plantation')
AddEventHandler('eden_drugs:plantation', function()
  local currentPos = GetEntityCoords(GetPlayerPed(-1))
  local id = math.random(000001,999999)

  x, y, z = table.unpack(currentPos);
  TriggerServerEvent('eden_drugs:createweed', x, y, z -1,id)
  TaskStartScenarioInPlace(GetPlayerPed(-1), "world_human_gardener_plant", 0, false)
  Citizen.Wait(10000)
  ClearPedTasks(GetPlayerPed(-1))
  Citizen.Wait(2000)
  CreateWeed()
end)

function CreateWeed()
  ESX.TriggerServerCallback('eden_drugs:checkplan', function(data)
    for i=1, #data, 1 do
      local data = data[i]
      DeleteObject(Weed[data.x])
      if data.percent <= 25 then
        Weed[data.x] = CreateObject(GetHashKey("prop_weed_01"), data.x , data.y , data.z -1.4,  false,  false, false)
		    SetEntityAsMissionEntity(Weed[data.x],true,true)
        SetEntityAlwaysPrerender(Weed[data.x],true)
        FreezeEntityPosition(Weed[data.x],true)
      elseif data.percent >= 26 and data.percent <= 50 then
        Weed[data.x] = CreateObject(GetHashKey("prop_weed_01"), data.x , data.y , data.z -1.2,  false,  false, false)
		    SetEntityAsMissionEntity(Weed[data.x],true,true)
        SetEntityAlwaysPrerender(Weed[data.x],true)
        FreezeEntityPosition(Weed[data.x],true)
      elseif data.percent >= 51 and data.percent <= 75 then
        Weed[data.x] = CreateObject(GetHashKey("prop_weed_01"), data.x , data.y , data.z - 0.8 ,  false,  false, false)
		    SetEntityAsMissionEntity(Weed[data.x],true,true)
        SetEntityAlwaysPrerender(Weed[data.x],true)
        FreezeEntityPosition(Weed[data.x],true)
      elseif data.percent >= 76 or data.percent >= 150 then
        Weed[data.x] = CreateObject(GetHashKey("prop_weed_01"), data.x , data.y , data.z ,  false,  false, false)
		    SetEntityAsMissionEntity(Weed[data.x],true,true)
        SetEntityAlwaysPrerender(Weed[data.x],true)
        FreezeEntityPosition(Weed[data.x],true)
      end
    end
  end)
end

RegisterNetEvent('eden_drugs:usetruelle')
AddEventHandler('eden_drugs:usetruelle', function(x)
  ESX.TriggerServerCallback('eden_drugs:checkplan', function(data)
    for i=1, #data, 1 do
      local data = data[i]

        distance = GetDistanceBetweenCoords(data.x, data.y, data.z, GetEntityCoords(GetPlayerPed(-1)))

        if distance < 1 then
          if data.percent < 99 then
            ESX.ShowNotification('~r~ Le plan n\'est pas mature')
          elseif data.percent >= 100 or data.percent <= 150 then
            TriggerServerEvent('eden_drugs:deleteweed', data.x)
            TaskStartScenarioInPlace(GetPlayerPed(-1), "world_human_gardener_plant", 0, false)
            Citizen.Wait(5000)
            TriggerEvent('eden_drugs:deleteweed', data.x)
            Weed[data.x] = CreateObject(GetHashKey("prop_weed_01"), data.x , data.y , data.z - 0.8 ,  false,  false, false)
            Citizen.Wait(5000)
            TriggerEvent('eden_drugs:deleteweed', data.x)
            Weed[data.x] = CreateObject(GetHashKey("prop_weed_01"), data.x , data.y , data.z - 1.2 ,  false,  false, false)
            Citizen.Wait(5000)
            TriggerEvent('eden_drugs:deleteweed', data.x)
            Weed[data.x] = CreateObject(GetHashKey("prop_weed_01"), data.x , data.y , data.z - 1.4 ,  false,  false, false)
            Citizen.Wait(5000)
            ClearPedTasks(GetPlayerPed(-1))
            TriggerServerEvent('eden_drugs:giveweed',data.x)
          end
        end
    end
  end)
end)

RegisterNetEvent('eden_drugs:deleteweed')
AddEventHandler('eden_drugs:deleteweed', function(x)
  DeleteObject(Weed[x])
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(60*1000*10)
    CreateWeed()
  end
end)

RegisterNetEvent('eden_drugs:usepelle')
AddEventHandler('eden_drugs:usepelle', function(x)
  ESX.TriggerServerCallback('eden_drugs:checkplan', function(data)
    for i=1, #data, 1 do
      local data = data[i]

        distance = GetDistanceBetweenCoords(data.x, data.y, data.z, GetEntityCoords(GetPlayerPed(-1)))

        if distance < 1 then
          TriggerServerEvent('eden_drugs:deleteweed', data.x)
        end
    end
  end)
end)

local WeedPNJ = {
	{id=1, Name=PnjWeed, VoiceName="GENERIC_INSULT_HIGH", Ambiance="AMMUCITY", Weapon=1649403952, modelHash="g_m_y_ballasout_01", x = 1054.208984375, y = -3207.4665527344, z = -40.104553222656, heading=7.17551565},
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
      TaskStartScenarioInPlace(WeedPNJ[i].id,'WORLD_HUMAN_SMOKING_POT', 0 , false )
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
        headsUp('Appuyez sur ~INPUT_CONTEXT~ pour acheter de la drogue')
        if IsControlJustPressed(1, Keys["E"]) then
          OpenMenuWeed()
        end
      end

    end
  end
end)

function OpenMenuWeed()

  local elements = {
    {label = 'Acheter des graines de cannabis',  value = 'seedweed'},
    {label = 'Acheter truelle',  value = 'truelle'}
  }

  ESX.UI.Menu.CloseAll()
  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'weed_shop',
    {
      title    = 'Graine de weed',
      elements = elements
    },
    function(data, menu)
      if data.current.value == 'seedweed' then
        menu.close()
        TriggerServerEvent('eden_drugs:buyseed')
      elseif data.current.value == 'truelle' then
        menu.close()
        TriggerServerEvent('eden_drugs:buytruelle')
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
