local QBCore = exports['qb-core']:GetCoreObject()

RegisterCommand('test-ui', function()
    SendNUIMessage({action = 'setVisible', data = true})
    SetNuiFocus(true, true)
end)

RegisterNUICallback('hideUI', function(_, cb)
    cb('ok')
    SetNuiFocus(false, false)
end)
