ESX = nil






RegisterServerEvent('shopillegal:buyhandcuff')
AddEventHandler('shopillegal:buyhandcuff', function()

  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  xPlayer.removeMoney(Config.PriceHandcuff)
  xPlayer.addInventoryItem('handcuff', 1)
end)

RegisterServerEvent('shopillegal:buytruelle')
AddEventHandler('shopillegal:buytruelle', function()

  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  xPlayer.removeMoney(Config.PriceTruele)
  xPlayer.addInventoryItem('truele', 1)
end)

