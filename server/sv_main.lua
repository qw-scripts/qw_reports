local reports = {}

-- yoinked from here: https://gist.github.com/jrus/3197011
local function uuid()
    local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function(c)
        local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
        return string.format('%x', v)
    end)
end

RegisterNetEvent('qw_reports:server:createReport', function(data)
    local src = source

    reports[#reports + 1] = {
        report_title = data.name,
        report_discord_name = data.discord,
        report_details = data.detail,
        report_src = src,
        report_id = uuid()
    }
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
