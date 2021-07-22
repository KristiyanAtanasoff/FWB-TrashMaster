local show, JobStarted, donedumps = false, false, nil, {}

local bliplocation = vector2(859.18, -2358.3, 30.35)
local blip = AddBlipForCoord(bliplocation.x, bliplocation.y, bliplocation.z)

SetBlipDisplay(blip, 67)
SetBlipScale(blip, 0.9) 
SetBlipColour(blip, 66)



function NewBlip()

    local objectif = math.randomchoice(Config.pos)
    local ped = GetPlayerPed(-1)

    local blip = AddBlipForCoord(objectif.x, objectif.y, objectif.z)
    SetBlipSprite(blip, 1)
    SetBlipColour(blip, 2)
    SetBlipRoute(blip, true)
    SetBlipRouteColour(blip, 2)

    local coords  = GetEntityCoords(ped)
    local distance = GetDistanceBetweenCoords(coords, objectif.x, objectif.y, objectif.z, true)

    while true do 
		Citizen.Wait(0)
        coords  = GetEntityCoords(ped)
        distance = GetDistanceBetweenCoords(coords, objectif.x, objectif.y, objectif.z, true)
		AddTextEntry("press_collect_trash2", 'Press ~INPUT_CONTEXT~ to collect the trash!')
		DrawMarker(1, objectif.x, objectif.y, objectif.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 1.5, 0, 255, 0, 100, false, true, 2, false, false, false, false)
            if distance <= 5 then
			DisplayHelpTextThisFrame("press_collect_trash2")
			if IsControlJustPressed(1, 38) then
                RemoveBlip(blip)
                NotifChoise()
                break
            end
        end
	end
        if IsControlJustPressed(1, 73) then
            RemoveBlip(blip)
				drawnotifcolor ("Bring back the truck!", 25)
            StopService()
        end
    end

function NotifChoise()

    drawnotifcolor ("Press ~g~E~w~ for new coords.\n~r~X~w~ to stop!", 140)

    local timer = 1200
	while timer >= 1 do
		Citizen.Wait(10)
		timer = timer - 1

		if IsControlJustPressed(1, 38) then
            NewChoise()
			break
        end

		if IsControlJustPressed(1, 73) then
            drawnotifcolor ("Bring back the truck!", 25)
            StopService()

			break
        end

        if timer == 1 then
            drawnotifcolor ("Bring back the truck!", 25)
            StopService()
            break
        end

	end
end

function NewChoise()

    local route = math.randomchoice(Config.pos)
    local ped = GetPlayerPed(-1)

    local blip = AddBlipForCoord(route.x, route.y, route.z)
    SetBlipSprite(blip, 1)
    SetBlipColour(blip, 3)
    SetBlipRoute(blip, true)
    SetBlipRouteColour(blip, 3)
    drawnotifcolor("New location is set, press \n~r~X~w~ to stop it!", 140)
    local coords  = GetEntityCoords(ped)
    local distance = GetDistanceBetweenCoords(coords, route.x, route.y, route.z, true)

    while true do 
		Citizen.Wait(0)
		coords  = GetEntityCoords(ped)
        distance = GetDistanceBetweenCoords(coords, route.x, route.y, route.z, true)
		AddTextEntry("press_collect_trash", 'Press ~INPUT_CONTEXT~ to collect the trash!')
        if distance <= 60 then 
            drawnotifcolor ("You are getting close!", 140)
			DrawMarker(1, route.x, route.y, route.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 1.5, 0, 255, 0, 100, false, true, 2, false, false, false, false)
            if distance <= 5 then
			DisplayHelpTextThisFrame("press_collect_trash")
			if IsControlJustPressed(1, 38) then
                RemoveBlip(blip)
                NewBlip()
                break
            end
        end
	end
        if IsControlJustPressed(1, 73) then
            RemoveBlip(blip)
            drawnotifcolor ("Bring back the truck and get your EP.", 140)
			
            StopService()
            break
        end
    end
end

function StopService()

    local coordsEndService = vector3(845.46, -2355.36, 30.33)
    local ped = GetPlayerPed(-1)
    AddTextEntry("press_ranger_rubble", 'Press ~INPUT_CONTEXT~ to store the truck!')

    local blip = AddBlipForCoord(coordsEndService)
    SetBlipSprite(blip, 1)
    SetBlipColour(blip, 1)
    SetBlipRoute(blip, true)
    SetBlipRouteColour(blip, 1)

    while true do 
		Citizen.Wait(0)
		local coords  = GetEntityCoords(ped)
        local distance = GetDistanceBetweenCoords(coordsEndService, coords, true)
		DrawMarker(1, 845.46, -2355.36, 29.33, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 1.5, 255, 0, 0, 100, false, true, 2, false, false, false, false)
        if distance <= 5 then
            DisplayHelpTextThisFrame("press_ranger_rubble")
            if IsControlPressed(1, 38) then
				local playerPed = PlayerPedId()
				local vehicle = GetVehiclePedIsIn(playerPed, false)
				if GetEntityModel(vehicle) == GetHashKey("rubble") then
				DeleteEntity(vehicle)
				TriggerServerEvent('GiveReward')
				drawnotifcolor ("you were awarded with: 100 EP.", 140)
				RemoveBlip(blip)
                JobStarted, show = false, false
				break
			else
                local vehicle = GetVehiclePedIsIn(playerPed, false)
				if GetEntityModel(vehicle) ~= GetHashKey("rubble") then
				drawnotifcolor ("Bring back our truck or you will get no points!", 140)
				JobStarted, show = true, true
						break
					end
				end
			end
		end
	end
end

function StartJob()

    local ped = GetPlayerPed(-1)
    local vehicleName = 'rubble'

    RequestModel(vehicleName)

    while not HasModelLoaded(vehicleName) do
        Wait(500)
    end

    local vehicle = CreateVehicle(vehicleName, 859.18, -2358.3, 30.35, 354.76, true, false)
    SetPedIntoVehicle(ped, vehicle, -1)
    SetEntityAsMissionEntity(vehicle, true, true)
    SetModelAsNoLongerNeeded(vehicleName)
    JobStarted = true

    NewChoise()

end


Citizen.CreateThread(function()

    AddTextEntry("press_start_job", "Press ~INPUT_CONTEXT~ to start your shift!")

    while true do 
        Citizen.Wait(0)
        local ped = GetPlayerPed(-1)
        local coords  = GetEntityCoords(ped)
        local distance = GetDistanceBetweenCoords(vector3(869.58, -2329, 30.35), coords, true)
		DrawMarker(1, 869.61, -2328.52, 29.35, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 1.5001, 0, 255, 0, 200, 0, 0, 0, 0)
        if distance <= 2 then
            DisplayHelpTextThisFrame("press_start_job")
            if IsControlPressed(1, 38) then
                StartJob()
            end
        end
    end

end)

function drawnotifcolor(text, color)
    Citizen.InvokeNative(0x92F0DA1E27DB96DC, tonumber(color))
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, true)
end


function math.randomchoice(d)
    local keys = {}
    for key, value in pairs(d) do
        keys[#keys+1] = key
    end
    index = keys[math.random(1, #keys)]
    return d[index]
end