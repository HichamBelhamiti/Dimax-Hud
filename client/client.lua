ESX = nil

local speedBuffer  = {}
local velBuffer    = {}
local beltOn       = false
local wasInCar     = false
local inMap     = false
local hideHUD      = false
----------------------------------

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
	end
end)

RegisterNetEvent("esx_statusBar:onTick")
AddEventHandler("esx_statusBar:onTick", function(status)

    TriggerEvent('esx_status:getStatus', 'hunger', function(status)
        getfood = status.val / 10000
    end)
    TriggerEvent('esx_status:getStatus', 'thirst', function(status)
        getthirst = status.val / 10000
    end)
end)

RegisterNetEvent("wicked_carshud:hideHUD")
AddEventHandler("wicked_carshud:hideHUD", function(status)
    hideHUD = status
end)

RegisterNetEvent("wicked_carshud:toggleHUD")
AddEventHandler("wicked_carshud:toggleHUD", function()
   if hideHUD == true then
    hideHUD = false
   else
    hideHUD = true
   end
end)




local OnRun = false
local MaxUnderwater = 40.0

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(100)
        local player = GetPlayerPed(-1)
        local vehicle
        local speed
        if IsPedSittingInAnyVehicle(player) and not IsPlayerDead(player) then
            DisplayRadar(true)

            vehicle = GetVehiclePedIsIn(PlayerPedId())
            speed = GetEntitySpeed(vehicle)

        elseif not IsPedSittingInAnyVehicle(player) then
            DisplayRadar(true)
        end

        if IsControlPressed(0, 21) and (IsControlPressed(0, 32) or IsControlPressed(0, 34) or IsControlPressed(0, 31) or IsControlPressed(0, 30)) and not IsPedSwimming(PlayerPedId()) then
            OnRun = true
        else
            OnRun = false
        end
    
        if vehicle then  
            SendNUIMessage({
                pauseMenu   = IsPauseMenuActive(),
                inVehicle   = IsPedSittingInAnyVehicle(PlayerPedId()),
                armour      = GetPedArmour(PlayerPedId()),
                health      = GetEntityHealth(PlayerPedId())-100,
                id          = GetPlayerServerId(PlayerId()),
                food        = getfood,
                water       = getthirst,
                stamina     = 100-GetPlayerSprintStaminaRemaining(PlayerId()),
                oxygen      = (GetPlayerUnderwaterTimeRemaining(PlayerId()) / MaxUnderwater) * 100,
                isPedRun    = OnRun,
                IsPedSwin   = IsPedSwimming(PlayerPedId()),
                kmh         = tostring(math.ceil(speed * 3.6)),
                fuel        = tostring(math.ceil(GetVehicleFuelLevel(vehicle))),
                engine      = tostring(math.ceil(GetVehicleEngineHealth(vehicle))),
                gear        = GetVehicleCurrentGear(vehicle),
                plate       = GetVehicleNumberPlateText(vehicle),
                modelName   = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)),
                belt        = beltOn,
                enginerunning = GetIsVehicleEngineRunning(vehicle),
                isCar       = IsThisModelACar(GetEntityModel(vehicle)),
                isBike      = IsThisModelABicycle(GetEntityModel(vehicle)),
                hideHUD     = hideHUD
            })
        else
            SendNUIMessage({
                pauseMenu   = IsPauseMenuActive(),
                inVehicle   = IsPedSittingInAnyVehicle(PlayerPedId()),
                armour      = GetPedArmour(PlayerPedId()),
                health      = GetEntityHealth(PlayerPedId())-100,
                id          = GetPlayerServerId(PlayerId()),
                food        = getfood,
                water       = getthirst,
                stamina     = 100-GetPlayerSprintStaminaRemaining(PlayerId()),
                oxygen      = (GetPlayerUnderwaterTimeRemaining(PlayerId()) / MaxUnderwater) * 100,
                isPedRun    = OnRun,
                IsPedSwin   = IsPedSwimming(PlayerPedId()),
                hideHUD     = hideHUD
            })
        end

    end
end)

----------------------------------
--          BELT SYSTEM         --
----------------------------------

IsCar = function(veh)
		    local vc = GetVehicleClass(veh)
		    return (vc >= 0 and vc <= 7) or (vc >= 9 and vc <= 12) or (vc >= 17 and vc <= 20)
        end	

Fwv = function (entity)
		    local hr = GetEntityHeading(entity) + 90.0
		    if hr < 0.0 then hr = 360.0 + hr end
		    hr = hr * 0.0174533
		    return { x = math.cos(hr) * 2.0, y = math.sin(hr) * 2.0 }
      end

Citizen.CreateThread(function()
	Citizen.Wait(500)
	while true do
		
		local ped = GetPlayerPed(-1)
		local car = GetVehiclePedIsIn(ped)
		
		if car ~= 0 and (wasInCar or IsCar(car)) then
		
			wasInCar = true
			
			if beltOn then DisableControlAction(0, 75) end
			
			speedBuffer[2] = speedBuffer[1]
			speedBuffer[1] = GetEntitySpeed(car)
			
			if speedBuffer[2] ~= nil 
			   and not beltOn
			   and GetEntitySpeedVector(car, true).y > 1.0  
			   and speedBuffer[1] > Cfg.MinSpeed 
			   and (speedBuffer[2] - speedBuffer[1]) > (speedBuffer[1] * Cfg.DiffTrigger) then
			   
				local co = GetEntityCoords(ped)
				local fw = Fwv(ped)
				SetEntityCoords(ped, co.x + fw.x, co.y + fw.y, co.z - 0.47, true, true, true)
				SetEntityVelocity(ped, velBuffer[2].x, velBuffer[2].y, velBuffer[2].z)
				Citizen.Wait(1)
				SetPedToRagdoll(ped, 1000, 1000, 0, 0, 0, 0)
			end
				
			velBuffer[2] = velBuffer[1]
			velBuffer[1] = GetEntityVelocity(car)
				
			if IsControlJustReleased(0, Cfg.Key) then
				beltOn = not beltOn				  
				if beltOn then 
				else end 
			end
			
		elseif wasInCar then
			wasInCar = false
			beltOn = false
			speedBuffer[1], speedBuffer[2] = 0.0, 0.0
		end
		Citizen.Wait(0)
	end
end)

RegisterCommand('toggleui', function()
    TriggerEvent('wicked_carshud:toggleHUD')
end)