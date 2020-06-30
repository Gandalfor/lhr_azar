local time = 10000

RegisterCommand('coin', function(source)
    local moneda = math.random(2)
    if moneda == 1 then
        text = 'La moneda caeria mostrando cara '
    else
        text = 'La moneda caeria mostrando cruz '
    end
    TriggerServerEvent('lhr_azar:shareDisplay', text)
end)

RegisterCommand('dado', function(source)
    local dado = math.random(6)
    if dado == 1 then
        text = 'El dado caeria mostrando 1 '
    elseif dado == 2 then
        text = 'El dado caeria mostrando 2 '
    elseif dado == 3 then
        text = 'El dado caeria mostrando 3 '
    elseif dado == 4 then
        text = 'El dado caeria mostrando 4 '
    elseif dado == 5 then
        text = 'El dado caeria mostrando 5 '
    elseif dado == 6 then
        text = 'El dado caeria mostrando 6 '
    end
    TriggerServerEvent('lhr_azar:shareDisplay', text)
end)

RegisterNetEvent('lhr_azar:triggerDisplay')
AddEventHandler('lhr_azar:triggerDisplay', function(text, source)
    Display(GetPlayerFromServerId(source), text)
end)

function Display(mePlayer, text)
    local displaying = true
    if chatMessage then
        local coordsMe = GetEntityCoords(GetPlayerPed(mePlayer), false)
        local coords = GetEntityCoords(PlayerPedId(), false)
        local dist = Vdist2(coordsMe, coords)
        if dist < 300 then
            TriggerEvent('chat:addMessage', {
                color = { color.r, color.g, color.b },
                multiline = true,
                args = { text}
            })
        end
    end

    Citizen.CreateThread(function()
        Wait(time)
        displaying = false
    end)
    Citizen.CreateThread(function()
        while displaying do
            Wait(0)
            local coordsMe = GetEntityCoords(GetPlayerPed(mePlayer), false)
            local coords = GetEntityCoords(PlayerPedId(), false)
            local dist = Vdist2(coordsMe, coords)
            if dist < 300 then
                DrawText3D(coordsMe['x'], coordsMe['y'], coordsMe['z'], text)
            end
        end
    end)
end

function DrawText3D(x, y, z, text)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoord())  
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 2)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    if onScreen then
        SetTextScale(0.30, 0.30)
        SetTextFontForCurrentCommand(1)
        SetTextColor(60, 171, 21, 215)
        SetTextCentre(1)
        DisplayText(str,_x,_y-0.262)
        --DisplayText(str,_x,_y)
        local factor = (string.len(text)) / 225
        DrawSprite("feeds", "hud_menu_4a", _x, _y-0.250,0.015+ factor, 0.03, 0.1, 35, 35, 35, 190, 0)
        --DrawSprite("feeds", "toast_bg", _x, _y+0.0125,0.015+ factor, 0.03, 0.1, 100, 1, 1, 190, 0)
    end
end