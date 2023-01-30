-- COMMANDS --

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

-- REPORTING CALLBACKS AND EVENTS --

RegisterNetEvent('qw_reports:client:sendNotification', function()
    lib.notify({
        title = 'Reports',
        description = 'new report has been submitted...',
        type = 'info',
        icon = 'flag'
    })
end)

RegisterNUICallback('reports/CreateReport', function(data, cb)
    TriggerServerEvent('qw_reports:server:createReport', data)

    cb("ok")
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

-- REPORTING ACTIONS CALLBACKS --

RegisterNUICallback('actions/actionHandler', function(data, cb)
    local reportingPlayer = data.report_src
    local action = data.action
    TriggerServerEvent('qw_reports:server:actionHandler', reportingPlayer, action)
    cb('ok')
end)

-- GENERIC CALLBACKS --

RegisterNUICallback('hideUI', function(_, cb)
    cb('ok')
    SetNuiFocus(false, false)
end)
