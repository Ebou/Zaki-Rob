hackAtm = function(entity, coords)
    ExecuteCommand("e texting")
    ESX.TriggerServerCallback('zf_robberies:interactwithATM', function(success)
        if not success then
            lib.notify({
                id = 'checkATMStatus',
                title = 'Hæveautomats Hack',
                description = 'Du kan ikke røve denne lige nu!',
                showDuration = false,
                position = 'top',
                icon = 'ban',
                iconColor = '#C53030'
            })
            ClearPedTasks(PlayerPedId())

            return
        end

        if lib.progressBar({
                duration = 2000,
                label = 'Trækker Hacking Device Frem',
                useWhileDead = false,
                canCancel = false,
            }) then
            local coords = GetEntityCoords(PlayerPedId())
            local streetName, crossing = GetStreetNameFromHashKey(GetStreetNameAtCoord(coords.x, coords.y, coords.z))

            local zone = exports.navigate_police:GetPoliceZoneByCoords(coords)
            local zoneLabel = exports.navigate_police:GetPoliceZoneLabel(zone)
       
            data = { ["code"] = zoneLabel .. 'lige Distrikt', ["type"] = "Mistænkelig adfærd", ["loc"] = streetName, coords = coords }
            TriggerServerEvent("esx_outlawalert:senddispatch", data)
            
            local result = exports['pure-minigames']:numberCounter(Config.ATMGAME)

            if result then
                local atmPos = GetEntityCoords(entity)
                local particleName = "scr_indep_fireworks_money"
                local particlePos = vector3(atmPos.x, atmPos.y, atmPos.z + 0.5)

                UseParticleFxAssetNextCall(particleName)
                StartParticleFxNonLoopedAtCoord(particleName, particlePos.x, particlePos.y, particlePos.z, 0.0, 0.0, 0.0, false, false, false, false)

                for i = 1, 20 do
                    local moneyBill = CreateObject(GetHashKey("prop_anim_cash_note"), atmPos.x, atmPos.y, atmPos.z, true, true, true)
                    PlaceObjectOnGroundProperly(moneyBill)
                    SetEntityAsMissionEntity(moneyBill, true, true)
                    SetEntityDynamic(moneyBill, true)
                    SetEntityVelocity(moneyBill, math.random(-1, 1), math.random(-1, 1), math.random(3, 5))
                    Wait(100)
                end
                ExecuteCommand("e pickup")
                Citizen.Wait(1050)
                TriggerServerEvent("zf_robberies:interactwithATM", success)

                ClearPedTasks(PlayerPedId())
            else
                TriggerServerEvent("zf_robberies:FailATM")
                ClearPedTasks(PlayerPedId())
            end
        end
    end, coords)
end

function startRob(coords)
    local playerPed = PlayerPedId()
    local start = lib.alertDialog({ centered = true, header = "Tank Røveri", content = "Vil du starte røveriet?", cancel = true })
    if start == "confirm" then
        ESX.TriggerServerCallback('zf_robberies:RobTank', function(success)
            if success then
                local coords = GetEntityCoords(PlayerPedId())
                local streetName, crossing = GetStreetNameFromHashKey(GetStreetNameAtCoord(coords.x, coords.y, coords.z))

                local zone = exports.navigate_police:GetPoliceZoneByCoords(coords)
                local zoneLabel = exports.navigate_police:GetPoliceZoneLabel(zone)
    
                data = { ["code"] = zoneLabel .. 'lige Distrikt', ["type"] = 'Tankstations Røveri', ["loc"] = streetName, coords = coords }
                TriggerServerEvent("esx_outlawalert:senddispatch", data)

                if lib.progressBar({
                        duration = 20000,
                        label = 'Tilgår',
                        useWhileDead = false,
                        canCancel = true,
                        disable = {
                            car = true,
                        },
                        anim = {
                            scenario = 'CODE_HUMAN_MEDIC_KNEEL',
                        },
                    }) then
                    ExecuteCommand("e phone")
                    local result = exports['pure-minigames']:numberCounter(Config.TankGame)
                    if result then
                        ClearPedTasks(playerPed)
                        local remainingTime = Config.TimeToRobTank
                        local endTime = GetGameTimer() + (remainingTime * 1000)
                        while GetGameTimer() < endTime do
                            local timeLeft = endTime - GetGameTimer()
                            local minutes = math.floor(timeLeft / 60000)
                            local seconds = math.floor((timeLeft % 60000) / 1000)

                            lib.showTextUI(string.format("Tid tilbage: %02d:%02d", minutes, seconds))

                            Wait(1000)
                        end
                        exports.ox_target:addSphereZone({
                            name = "neger",
                            coords = vector3(coords.x, coords.y, coords.z),
                            radius = 2.5,
                            debug = Config.Debug,
                            options = {
                                {
                                    icon = "fa-solid fa-sack-dollar",
                                    label = "Tag penge",
                                    distance = 1.5,
                                    onSelect = function()
                                        lib.hideTextUI()
                                        ExecuteCommand("e pickup")
                                        exports.ox_target:removeZone("neger")
                                        ClearPedTasks(PlayerPedId())
                                        TriggerServerEvent("zf_robberies:RobTank", coords)
                                    end,
                                },
                            },
                        })
                    end
                end
            else
                lib.notify({
                    id = 'cancelrob',
                    title = 'Tank Røveri',
                    description = 'Dette kan du ikke nu!',
                    showDuration = false,
                    position = 'center',
                    icon = 'ban',
                    iconColor = '#C53030'
                })
            end
        end, coords)
    else
        lib.notify({
            id = 'cancelrob',
            title = 'Tank Røveri',
            description = 'Helt fair, bangebuks!',
            showDuration = false,
            position = 'top',
            icon = 'ban',
            iconColor = '#C53030'
        })
    end
end
