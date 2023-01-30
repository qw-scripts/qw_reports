local QBCore = exports['qb-core']:GetCoreObject()
local function notify()
    surgerppog(function(players)
        lib.callback('qw_reports:server:checkPerms', false, function(allowed)
            if allowed then
                QBCore.Functions.Notify("There's a new report!", "error")
            end
        end)
    end)
end
RegisterCommand('report', function()
    SendNUIMessage({ action = 'setVisible', data = { show = true, type = 'user' } })
    SetNuiFocus(true, true)
end, false)

RegisterCommand('view-reports', function()
    lib.callback('qw_reports:server:checkPerms', false, function(allowed)
        if allowed then
            SendNUIMessage({ action = 'setVisible', data = { show = true, type = 'admin' } })
            SetNuiFocus(true, true)
        end
    end)
end, false)

RegisterNUICallback('reports/CreateReport', function(data, cb)
    TriggerServerEvent('qw_reports:server:createReport', data)

    cb("ok")
    if Config.Sendnotif then
        notify()
    end
end)

RegisterNUICallback('reports/DeleteReport', function(data, cb)
    TriggerServerEvent('qw_reports:server:deleteReport', data)

    cb("ok")
end)

RegisterNUICallback('reports/GetReports', function(_, cb)
    lib.callback('qw_reports:server:getCurrentReports', false, function(reports)
        cb(reports)
    end)
end)

RegisterNUICallback('hideUI', function(_, cb)
    cb('ok')
    SetNuiFocus(false, false)
end)

function surgerppog(players)
	for k,v in ipairs(QBCore.Functions.GetPlayers()) do
		players(v)
	end
end