carList = {'bullet', 'infernus', 'emperor', 'dominator', 'tornado', 'buffalo', 'penumbra'}
streetList = {vector3(317.23, -206.43, 54.08), vector3(272.81, 66.97, 99.89), vector3(383.62, -767.88, 29.29)}
destinationList = {vector3(367.92, 335.42, 102.81), vector3(-10.26, -1082.36, 26.67)}


RegisterCommand('carjack', function(source, args)

    RemoveBlip(car)
    DeleteVehicle(vehicle)

    -- random car generation
    vehicleName = carList[math.random(#carList)]

    -- random street generation
    streetName = streetList[math.random(#streetList)]

    RequestModel(vehicleName)

    -- wait for the model to load
    while not HasModelLoaded(vehicleName) do
        Citizen.Wait(500)
    end

    -- create the vehicle
    vehicle = CreateVehicle(vehicleName, streetName, true, false)
    SetVehicleDoorsLocked (vehicle, 2)
    local plates = GetVehicleNumberPlateText(vehicle)
    
    car = AddBlipForCoord(streetName)

    TriggerEvent('chat:addMessage', {
		args = { 'Тебе нужно угнать ' .. vehicleName .. '. Привези мне его. Координаты скинул.' .. ' Номер: ' .. plates .. '.'}
	})


    while GetVehiclePedIsIn(GetPlayerPed(-1), False) ~= vehicle do
        Citizen.Wait(0)
        distance = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), streetName, false)
        
        if IsControlJustReleased(0, 206) and (distance < 5) then
            SetDisplay(not display) 
        end

        if GetVehiclePedIsIn(GetPlayerPed(-1), False) == vehicle then
            RemoveBlip(car)
            TriggerEvent('chat:addMessage', {
                args = { 'Скидываю координаты' }
            })
            destinationName = destinationList[math.random(#destinationList)]
            destinationBlip = AddBlipForCoord(destinationName)
        end
    end


    while GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), destinationName, false) > 5 do
        Citizen.Wait(1000)
        
        if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), destinationName, false) < 5 then
            TriggerEvent('chat:addMessage', {
                args = { 'Круто, сдал тачку' }
            })
            RemoveBlip(destinationBlip)
        end 
    end
        -- give the vehicle back to the game (this'll make the game decide when to despawn the vehicle)
    SetEntityAsNoLongerNeeded(vehicle)

        -- release the model
    SetModelAsNoLongerNeeded(vehicleName)

end, false)


-- get coord function
RegisterCommand('getcoord', function(source, args)
    TriggerEvent('chat:addMessage', {
        args = {'x: ', Floor((GetEntityCoords(GetPlayerPed(-1), true).x)*100)/100,}
    })
    TriggerEvent('chat:addMessage', {
        args = {'y: ', Floor((GetEntityCoords(GetPlayerPed(-1), true).y)*100)/100,}
    })
    TriggerEvent('chat:addMessage', {
        args = {'z: ', Floor((GetEntityCoords(GetPlayerPed(-1), true).z)*100)/100,}
    })
    TriggerEvent('chat:addMessage', {
        args = {'h: ', Floor(GetEntityHeading(GetPlayerPed(-1)))}
    })
end, false)
