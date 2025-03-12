

function SetupTarget()

    exports.qtarget:AddTargetModel(Config.ATMProps, {
        options = {
            {
                icon = "fa-solid fa-laptop-code",
                label = "Hack ATM",
                item = "hackingdevice",
                action = function(entity)
                    --json.encode(entity)
                    local playerPed = PlayerPedId()
                    TaskTurnPedToFaceEntity(playerPed, entity, 50)
                    Citizen.Wait(50)
                    hackAtm(entity, GetEntityCoords(entity))
                end,
                canInteract = function(entity)
                    if not HasEntityClearLosToEntity(entity, PlayerPedId(), 17) then
                        return false
                    end
    
                    return true
                end
            }
        },
        distance = 2.0
    })

    for _, coords in pairs(Config.Locations.Safes) do
        exports.ox_target:addSphereZone({
            coords = vector3(coords.x, coords.y,coords.z),
            radius = 2.5,
            debug = Config.Debug,
            options = {
                {
                    icon = "fa-solid fa-magnifying-glass-dollar",
                    label = "Start Tank Røveri",
                    distance = 1.5,
                    onSelect = function()
                        startRob(coords)
                    end,
                },
            },
        })
    end
end

SetupTarget()