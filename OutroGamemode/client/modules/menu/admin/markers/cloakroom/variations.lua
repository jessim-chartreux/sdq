MainMenu = MainMenu or {}
MainMenu.Admin = MainMenu.Admin or {}
MainMenu.Admin.Markers = MainMenu.Admin.Markers or {}
MainMenu.Admin.Markers.Marker = MainMenu.Admin.Markers.Marker or {}
MainMenu.Admin.Markers.Marker.Cloakroom = MainMenu.Admin.Markers.Marker.Cloakroom or {}
MainMenu.Admin.Markers.Marker.Cloakroom.Variations = MainMenu.Admin.Markers.Marker.Cloakroom.Variations or {}

---@type Marker | nil
local currentMarker = nil
local currentCategory = nil
local currentSex = nil
local isProp = false
local i = 1
local variationsList = {}
local ped = nil

---@return string
local getVariation = function(index)
	local category = isProp and Lists.Variations.PropsIndexes[currentCategory]:lower() or Lists.Variations.ClothIndexes[currentCategory]:lower()

	if currentMarker == nil then
		return "a"
	end

	for k, v in pairs(currentMarker:data().cloakroom[currentSex][category]) do
		if v.component == index then
			return tostring(v.variation)
		end
	end

	return "b"
end

function refreshVariationsList()
	--local category = isProp and toint(Lists.Variations.PropsIndexes[currentCategory]:lower()) or toint(Lists.Variations.ClothIndexes[currentCategory]:lower())
	variationsList = {}
	if isProp then
		for i = 0, GetNumberOfPedPropTextureVariations(ped, currentCategory, i)-1 do
			variationsList[i+1] = tostring(i)
		end
	else
		for i = 0, GetNumberOfPedTextureVariations(ped, currentCategory, i)-1 do
			variationsList[i+1] = tostring(i)
		end
	end
end

MainMenu.Admin.Markers.Marker.Cloakroom.Variations.onOpen = function (marker, index, category, sex, prop, _ped)
	currentCategory = category
    currentMarker = marker
	currentSex = sex
	isProp = prop
	i = index
	ped = _ped
	refreshVariationsList()
end

MainMenu.Admin.Markers.Marker.Cloakroom.Variations.Create = function()
    MainMenu.Admin.Markers.Marker.Cloakroom.Variations.Main = Menus:CreateSub(MainMenu.Admin.Markers.Marker.Cloakroom.Main, "Vestiaire | Variations", "default")

    Menus:CreateThread(MainMenu.Admin.Markers.Marker.Cloakroom.Variations.Main, function()
        Menus:IsVisible(MainMenu.Admin.Markers.Marker.Cloakroom.Variations.Main, function()
			if currentMarker == nil then return end

			Menus:AddCheckbox(("#%d"):format(i), false, true, function(checked)
				local data = currentMarker:data()
				local category = isProp and Lists.Variations.PropsIndexes[currentCategory]:lower() or Lists.Variations.ClothIndexes[currentCategory]:lower()

				if data.cloakroom[currentSex][category] == nil then
					data.cloakroom[currentSex][category] = {}
				end

				if not checked then
					for k, v in pairs(data.cloakroom[currentSex][category]) do
						if v.component == i then
							table.remove(data.cloakroom[currentSex][category], k)

							if #data.cloakroom[currentSex][category] == 0 then
								data.cloakroom[currentSex][category] = nil
							end

							break
						end
					end
				end

				currentMarker:data(data)
				Events.TriggerServer("marker:update", currentMarker:name(), currentMarker:action(), currentMarker:coords(), currentMarker:data(), currentMarker:bucket())
				Menus:Back()
			end)

			Menus:AddList("Variation affichée", variationsList, toint(getVariation(i)) + 1, false, function(isClicked, variation)
				local category = isProp and Lists.Variations.PropsIndexes[currentCategory]:lower() or Lists.Variations.ClothIndexes[currentCategory]:lower()
				local data = currentMarker:data()

				for k, v in pairs(data.cloakroom[currentSex][category]) do
					if v.component == i then
						v.variation = variation - 1
						if isProp then
							SetPedPropIndex(ped, currentCategory, i, variation - 1, true)
						else
							SetPedComponentVariation(ped, currentCategory, i, variation - 1, 0)
						end
						break
					end
				end

				currentMarker:data(data)
				Events.TriggerServer("marker:update", currentMarker:name(), currentMarker:action(), currentMarker:coords(), currentMarker:data(), currentMarker:bucket())
			end)

			Menus:AddButton("Prix de l'item", false, "~g~$" .. MainMenu.Admin.Markers.Marker.Cloakroom.getPrice(i).."~s~", "", function()
				local category = isProp and Lists.Variations.PropsIndexes[currentCategory]:lower() or Lists.Variations.ClothIndexes[currentCategory]:lower()
				local price = tonumber(Utils.KeyboardInput("Prix de l'item", 10, ""))

				if price == nil then return end

				local data = currentMarker:data()

				for k, v in pairs(data.cloakroom[currentSex][category]) do
					if v.component == i then
						v.price = toint(price)
						break
					end
				end

				currentMarker:data(data)
				Events.TriggerServer("marker:update", currentMarker:name(), currentMarker:action(), currentMarker:coords(), currentMarker:data(), currentMarker:bucket())
			end)

			Menus:AddButton("Réinitialiser prix", false, "🔄", "", function()
				local category = isProp and Lists.Variations.PropsIndexes[currentCategory]:lower() or Lists.Variations.ClothIndexes[currentCategory]:lower()
				local data = currentMarker:data()

				for k, v in pairs(data.cloakroom[currentSex][category]) do
					if v.component == i then
						v.price = Lists.ClothesPrice[currentSex][category] or 0
						break
					end
				end

				currentMarker:data(data)
				Events.TriggerServer("marker:update", currentMarker:name(), currentMarker:action(), currentMarker:coords(), currentMarker:data(), currentMarker:bucket())
			end)

			-- Menus:AddButton("Variation affichée", false, getVariation(i), "", function()
			-- 	local category = isProp and Lists.Variations.PropsIndexes[currentCategory]:lower() or Lists.Variations.ClothIndexes[currentCategory]:lower()
			-- 	local variation = tonumber(Utils.KeyboardInput("Variation affichée", 3, ""))
			-- 	local data = currentMarker:data()

			-- 	if variation == nil then return end

			-- 	for k, v in pairs(data.cloakroom[currentSex][category]) do
			-- 		if v.component == i then
			-- 			data.cloakroom[currentSex][category][k] = {
			-- 				component = v.component,
			-- 				variation = variation
			-- 			}

			-- 			break
			-- 		end
			-- 	end

			-- 	currentMarker:data(data)
			-- 	Events.TriggerServer("marker:update", currentMarker:name(), currentMarker:action(), currentMarker:coords(), currentMarker:data(), currentMarker:bucket())
			-- end)

        end)
    end)
end
