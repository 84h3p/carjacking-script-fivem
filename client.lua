local carList = {'bullet', 'infernus', 'emperor', 'dominator', 'tornado', 'buffalo', 'penumbra'}
local streetList = {vector4(317.23, -206.43, 54.08, 250)}
local destinationList = {vector3(367.92, 335.42, 102.81), vector3(-10.26, -1082.36, 26.67), vector3(890.13, -1591.53, 30.19), vector3(1189.12, -1322.62, 34.97)}

RegisterCommand('carjack', function(source, args)

    RemoveBlip(car)
    DeleteVehicle(vehicle)
    RemoveBlip(destinationBlip)

    -- random car generation
    local vehicleName = carList[math.random(#carList)]

    -- random street generation
    local streetName = streetList[math.random(#streetList)]

    RequestModel(vehicleName)

    -- wait for the model to load
    while not HasModelLoaded(vehicleName) do Citizen.Wait(500) end

    -- create the vehicle
    local vehicle = CreateVehicle(vehicleName, streetName, true, true)
    local netID = VehToNet(vehicle)
    local vehicleID = NetToVeh(netID)
    SetNetworkIdCanMigrate(id, true)
    SetEntityAsMissionEntity(vehicle, true, true)
    SetVehicleHasBeenOwnedByPlayer(vehicle, true)
    SetEntitySomething(vehicle, true)
    SetNetworkIdExistsOnAllMachines(netID, true)
    SetVehicleDoorsLocked (vehicleID, 2)
    SetVehicleNeedsToBeHotwired(vehicle, true)
    print(vehicleID)
    print(netID)
    lockpicked = false
    

    
    local plates = GetVehicleNumberPlateText(vehicle)
    
    local car = AddBlipForCoord(streetName)

    TriggerEvent('chat:addMessage', {
		args = { 'Тебе нужно угнать ' .. vehicleName .. '. Привези мне его. Мне она нужна целой. Координаты скинул.' .. ' Номер: ' .. plates .. '.'}
	})

    while lockpicked == false do
        Citizen.Wait(0)
            
        local distance = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), streetName, false)

        if IsControlJustReleased(0, 206) and (distance < 5) then
            SetDisplay(not display) 
        end
    end

    -- play animation
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
        -- give the vehicle back to the game (this'll make the game decide when to despawn the vehicle)
    SetEntityAsNoLongerNeeded(vehicleID)

        -- release the model
    SetModelAsNoLongerNeeded(vehicleName)

end, false)
