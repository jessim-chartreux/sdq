local function drawText(str, x, y, style)
	if style == nil then
		style = {}
	end

	SetTextFont((style.font ~= nil) and style.font or 0)
	SetTextScale(0.0, (style.size ~= nil) and style.size or 1.0)
	SetTextProportional(true)

	if style.colour ~= nil then
		SetTextColour(style.colour.r ~= nil and style.colour.r or 255, style.colour.g ~= nil and style.colour.g or 255, style.colour.b ~= nil and style.colour.b or 255, style.colour.a ~= nil and style.colour.a or 255)
	else
		SetTextColour(255, 255, 255, 255)
	end

	if style.shadow ~= nil then
		SetTextDropshadow( style.shadow.distance ~= nil and style.shadow.distance or 0, style.shadow.r ~= nil and style.shadow.r or 0, style.shadow.g ~= nil and style.shadow.g or 0, style.shadow.b ~= nil and style.shadow.b or 0, style.shadow.a ~= nil and style.shadow.a or 255)
	else
		SetTextDropshadow(0, 0, 0, 0, 255)
	end

	if style.border ~= nil then
		SetTextEdge(style.border.size ~= nil and style.border.size or 1, style.border.r ~= nil and style.border.r or 0, style.border.g ~= nil and style.border.g or 0, style.border.b ~= nil and style.border.b or 0, style.border.a ~= nil and style.shadow.a or 255)
	end

	if style.centered ~= nil and style.centered == true then
		SetTextCentre(true)
	end

	if style.outline ~= nil and style.outline == true then
		SetTextOutline()
	end

	SetTextDropShadow()
	BeginTextCommandDisplayText("STRING")
	AddTextComponentSubstringPlayerName(str)

	EndTextCommandDisplayText(x, y)
end

local function degreesToIntercardinalDirection(dgr)
	dgr = dgr % 360.0

	if (dgr >= 0.0 and dgr < 22.5) or dgr >= 337.5 then
		return "N "
	elseif dgr >= 22.5 and dgr < 67.5 then
		return "NE"
	elseif dgr >= 67.5 and dgr < 112.5 then
		return "E"
	elseif dgr >= 112.5 and dgr < 157.5 then
		return "SE"
	elseif dgr >= 157.5 and dgr < 202.5 then
		return "S"
	elseif dgr >= 202.5 and dgr < 247.5 then
		return "SW"
	elseif dgr >= 247.5 and dgr < 292.5 then
		return "W"
	elseif dgr >= 292.5 and dgr < 337.5 then
		return "NW"
	end
end

local compass = {cardinal={}, intercardinal={}}

compass.show = true
compass.position = {x = 0.33, y = 0.07, centered = true}
compass.width = 0.33
compass.fov = 180
compass.followGameplayCam = true

compass.ticksBetweenCardinals = 9.0
compass.tickColour = {r = 255, g = 255, b = 255, a = 255}
compass.tickSize = {w = 0.001, h = 0.003}

compass.cardinal.textSize = 0.25
compass.cardinal.textOffset = 0.015
compass.cardinal.textColour = {r = 255, g = 255, b = 255, a = 255}

compass.cardinal.tickShow = true
compass.cardinal.tickSize = {w = 0.001, h = 0.012}
compass.cardinal.tickColour = {r = 255, g = 255, b = 255, a = 255}

compass.intercardinal.show = true
compass.intercardinal.textShow = true
compass.intercardinal.textSize = 0.2
compass.intercardinal.textOffset = 0.015
compass.intercardinal.textColour = {r = 255, g = 255, b = 255, a = 255}

compass.intercardinal.tickShow = true
compass.intercardinal.tickSize = {w = 0.001, h = 0.006}
compass.intercardinal.tickColour = {r = 255, g = 255, b = 255, a = 255}

