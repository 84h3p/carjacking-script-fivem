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
        args = {'h: ', Floor(GetEntityHeading(PlayerPedId()))}
    })
end, false)
