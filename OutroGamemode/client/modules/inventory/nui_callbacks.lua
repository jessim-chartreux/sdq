local SLOT_PREFIXES  = {
	RIGHT_PANEL = "o",
	LEFT_PANEL = "p",
	CHARACTER = "c"
}

---@param slot string
---@return "p" | "o" | "c", string
local function extractSlotPrefix(slot)
	return slot:sub(1, 1), slot:sub(3)
end

---@param data { item: Item, quantity: integer, target: string }
---@param cb fun(response: boolean)
UI:RegisterCallback('inventory:moveItem', function(data, cb)
	local inventories = {
		origin = nil,
		target = nil
	}

	--- 'issue' caused by react-dnd version post 14.1 that required to change the structure in \Outro-UI\src\components\Inventory\Slot\Slot.tsx:68
	if data.item.type ~= nil then
	---@diagnostic disable-next-line: inject-field
		data.item.type = nil
	end

	local originPrefix, originSlot = extractSlotPrefix(data.item.slot)
	local targetPrefix, targetSlot = extractSlotPrefix(data.target)

	data.item.slot = originSlot
	data.target = targetSlot

	if originPrefix == SLOT_PREFIXES.RIGHT_PANEL then
		inventories.origin = ClientModules.Inventory.rightPanel
	else
		inventories.origin = player:inventory()
	end

	if targetPrefix == SLOT_PREFIXES.RIGHT_PANEL then
		inventories.target = ClientModules.Inventory.rightPanel
	else
		inventories.target = player:inventory()
	end

	local itemOnTargetSlot = inventories.target:findItem(function(item)
		return item.slot == data.target and item.metadata.category == data.item.metadata.category
	end)

	local itemOnSlot = inventories.origin:findItem(function(item)
		return item.slot == data.item.slot and item.metadata.category == data.item.metadata.category
	end)

	if originPrefix ~= SLOT_PREFIXES.CHARACTER and (itemOnSlot == nil or Table.compareMetadatas(itemOnSlot, data.item) == false) then
		UI:AddNotification("basic", "~r~L'item n'est plus présent à cet emplacement.~s~", "info", 5000)
		return
	end

	-- Swap target item with origin item
	if (
		itemOnTargetSlot ~= nil
		and (itemOnTargetSlot.name ~= data.item.name or Table.compareMetadatas(itemOnTargetSlot.metadata, data.item.metadata) == false)
	) then
		local newOriginItem, newTargetItem = Functions.DeepCopy(data.item), Functions.DeepCopy(itemOnTargetSlot)
		newTargetItem.slot = data.item.slot
		newOriginItem.slot = data.target

		if originPrefix == SLOT_PREFIXES.CHARACTER then return end

		if inventories.origin:updateItem(data.item, newTargetItem) == false then
			UI:AddNotification("basic", "~r~Une erreur s'est produite (origin_swap_update)~s~", "info", 5000)
			return
		end

		if inventories.target:updateItem(itemOnTargetSlot, newOriginItem) == false then
			UI:AddNotification("basic", "~r~Une erreur s'est produite (target_swap_update)~s~", "info", 5000)
			inventories.origin:updateItem(newTargetItem, data.item)
			return
		end

		return
	end

	-- Move item
	data.item.quantity = data.quantity
	if originPrefix ~= SLOT_PREFIXES.CHARACTER and inventories.origin:removeItem(data.item) == false then
		UI:AddNotification("basic", "~r~Une erreur s'est produite (origin_remove)~s~", "info", 5000)
		return
	end

	if (originPrefix == SLOT_PREFIXES.CHARACTER) then
		if inventories.target:id() ~= player:inventory_id() then
			UI:AddNotification("basic", "~r~Impossible de donner un vêtement que vous portez~s~", "info", 5000)
			return
		end

		if inventories.target._isChangingClothe then
			UI:AddNotification("basic", "~r~Vous êtes déjà en train de changer de vêtements.~s~", "info", 5000)
			return
		end

		inventories.target:removeClothe(data.item, false, targetSlot)
		return
	end

	data.item.slot = data.target
	if inventories.target:addItem(data.item) == false then
		UI:AddNotification("basic", "~r~Une erreur s'est produite (target_add)~s~", "info", 5000)

		data.item.slot = originSlot
		inventories.origin:addItem(data.item)

		return
	end
end)

