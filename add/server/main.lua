ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('graine', function(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  local truelle  = xPlayer.getInventoryItem('truele').count

  if truelle <= 0 then
    TriggerClientEvent('esx:showNotification', source,'~r~Vous devez avoir une ~b~truelle~s~ !')
  else
    xPlayer.removeInventoryItem('graine', 1)
    TriggerClientEvent('eden_drugs:plantation', source)
    print("Graine Plante par: " ..xPlayer.name)
    TriggerClientEvent('esx:showNotification', source,'~g~Plantation~s~ en ~b~cours~s~.')
  end
end)

ESX.RegisterUsableItem('truele', function(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  TriggerClientEvent('eden_drugs:usetruelle', source)
end)

ESX.RegisterUsableItem('pelle', function(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  TriggerClientEvent('eden_drugs:usepelle', source)
  TriggerClientEvent('esx:showNotification', source,'~r~Destruction~s~ de plant en ~b~cours~s~.')
end)

RegisterServerEvent('eden_drugs:deleteweed')
AddEventHandler('eden_drugs:deleteweed', function(x)

  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  TriggerClientEvent('eden_drugs:deleteweed', _source, x)

  MySQL.Async.execute(
    'DELETE FROM position_drugs WHERE x = @x',
    {
    ['@x'] = x
    },
    function()
    end
  )
end)

RegisterServerEvent('eden_drugs:createweed')
AddEventHandler('eden_drugs:createweed', function(x, y, z,id)

  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  MySQL.Async.execute(
    'INSERT INTO position_drugs (id, identifier, name, x, y, z) VALUES (@id, @identifier, @name, @x, @y, @z)',
    {
    ['@id'] = id,
    ['@identifier'] = xPlayer.name,
    ['@name'] = 'Weed',
    ['@x']  = x,
    ['@y']  = y,
    ['@z']  = z
    },

    function(result)
    end
  )
end)

ESX.RegisterServerCallback('eden_drugs:checkplan', function(source, cb)

  MySQL.Async.fetchAll(
    'SELECT * FROM position_drugs',
    {},
    function(result)
      local data = {}
      for i=1, #result, 1 do
        table.insert(data, {
          identifier = result[i].identifier,
          name       = result[i].name,
          x          = result[i].x,
          y          = result[i].y,
          z          = result[i].z,
          percent    = result[i].percent
          })
      end
      cb(data)
    end
  )
end)

RegisterServerEvent('eden_drugs:giveweed')
AddEventHandler('eden_drugs:giveweed', function(x)
	local _source		= source
  local xPlayer  		= ESX.GetPlayerFromId(source)
  local random        = math.random(100,150)
  local randomweed    = math.random(0,100)
  local randomgraine  = math.random(1,3)

  xPlayer.addInventoryItem('weed', random)

  if randomweed <= 2 then
    xPlayer.addInventoryItem('graine', randomgraine)
  end

  TriggerClientEvent('eden_drugs:deleteweed', _source, x)

  MySQL.Async.execute(
    'DELETE FROM position_drugs WHERE x = @x',
    {
    ['@x'] = x
    },
    function()
    end
  )
end)

RegisterServerEvent('eden_drugs:buyseed')
AddEventHandler('eden_drugs:buyseed', function()

  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  xPlayer.removeMoney(Config.PriceSeed)
  xPlayer.addInventoryItem('graine', 1)
end)

RegisterServerEvent('eden_drugs:buytruelle')
AddEventHandler('eden_drugs:buytruelle', function()

  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  xPlayer.removeMoney(Config.PriceTruele)
  xPlayer.addInventoryItem('truele', 1)
end)


function UptadePourcent()

	local xPlayers 	= ESX.GetPlayers()
	local TimeUpdate = 15 -- En minutes
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		MySQL.Async.execute(
			'UPDATE position_drugs SET percent = percent + 2.09',
		 	{
		 	}
		)
	end
  SetTimeout(TimeUpdate * 60 * 1000, UptadePourcent)
end

UptadePourcent()
