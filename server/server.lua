ESX = exports["es_extended"]:getSharedObject()
local ox_inventory = exports.ox_inventory
local atmRobbed = {}
local tankobbed = {}

local WebHook = ''

ESX.RegisterServerCallback('zf_robberies:interactwithATM', function(source, cb, atmEntity)
    local atmId = tostring(atmEntity)
   
    if atmRobbed[atmId] then
        cb(false)
    else
        atmRobbed[atmId] = true
        cb(true)
    end
end)

RegisterServerEvent('zf_robberies:interactwithATM')
AddEventHandler('zf_robberies:interactwithATM', function(lol)
    if lol then
        PRIS = math.random(Config.MinReward, Config.MaxReward)
        exports.ox_inventory:AddItem(source, "black_money", PRIS)
        local steamid, license, discord = 'Ukendt', 'Ukendt', 'Ukendt'

        for k, v in ipairs(GetPlayerIdentifiers(source)) do
            if string.sub(v, 1, string.len("steam:")) == "steam:" then
                steamid = v
            elseif string.sub(v, 1, string.len("license:")) == "license:" then
                license = v
            elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
                discord = v
            end
        end
        sendToDiscord(WebHook, 15418782, 'ATM ROB - SPILLER RØVER ATM', '**Spiller**: ' .. ESX.GetPlayerFromId(source).getName() .. '\n**Licens**: ' .. license .. '\n**Discord**: ' .. discord .. '\n\n**Mængde:** ' .. PRIS, 'zaki rob | ')
    else
        -- exports["fiveguard"]:fg_BanPlayer(
        --     playerId,
        --     "EULEN / REDENGINE: atm",
        --     true
        -- )
    end
end)

local hasRobbedTank = {}

RegisterServerEvent('zf_robberies:RobTank')
AddEventHandler('zf_robberies:RobTank', function(lol)
    local playerId = source
    if lol then
        if not hasRobbedTank[lol] then
            hasRobbedTank[lol] = true
            local PRIS = math.random(Config.MinTankReward, Config.MaxTankReward)
            exports.ox_inventory:AddItem(playerId, "black_money", PRIS)
            local steamid, license, discord = 'Ukendt', 'Ukendt', 'Ukendt'

            for k, v in ipairs(GetPlayerIdentifiers(playerId)) do
                if string.sub(v, 1, string.len("steam:")) == "steam:" then
                    steamid = v
                elseif string.sub(v, 1, string.len("license:")) == "license:" then
                    license = v
                elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
                    discord = v
                end
            end
            sendToDiscord(WebHook, 15418782, 'TANKSTATION ROB - SPILLER RØVER TANKSTATION', '**Spiller**: ' .. ESX.GetPlayerFromId(playerId).getName() .. '\n**Licens**: ' .. license .. '\n**Discord**: ' .. discord .. '\n\n**Mængde:** ' .. PRIS, 'zaki rob | ')
        else
            TriggerClientEvent('ox_lib:notify', source, {
                description = 'Du har allerede tømt den!',
                type = 'error',
                position = "center-left",
                duration = 10000,
            })
        end
    else
        exports["navigatehz"]:fg_BanPlayer(
            playerId,
            "EULEN / REDENGINE: ROBTANK ROB",
            true
        )
    end
end)

RegisterServerEvent('zf_robberies:FailATM')
AddEventHandler('zf_robberies:FailATM', function()
    local playerId = source
    exports.ox_inventory:RemoveItem(playerId, "hackingdevice", math.random(0, 1))
end)


ESX.RegisterServerCallback('zf_robberies:RobTank', function(source, cb, coords)
    local tankid = tostring(coords)
    local policeCount = ESX.GetNumPlayers('job', 'police')
    if policeCount < 1 then
        TriggerClientEvent('ox_lib:notify', source, {
            description = 'Der er ikke nok politi online!',
            type = 'error',
            position = "center-left"
        })
        cb(false)
    end
    if atmRobbed[tankid] then
        cb(false)
    else
        atmRobbed[tankid] = true
        cb(true)
    end
end)

function sendToDiscord2(color, name, message, footer)
    local embed = {
        {
            ["color"] = color,
            ["title"] = "**" .. name .. "**",
            ["description"] = message,
            ["footer"] = {
                ["text"] = footer .. " " .. os.date("%x %X %p"),
            },
        }
    }
    PerformHttpRequest(WebHook, function(err, text, headers) end, 'POST', json.encode({ username = name, embeds = embed }), { ['Content-Type'] = 'application/json' })
end

function sendToDiscord(webhook, color, name, message, footer)
    local embed = {
        {
            ["color"] = color,
            ["title"] = "**" .. name .. "**",
            ["description"] = message,
            ["footer"] = {
                ["text"] = footer .. " " .. os.date("%x %X %p"),
            },
        }
    }
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({ username = name, embeds = embed }), { ['Content-Type'] = 'application/json' })
end
