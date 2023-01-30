local reports = {}

-- yoinked from here: https://gist.github.com/jrus/3197011
local function uuid()
    local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function(c)
        local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
        return string.format('%x', v)
    end)
end

local function sendNotificationToStaff()
    for _, playerId in ipairs(GetPlayers()) do
        if IsPlayerAceAllowed(playerId, Config.AcePermName) then
            TriggerClientEvent('qw_reports:client:sendNotification', playerId)
        end
    end
end

local function buildDiscordMessage(reportingPlayerId, reportData)
    local message = '**Identifiers:** \n\n'

    for _, v in pairs(GetPlayerIdentifiers(reportingPlayerId)) do
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            message = message .. '**SteamID: **' .. '||' .. v .. '||' .. '\n'
        elseif string.sub(v, 1, string.len("license:")) == "license:" then
            message = message .. '**License: **' .. '||' .. v .. '||' .. '\n'
        elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
            message = message .. '**XBL: **' .. '||' .. v .. '||' .. '\n'
        elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
            message = message .. '**IP: **' .. '||' .. v .. '||' .. '\n'
        elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
            message = message .. '**Discord: **' .. '||' .. v .. '||' .. '\n'
        elseif string.sub(v, 1, string.len("live:")) == "live:" then
            message = message .. '**Live: **' .. '||' .. v .. '||' .. '\n'
        end
    end

    message = message .. '\n' .. '**Report Details:** \n\n'

    message = message .. 'Report Title: ' .. '**' .. reportData.report_title .. '**' .. '\n'
    message = message .. 'Report Details: ' .. '**' .. reportData.report_details .. '**' .. '\n'
    message = message .. 'Report ID: ' .. '**' .. reportData.report_id .. '**' .. '\n'

    return message
end

local function sendDiscordNotification(reportingPlayerId, reportData)
    local message = buildDiscordMessage(reportingPlayerId, reportData)
    local playerName = GetPlayerName(reportingPlayerId)

    local embedData = {
        ['title'] = 'Report from ' .. playerName .. ' (' .. tostring(reportingPlayerId) .. ')',
        ['type'] = 'rich',
        ['color'] = 9807270,
        ['footer'] = {
            ['text'] = os.date('%c'),
        },
        ['description'] = message,
        ['author'] = {
            ['name'] = 'Reporting System',
            ['icon_url'] = Config.Webhook.webnhookImage,
        },
    }
    PerformHttpRequest(Config.Webhook.webhookUrl, function(err, text, headers) end, 'POST',
        json.encode({ username = 'Reporting System', embeds = { embedData }, avatar_url = Config.Webhook.webnhookImage })
        ,
        { ['Content-Type'] = 'application/json' })

end

RegisterNetEvent('qw_reports:server:createReport', function(data)
    local src = source
    local reportId = uuid()

    reports[#reports + 1] = {
        report_title = data.name,
        report_discord_name = data.discord,
        report_details = data.detail,
        report_src = src,
        report_id = reportId
    }

    if Config.Webhook.enabled then
        sendDiscordNotification(src, {
            report_title = data.name,
            report_discord_name = data.discord,
            report_details = data.detail,
            report_src = src,
            report_id = reportId
        })
    end

    sendNotificationToStaff()
end)

RegisterNetEvent('qw_reports:server:deleteReport', function(data)
    local tempTable = {}

    for _, v in ipairs(reports) do
        if v.report_id == data.report_id then goto continue end

        tempTable[#tempTable + 1] = v

        ::continue::
    end

    reports = tempTable
end)

RegisterNetEvent('qw_reports:server:actionHandler', function(reportingPlayerId, action)

    if not reportingPlayerId or not action then return end

    local src = source

    if action == 'bring' then
        local staffMember = GetPlayerPed(src)
        local reportingPlayer = GetPlayerPed(reportingPlayerId)
        local staffCoords = GetEntityCoords(staffMember)

        SetEntityCoords(reportingPlayer, staffCoords.x, staffCoords.y, staffCoords.z, false, false, false, false)
    else
        local staffMember = GetPlayerPed(src)
        local reportingPlayer = GetPlayerPed(reportingPlayerId)

        local reportingPlayerCoords = GetEntityCoords(reportingPlayer)

        SetEntityCoords(staffMember, reportingPlayerCoords.x, reportingPlayerCoords.y, reportingPlayerCoords.z, false,
            false, false, false)
    end

end)

lib.callback.register('qw_reports:server:getCurrentReports', function()
    return reports
end)

lib.callback.register('qw_reports:server:checkPerms', function(source)
    local src = source

    if IsPlayerAceAllowed(src, Config.AcePermName) then
        return true
    else
        return false
    end
end)
