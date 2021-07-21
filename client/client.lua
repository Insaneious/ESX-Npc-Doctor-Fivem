ESX = nil
local canEms -- definisimo local.
CreateThread(function() while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) Wait(200) end
end)
CreateThread(function()
    Wait(2000)
    while true do
    local spavaj = 5000
    local igrac = PlayerPedId()
    local kordinateigraca = GetEntityCoords(igrac)
    for i = 1, #Config.Doktori, 1 do
        local doktor = Config.Doktori[i]
        local udaljenost = #(kordinateigraca - vec3(doktor.x, doktor.y, doktor.z))
            if udaljenost <= 5 then
                spavaj = 7
                DrawText3D(doktor.x, doktor.y, doktor.z, 'Pritisnite [E] Da se ozivite $'.. Config.cjenaDoktora)
                DrawMarker(20, doktor.x, doktor.y, doktor.z-0.100, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.0, 2.0, 1.0, 255, 195, 18, 100, false, true, 2, false, false, false, false)
                if udaljenost <= 1.5 then
                    if IsControlJustReleased(0, 38) then
                      ESX.TriggerServerCallback('premium:gettajMedikale', function(cb)
                            canEms = cb
                        end, i)
                            while not canEms do
                                Wait(0)
                            end
                            if Config.DoktoriLimit then
                                if canEms then
                                    ESX.TriggerServerCallback('premium-doctor:kontrola', function(hasEnoughMoney)
                                        if hasEnoughMoney then
                                            local formattedCoords = {x = ESX.Math.Round(kordinateigraca.x, 1),y = ESX.Math.Round(kordinateigraca.y, 1),z = ESX.Math.Round(kordinateigraca.z, 1)}
                                            TriggerEvent('esx_ambulancejob:revive', formattedCoords)
                                            TriggerServerEvent('premium-doctor:novac')
                                        else
                                            exports['mythic_notify']:DoHudText('error', 'Nemate dovoljno novca!')
                                        end
                                    end)
                                elseif canEms == 'no_ems' then
                                    exports['mythic_notify']:DoHudText('error', 'U gradu ima dovoljno Doktora da vas ljece !')
                                end
                            else
                                ESX.TriggerServerCallback('premium-doctor:kontrola', function(hasEnoughMoney)
                                    if hasEnoughMoney then
                                        local formattedCoords = {x = ESX.Math.Round(kordinateigraca.x, 1),y = ESX.Math.Round(kordinateigraca.y, 1),z = ESX.Math.Round(kordinateigraca.z, 1)}
                                        TriggerEvent('esx_ambulancejob:revive', formattedCoords)
                                        TriggerServerEvent('premium-doctor:novac')
                                    else
                                        exports['mythic_notify']:DoHudText('error', 'Nemate dovoljno novca.!')
                                    end
                                end)
                            end
                        end
                    end
                end
            end
        Wait(spavaj)
    end
end)

function DrawText3D(x,y,z,text,size)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

CreateThread(function()
    RequestModel(`s_m_m_doctor_01`)
    while not HasModelLoaded(`s_m_m_doctor_01`) do Wait(10) end
	if Config.UkljuciPedove then
        for _, doctor in pairs(Config.Doktori) do
			local npc = CreatePed(4, `s_m_m_doctor_01`, doctor.x, doctor.y, doctor.z-1.0, doctor.heading, false, true)
			SetEntityHeading(npc, doctor.heading)
			FreezeEntityPosition(npc, true)
			SetEntityInvincible(npc, true)
			SetBlockingOfNonTemporaryEvents(npc, true)
		end
	end
end)

CreateThread(function()
    if Config.UkljuciBlipove then
        for k,v in pairs(Config.Doktori) do
            local blip = AddBlipForCoord(v.x, v.y, v.z)
            SetBlipSprite (blip, 403)
            SetBlipDisplay(blip, 2)
            SetBlipScale  (blip, 1.0)
            SetBlipColour (blip, 2)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString('Bolnicar')
            EndTextCommandSetBlipName(blip)
        end
    end
end)
