local NPCDutyOn = false
local isTaxiRunning = false
local lastNPC = nil

local taxiPoints = {
	vector3(-1013.520813, -2734.894043, 13.662060),
	vector3(-1277.223755, -1399.732056, 4.400326),
	vector3(-421.313934, 1198.146606, 325.641754),
	vector3(-491.582642, -191.455582, 37.211273),
	vector3(1242.071289, -333.725006, 69.082100),
	vector3(-1406.066284, 92.912544, 53.136021),
	vector3(648.244019, 590.512878, 128.910950),
	vector3(304.300446, 143.979172, 103.698463),
	vector3(31.826141, -1103.198242, 29.372780),
	vector3(904.017151, 34.797173, 80.171585),
}

local function GetTargetCoords()
	local coords = taxiPoints[math.random(1, #taxiPoints)]

	while Math.Distance(player:position(), coords) < 1000 do
		coords = taxiPoints[math.random(1, #taxiPoints)]
	end

	return coords
end

local function PayTaxiRun(amount)
	local society = ClientModules.Societies:Get(player:job().id)
	local playerBankAccount = Bank.GetAccount(player:bank_account_id())
	local societyBankAccount = Bank.GetAccount(society:bank_account_id() or -1)

	if societyBankAccount == nil then
		UI:AddNotification("basic", "~r~L'entreprise n'a pas de compte en banque", "info", 5000)
		return
	end

	if playerBankAccount == nil then
		UI:AddNotification("basic", "~r~Vous n'avez pas de compte en banque", "info", 5000)
		return
	end

	local societyPart = math.floor(amount * 0.4)
	local employeePart = math.floor(amount * 0.6)

	societyBankAccount:deposit(amount, false)
	societyBankAccount:send(employeePart, playerBankAccount:id())

	UI:AddNotification(
		"basic",
		("Vous avez gagné ~b~$%d~s~, l'entreprise a gagné ~b~$%d~s~"):format(employeePart, societyPart),
		"info",
		5000
	)
end

local function StartTaxiRun(npc)
	local targetCoords = GetTargetCoords()

	local price = SharedModules.Variables:Get("global", "taxi_km_price") * (Math.Distance(targetCoords, GetEntityCoords(npc, true)) / 1000)
	local taxi = GetVehiclePedIsIn(PlayerPedId(), false)
	local timer = GetGameTimer() + 15000
	local blip = Blip:new({
		coords = targetCoords,
		title = "Course taxi",
		showOnList = false,
		shortRange = false,
		editable = false,
		id = 2147483647,
		size = 0.75,
		sprite = 1,
		color = 26,
	})

	lastNPC = npc

	isTaxiRunning = true

	TaskEnterVehicle(npc, GetVehiclePedIsIn(PlayerPedId(), false), -1, 1, 1.0, 1, 0)

	while IsPedInVehicle(npc, taxi, false) == false do
		if GetGameTimer() > timer then
			isTaxiRunning = false
			return
		end

		Citizen.Wait(100)
	end

	ClearGpsMultiRoute()
	StartGpsMultiRoute(9, true, true)
	blip:show()

	AddPointToGpsMultiRoute(targetCoords.x, targetCoords.y, targetCoords.z)
	SetGpsMultiRouteRender(true)

	Citizen.CreateThread(function()
		while IsPedInVehicle(npc, taxi, false) do
			if (
				Math.Distance(GetEntityCoords(taxi, false), targetCoords) < 5.0
				and GetEntitySpeed(taxi) < 2.0
			) then
				TaskLeaveVehicle(npc, taxi, 1)
				PayTaxiRun(price)
				blip:delete()
				break
			end

			Citizen.Wait(250)
		end

		ClearGpsMultiRoute()
		isTaxiRunning = false
	end)
end

local function CreateNPCDutyThread()
	Citizen.CreateThread(function()
		local currentNPC, currentDist = nil, nil

		ClientModules.HUD.InstructionalButtons:Add("Appeler un client", 86)

		while NPCDutyOn do
			if IsControlJustPressed(0, 86) then
				currentNPC, currentDist = GetClosestAliveNPC()

				if DoesEntityExist(currentNPC) and currentDist < 10 and IsPedOnFoot(currentNPC) and isTaxiRunning == false and lastNPC ~= currentNPC then
					StartTaxiRun(currentNPC)
				end
			end

			Citizen.Wait(0)
		end

		ClearGpsMultiRoute()
		ClientModules.HUD.InstructionalButtons:Delete(86)

	end)
end

Events.Register("taxidowntown:duty", function(source, duty)

    if not duty then
		MainMenu.Radial.Unregister()
        return
    end

	MainMenu.Radial.Register({
        {
            icon = "taxi",
            title = "Taxi",
            callback = "taxidowntown:npcDuty",
        },
    })
end)

UI:RegisterCallback("taxidowntown:npcDuty", function(data, cb)
	NPCDutyOn = not NPCDutyOn

	if NPCDutyOn then
		UI:AddNotification("basic", "Allez chercher des clients (PNJ)", "info", 5000)
		CreateNPCDutyThread()
	else
		UI:AddNotification("basic", "Vous avez désactivé les courses PNJ", "info", 5000)
	end
end)