---@param item Item
---@param cb fun(response: boolean)
UI:RegisterCallback('inventory:useItem', function(item, cb)
	local originPrefix, originSlot = extractSlotPrefix(item.slot)

	if originPrefix ~= SLOT_PREFIXES.LEFT_PANEL then
		UI:AddNotification("basic", "~r~Vous ne pouvez pas utiliser un item qui n'est pas dans votre inventaire.~s~", "info", 5000)
		return
	end

	item.slot = originSlot

	if item.metadata.category == "clothes" then
		local inventory = player:inventory()

		if inventory._isChangingClothe then
			UI:AddNotification("basic", "~r~Vous êtes déjà en train de changer de vêtements.~s~", "info", 5000)
			return
		end

		if inventory:isCorrectSex(item) == false then
			UI:AddNotification("basic", "~r~Vous ne pouvez pas équiper un vêtement du sexe opposé.~s~", "info", 5000)
			inventory:setIsChangingClothe(false)
			return
		end

		local hasAlready = inventory:getClothe(item.name)

		if hasAlready then
			local _ = inventory:removeClothe(hasAlready, false, nil, true)
		end

		-- Detect if the item is using old method and if it is, update it
		if inventory:isOutfitItem(item) and item.metadata.outfit ~= nil then
			local newItem = ClientModules.Inventory:UpdateClothesMethod(player, item.metadata.outfit, true, false)

			if newItem == nil then
				UI:AddNotification("basic", "~r~Une erreur s'est produite (update_clothes_method)~s~", "info", 5000)
				return
			end

			newItem.metadata.name = (item.metadata.name ~= nil and item.metadata.name or "Tenue") .. " (MAJ)"
			newItem.slot = originSlot

			if inventory:removeItem(item) then
				inventory:addItem(newItem)
				item = newItem
				UI:AddNotification("basic", "La tenue a été ~g~mise à jour~s~.", "info", 5000)
			else
				UI:AddNotification("basic", "~r~Une erreur s'est produite (remove_item_update)~s~", "info", 5000)
				return
			end
		end

		inventory:addClothingItem(item)
		return
	elseif Item.IsUsable(item.name) == false then
		UI:AddNotification("basic", "~r~Cet item n'est pas utilisable.~s~", "info", 5000)
		return
	end

	Item.Use(item)
end)


---@param item Item
---@param cb fun(response: boolean)
UI:RegisterCallback('inventory:giveItem', function(item, cb)
	local originPrefix, originSlot = extractSlotPrefix(item.slot)

	--- 'issue' caused by react-dnd version post 14.1 that required to change the structure in \Outro-UI\src\components\Inventory\Slot\Slot.tsx:68
	if item.type ~= nil then
		---@diagnostic disable-next-line: inject-field
		item.type = nil
	end

	if originPrefix ~= SLOT_PREFIXES.LEFT_PANEL then
		UI:AddNotification("basic", "~r~Vous ne pouvez pas donner un item qui n'est pas dans votre inventaire.~s~", "info", 5000)
		return
	end

	item.slot = originSlot

	Callbacks.Trigger("inventory:give", item, ClientModules.Inventory.targetPlayer)
end)

---@param data { item: Item, name: string }
---@param cb fun(response: boolean)
UI:RegisterCallback('inventory:renameItem', function(data, cb)
    local inventory = nil

	local prefix, slot = extractSlotPrefix(data.item.slot)

	data.item.slot = slot

	if prefix == SLOT_PREFIXES.RIGHT_PANEL then
		inventory = ClientModules.Inventory.rightPanel
	else
		inventory = player:inventory()
	end

	if inventory == nil then
		return
	end

	data.name = data.name:lower()

	if data.name == "" then
		data.name = nil
	end

	if (data.item.metadata.name or ""):lower() ~= data.name then
		local newItem = Functions.DeepCopy(data.item)
		newItem.metadata.name = data.name

		if prefix == SLOT_PREFIXES.CHARACTER then
			player:inventory():updateClothe(data.item, newItem)
		else
			inventory:updateItem(data.item, newItem)
		end
		cb(true)
	end
end)

---@param item Item
---@param cb fun(response: boolean)
UI:RegisterCallback('inventory:throwItem', function(item, cb)
    local originPrefix, originSlot = extractSlotPrefix(item.slot)

	if originPrefix ~= SLOT_PREFIXES.LEFT_PANEL then
		UI:AddNotification("basic", "~r~Vous ne pouvez pas jeter un item qui n'est pas dans votre inventaire.~s~", "info", 5000)
		return
	end

	item.slot = originSlot

	if player:inventory():removeItem(item) == false then
		UI:AddNotification("basic", "~r~Une erreur s'est produite (origin_remove_item).~s~", "info", 5000)
		return
	end

    ClientModules.Misc.Animations:Play('pickup')

	if Utils.Streaming.RequestModel(Config.Pickups.ModelHash) == nil then return end

	local min, max = GetModelDimensions(Config.Pickups.ModelHash)
	local position = player:position()
    local height = max.z - min.z

	-- Calculate the position in front of the player
	local forward = GetEntityForwardVector(PlayerPedId())
	position = vector3(position.x + forward.x * 0.5, position.y + forward.y * 0.5, position.z)

	local retval, groundZ = GetGroundZFor_3dCoord(position.x, position.y, position.z, false)

	while not retval do
		retval, groundZ = GetGroundZFor_3dCoord(position.x, position.y, position.z, false)
		Citizen.Wait(0)
	end

	groundZ += height / 2

	Events.TriggerServer("pickup:create",
		Item.Create(item.name, item.metadata, item.quantity),
		vector4(position.x, position.y, groundZ, GetEntityHeading(PlayerPedId()))
	)

    Events.TriggerServer("me", "jette quelque chose")
end)

UI:RegisterCallback("inventory:toggleHairTie", function()
	ClientModules.Misc.Animations:Play("think5")
	UI:Progress(2)
	Utils.RealWait(2000)
	player:skin():tieHair()
end)

UI:RegisterCallback('inventory:closed', function(data, cb)
    ClientModules.Inventory.opened = false
    cb(true)
end)
