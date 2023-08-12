local carList = {'bullet', 'infernus', 'emperor', 'dominator', 'tornado', 'buffalo', 'penumbra'}
local streetList = {vector4(317.23, -206.43, 54.08, 250)}
local destinationList = {vector3(367.92, 335.42, 102.81), vector3(-10.26, -1082.36, 26.67), vector3(890.13, -1591.53, 30.19), vector3(1189.12, -1322.62, 34.97)}

RegisterCommand('carjack', function(source, args)

    RemoveBlip(car)
    DeleteVehicle(vehicle)
    RemoveBlip(destinationBlip)

    -- Select random car
    local vehicleName = carList[math.random(#carList)]

    -- Select random stree
    local streetName = streetList[math.random(#streetList)]

    RequestModel(vehicleName)

    -- Load the model
    while not HasModelLoaded(vehicleName) do Citizen.Wait(500) end

    -- Create the vehicle
    local vehicle = CreateVehicle(vehicleName, streetName, true, true)

    -- Vehicle settings
    local netID = VehToNet(vehicle)
    local vehicleID = NetToVeh(netID)
    SetNetworkIdCanMigrate(netID, true)
    SetEntityAsMissionEntity(vehicle, true, true)
    SetVehicleHasBeenOwnedByPlayer(vehicle, true)
    SetEntitySomething(vehicle, true)
    SetNetworkIdExistsOnAllMachines(netID, true)
    SetVehicleDoorsLocked (vehicleID, 2)
    SetVehicleNeedsToBeHotwired(vehicle, true)
    lockpicked = false
    local plates = GetVehicleNumberPlateText(vehicle)

    -- Vehicle blip
    local car = AddBlipForCoord(streetName)

    TriggerEvent('chat:addMessage', {
		args = { 'Тебе нужно угнать ' .. vehicleName .. '. Привези мне его. Мне она нужна целой. Координаты скинул.' .. ' Номер: ' .. plates .. '.'}
	})

    -- Waiting for lockpicking
    while lockpicked == false do
        Citizen.Wait(0)
            
        local distance = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), streetName, false)

        if IsControlJustReleased(0, 206) and (distance < 5) then
            SetDisplay(not display) 
        end
    end

    -- Play anim
    RequestAnimDict("mp_arresting")
    while (not HasAnimDictLoaded("mp_arresting")) do Citizen.Wait(0) end
    TaskPlayAnim(GetPlayerPed(-1), "mp_arresting", "a_uncuff", 1.0 ,-1.0 , 5500, 0, 1, true, true, true)

    SetVehicleDoorsLocked (vehicleID, 1)
    SetVehicleAlarm(vehicleID, true)
    StartVehicleAlarm(vehicleID)

    while GetVehiclePedIsIn(GetPlayerPed(-1), False) ~= vehicleID do Citizen.Wait(0) end

    RemoveBlip(car)
    TriggerEvent('chat:addMessage', {
        args = { 'Скидываю координаты' }
    })
    destinationName = destinationList[math.random(#destinationList)]
    destinationBlip = AddBlipForCoord(destinationName)


    while GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), destinationName, false) > 5 do
        Citizen.Wait(1000)

        vehiclehealth = GetVehicleBodyHealth(vehicleID)

        if vehiclehealth < 900 then 
            TriggerEvent('chat:addMessage', {
                args = { 'Машина поцарапана. Миссия провалена.' }
            })

            RemoveBlip(destinationBlip)

            goto after_lose
        end
    end

    TriggerEvent('chat:addMessage', {
        args = { 'Круто, сдал тачку' }
    })
    
    RemoveBlip(destinationBlip)

    ::after_lose::
        -- Despawn vehicle
    SetEntityAsNoLongerNeeded(vehicleID)

        -- Release the model
    SetModelAsNoLongerNeeded(vehicleName)

end, false)
