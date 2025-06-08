ClientModules = ClientModules or {}
ClientModules.Inventory = ClientModules.Inventory or {}

local itemAnimList = {
	["mask"] = "adjustmask",
	["hat"] = { on = "adjusthelmet", off = "takeoffhelmet" },
	["glasses"] = "adjustglasses",
	["shoes"] = "jtryshoes",
	["watch"] = "jcheckwatch",
}

---@param item Item
---@return { clothes: { componentIds: table, components: table, variations: {} }, props: { componentIds: table, components: table, variations: {} } }
function ClientModules.Inventory:ParseClothe(item)
	local data = {
		clothes = {
			componentIds = {},
			components = {},
			variations = {},
		},
		props = {
			componentIds = {},
			components = {},
			variations = {},
		}
	}

	local isProp = Lists.Variations.Props[item.name:upper()] ~= nil or false

	if isProp == true then
		table.insert(data.props.componentIds, item.metadata.componentId)
		table.insert(data.props.components, item.metadata.component)
		table.insert(data.props.variations, item.metadata.variation)
	else
		table.insert(data.clothes.componentIds, item.metadata.componentId)
		table.insert(data.clothes.components, item.metadata.component)
		table.insert(data.clothes.variations, item.metadata.variation)
	end

	return data
end

function ClientModules.Inventory:ParseItem(item)
	local changes = {}

	if item == nil then
		return {}
	end

	if item.name == "outfit" then
		for key, outfitItem in pairs(item.metadata.items) do
			if key ~= "outfit" then
				local parsedClothe = self:ParseClothe(outfitItem)

				if next(changes) == nil then
					changes = parsedClothe
				else
					for k, v in pairs(parsedClothe) do
						for k2, v2 in pairs(v) do
							changes[k][k2] = changes[k][k2] or {}
							table.insert(changes[k][k2], v2[1])
						end
					end
				end
			end
		end
	else
		changes = self:ParseClothe(item)
	end

	return changes
end

function ClientModules.Inventory:CalculateItemOutfit(item, toggle, outfit)
	local changes = ClientModules.Inventory:ParseItem(item)

	for i, componentId in ipairs(changes.props ~= nil and changes.props.componentIds or {}) do
		local componentValue = toggle and { changes.props.components[i], changes.props.variations[i] } or { -1, 0 }
		outfit.props[tostring(componentId)] = componentValue
	end

	for i, componentId in ipairs(changes.clothes ~= nil and changes.clothes.componentIds or {}) do
		local componentValue = toggle and { changes.clothes.components[i], changes.clothes.variations[i] } or
			{ Lists.Variations.Naked[player:sex()][componentId], 0 }
		outfit.components[componentId] = componentValue
	end

	return outfit
end

function ClientModules.Inventory:UpdateClothesMethod(player, skinOutfit, outfit, addClothes)
	local clothesItems = {}
	addClothes = addClothes == nil or addClothes -- Simplify the nil check and assignment

	local sex = player:sex()

	for outfitType, components in pairs(skinOutfit) do
		local lowerOutfitType = outfitType:lower()

		for componentIdStr, componentValues in pairs(components) do
			local componentId = lowerOutfitType == "components" and tonumber(componentIdStr) or componentIdStr
			local componentIndexKey = lowerOutfitType == "components" and Lists.Variations.ClothIndexes[componentId] or Lists.Variations.PropsIndexes[componentId]
			if componentIndexKey then -- Check if componentIndexKey is not nil
				local isNakedOutfit = componentValues[1] == Lists.Variations.NakedOutfits[sex][lowerOutfitType][componentId][1]
				if not isNakedOutfit then
					local metadata = {
						isProp = lowerOutfitType == "props",
						component = componentValues[1],
						variation = componentValues[2],
						componentId = componentId,
						sex = player:sex(),
					}
					local lowerComponentIndexKey = componentIndexKey:lower()
					clothesItems[lowerComponentIndexKey] = Item.Create(lowerComponentIndexKey, metadata, 1)
				end
			end
		end
	end

	if outfit then
		local outfitItem = Item.Create("outfit", { items = clothesItems, sex = player:sex() }, 1)

		if addClothes then
			player:inventory():addClothingItem(outfitItem, true)
			player:inventory():setIsChangingClothe(false)
		end

		return outfitItem
	else
		for _, item in pairs(clothesItems) do
			if addClothes then
				player:inventory():addClothingItem(item, true)
				player:inventory():setIsChangingClothe(false)
			end
		end
	end
end

---@param item Item
---@param toggle boolean
---@param bypassAnim boolean
---@return boolean
function ClientModules.Inventory:HandleOutfitUpdate(item, toggle, bypassAnim)
	---@type string | table
	local anim = type(itemAnimList[item.name]) == "table" and itemAnimList[item.name][toggle and "on" or "off"] or
		itemAnimList[item.name]
	anim = anim or "adjust"

	item.metadata.sex = item.metadata.sex or player:sex()
	local oldOutfit = Functions.DeepCopy(player:skin():outfit())

	local outfit = ClientModules.Inventory:CalculateItemOutfit(item, toggle, player:skin():outfit())

	if bypassAnim then
		player:skin():outfit(outfit)
		return true
	end

	ClientModules.Misc.Animations:Play(anim, nil, function()
		player:skin():outfit(outfit)

		Events.TriggerServer('player:updateSkin', 'outfit', player:skin():outfit())

		Utils.Clone.UpdatePed(nil, oldOutfit);

		player:inventory():setIsChangingClothe(false)

		self:Refresh()
	end)

	return true
end

function ClientModules.Inventory:CalculateOutfitItem(list)
	local items = {}
	for key, item in pairs(list) do
		if item.name ~= "outfit" then
			items[item.name] = Functions.DeepCopy(item)
		end
	end

	return Item.Create("outfit", { items = Functions.DeepCopy(items) }, 1)
end

function ClientModules.Inventory:UpdateAtFirstLogin()
	if not player:metadata().newOutfitMethodUpdated then
		-- Convert skin data to skin object
		local skinOutfit = player:skin():outfit()
		-- Clear current outfit in case of ped swap
		player:inventory():clothes({})
		-- Convert skin to outfit items (props and components)
		ClientModules.Inventory:UpdateClothesMethod(player, skinOutfit, player:metadata().useOutfit == true)
		-- Update metadata
		player:metadata().newOutfitMethodUpdated = true
		UI:AddNotification("basic", "~s~Vos tenues ont été mises à jour avec ~g~succès~s~.", "info", 5000)
		Events.TriggerServer("inventory:update", player:inventory())
		Events.TriggerServer("player:update", "metadata", player:metadata())
	end
end