local function ShowCompassThisFrame()
	local pxDegree = compass.width / compass.fov
	local playerHeadingDegrees = 0

	if compass.followGameplayCam then
		-- Converts [-180, 180] to [0, 360] where E = 90 and W = 270
		local camRot = Citizen.InvokeNative(0x837765A25378F0BB, 0, Citizen.ResultAsVector())
		playerHeadingDegrees = 360.0 - ((camRot.z + 360.0) % 360.0)
	else
		-- Converts E = 270 to E = 90
		playerHeadingDegrees = 360.0 - GetEntityHeading(PlayerPedId())
	end

	local tickDegree = playerHeadingDegrees - compass.fov / 2
	local tickDegreeRemainder = compass.ticksBetweenCardinals - (tickDegree % compass.ticksBetweenCardinals)
	local tickPosition = compass.position.x + tickDegreeRemainder * pxDegree

	tickDegree += tickDegreeRemainder

	while tickPosition < compass.position.x + compass.width do
		if (tickDegree % 90.0) == 0 then
			-- Draw cardinal
			if compass.cardinal.tickShow then
				DrawRect( tickPosition, compass.position.y, compass.cardinal.tickSize.w, compass.cardinal.tickSize.h, compass.cardinal.tickColour.r, compass.cardinal.tickColour.g, compass.cardinal.tickColour.b, compass.cardinal.tickColour.a )
			end

			drawText( degreesToIntercardinalDirection( tickDegree ), tickPosition, compass.position.y + compass.cardinal.textOffset, {
				size = compass.cardinal.textSize,
				colour = compass.cardinal.textColour,
				outline = true,
				centered = true
			})
		elseif (tickDegree % 45.0) == 0 and compass.intercardinal.show then
			-- Draw intercardinal
			if compass.intercardinal.tickShow then
				DrawRect( tickPosition, compass.position.y, compass.intercardinal.tickSize.w, compass.intercardinal.tickSize.h, compass.intercardinal.tickColour.r, compass.intercardinal.tickColour.g, compass.intercardinal.tickColour.b, compass.intercardinal.tickColour.a )
			end

			if compass.intercardinal.textShow then
				drawText( degreesToIntercardinalDirection( tickDegree ), tickPosition, compass.position.y + compass.intercardinal.textOffset, {
					size = compass.intercardinal.textSize,
					colour = compass.intercardinal.textColour,
					outline = true,
					centered = true
				})
			end
		else
			-- Draw tick
			DrawRect( tickPosition, compass.position.y, compass.tickSize.w, compass.tickSize.h, compass.tickColour.r, compass.tickColour.g, compass.tickColour.b, compass.tickColour.a )
		end

		-- Advance to the next tick
		tickDegree += compass.ticksBetweenCardinals
		tickPosition += pxDegree * compass.ticksBetweenCardinals
	end
end

local streetName = {}
local lastStreetA = 0
local lastStreetB = 0

streetName.show = true
streetName.position = {x = 0.5, y = 0.02, centered = true}
streetName.textSize = 0.35
streetName.textColour = {r = 255, g = 255, b = 255, a = 255}

local function ShowStreetNamesThisFrame()
	local playerPos = GetEntityCoords(PlayerPedId(), true)
	local streetA, streetB = Citizen.InvokeNative(0x2EB41072B4C1E4C0, playerPos.x, playerPos.y, playerPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
	local street = {}

	if not ((streetA == lastStreetA or streetA == lastStreetB) and (streetB == lastStreetA or streetB == lastStreetB)) then
		-- Ignores the switcharoo while doing circles on intersections
		lastStreetA = streetA
		lastStreetB = streetB
	end

	if lastStreetA ~= 0 then
		table.insert(street, GetStreetNameFromHashKey(lastStreetA))
	end

	if lastStreetB ~= 0 then
		table.insert(street, GetStreetNameFromHashKey(lastStreetB))
	end

	drawText( table.concat(street, " & "), streetName.position.x, streetName.position.y, {
		size = streetName.textSize,
		colour = streetName.textColour,
		outline = true,
		centered = streetName.position.centered
	})
end

Core.Player:OnLoad(function()
	Citizen.CreateThread(function()
		local timeout = 0
		local show = { compass = false, streetnames = false }
		while true do
			show.streetnames = ClientModules.Misc.Settings:Get("streetnames")
			show.compass = ClientModules.Misc.Settings:Get("compass")

			if show.compass == false and show.streetnames == false then
				timeout = 100
			else
				timeout = 0
			end

			if show.compass == true then
				ShowCompassThisFrame()
			end

			if show.streetnames == true then
				ShowStreetNamesThisFrame()
			end

			Citizen.Wait(timeout)
		end
	end)
end)
