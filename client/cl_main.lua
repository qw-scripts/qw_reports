local QBCore = exports['qb-core']:GetCoreObject()
local function notify()
    playerpull(function(players)
        lib.callback('qw_reports:server:checkPerms', false, function(allowed)
            if allowed then
                lib.notify({
                    title = 'New Report',
                    description = 'There\'s a new report!',
                    type = 'success'
                })
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

function playerpull(players)
	for k,v in ipairs(QBCore.Functions.GetPlayers()) do
		players(v)
	end
end