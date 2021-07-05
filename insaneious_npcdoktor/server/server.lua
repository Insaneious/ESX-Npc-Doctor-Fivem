ESX = nil 

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('premium:gettajMedikale', function(source, cb, store)
    local ems = 0
    local xPlayers = ESX.GetPlayers()
    for i = 1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'ambulance' then
            ems = ems + 1
        end
    end
    if ems <= Config.maxDoktori then
        cb(true)
    else
        cb('no_ems')
    end

end)

ESX.RegisterServerCallback('premium-doctor:kontrola', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	cb(xPlayer.getMoney() >= Config.cjenaDoktora)
end)

RegisterServerEvent('premium-doctor:novac')
AddEventHandler('premium-doctor:novac', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    xPlayer.removeMoney(Config.cjenaDoktora)
    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = '$'.. Config.cjenaDoktora ..' Zauzvrat, lecio vas je lokalni doktor.'})
end)

local getajresourcename = GetCurrentResourceName()
if getajresourcename ~= "premium_doktor" then
	print("                                             #")
	print("                                             ###")
	print("###### ###### ###### ###### ######  ##############")
	print("#      #    # #    # #    # #    #  ################    Promjeni '" .. getajresourcename .. "' u 'premium_doktor'")
	print("###    ###### ###### #    # ######  ##################  ili ces dobiti DDOS i SKRIPTA NECE RADITI!")
	print("#      # ##   # ##   #    # # ##    ################    OSTAVI IME SKRIPTE KAKO JE DAJ REKLAMU NA ESX BALKANU !!!")
	print("###### #   ## #   ## ###### #   ##  ##############")
	print("                                             ###")
	print("                                             #")
	StopResource(getajresourcename)
	Wait(5000)
	os.exit(69)
	kresuj = true
	Citizen.CreateThread(function()
		while kresuj do
	    end
	end)
end