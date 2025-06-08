-- Check @shared/classes/Inventory.lua for class definition

---@private
---@param type InventoryAction
---@param item Item
---@param updatedItem? Item
---@return boolean
function Inventory:action(type, item, updatedItem, outfitAffiliated, targetSlot)
	if type == "update" or type == "clothe_update" then
		return Callbacks.Trigger("inventory:action", self:id(), type, item, updatedItem) or false
	elseif type == "clothe_add" or type == "clothe_remove" then
		return Callbacks.Trigger("inventory:action", self:id(), type, item, nil, outfitAffiliated, targetSlot) or false
	else
		return Callbacks.Trigger("inventory:action", self:id(), type, item) or false
	end
end

---@private
---@param type "money" | "slot"
---@param p1 any
---@return any
function Inventory:check(type, p1)
	return Callbacks.Trigger("inventory:check", self:id(), type, p1) or false
end

---@param amount integer Money amount to check if is present in this inventory
---@return boolean Success
function Inventory:hasEnoughMoney(amount)
	return self:check("money", amount)
end

---@param itemOrCategory Item | "other" | "clothes" | "keys"
---@return string | nil
function Inventory:findFreeSlot(itemOrCategory)
	return self:check("slot", itemOrCategory)
end

---@param item Item | nil Item to add
---@return boolean Success
function Inventory:addItem(item)
	if item == nil then return false end

	return self:action("add", item)
end

---@param item? Item Item to remove
---@return boolean Success
function Inventory:removeItem(item)
	if item == nil then return false end

	return self:action("remove", item)
end

---@param oldItem? Item Item to update
---@param newItem? Item Item to update
---@return boolean Success
function Inventory:updateItem(oldItem, newItem)
	if oldItem == nil or newItem == nil then return false end

	return self:action("update", oldItem, newItem)
end

function Inventory:itemIsNull(item)
	return item == nil
end

function Inventory:isBulletProofClothing(item)
	if self:itemIsNull(item) then return false end

	return item.metadata.componentId == Lists.Variations.Clothes.KEVLAR and Lists.BulletProofs[player:sex()][item.metadata.component] ~= nil
end

function Inventory:toggleBulletProof(item, toggle)
	if self:itemIsNull(item) then return false end
	-- Simplify bulletProofLevel determination
	local defaultBulletProofLevel = Lists.BulletProofs[player:sex()][item.metadata.component]
	local bulletProofLevel = item.metadata.armor or defaultBulletProofLevel

	if toggle then
		-- Apply bullet proof armor
		player:armor(bulletProofLevel)
	else
		-- Reset armor to 0 and store current armor level in item metadata
		bulletProofLevel = player:armor()
		player:armor(0)
	end

	-- Update item metadata
	item.metadata.armor = bulletProofLevel

	return true
end

function Inventory:isCorrectSex(item)
	if self:itemIsNull(item) then return false end

	return item.metadata.sex == nil or player:sex() == item.metadata.sex
end

function Inventory:isOutfitItem(item)
	return item.name == "outfit"
end

function Inventory:setIsChangingClothe(isChangingClothe, timeout)
	self._isChangingClothe = isChangingClothe
	if timeout then
		self._isChangingClotheTimeoutId = math.random(100000, 999999)
		local timeoutId = self._isChangingClotheTimeoutId
		Citizen.SetTimeout(timeout, function()
			if self._isChangingClotheTimeoutId == timeoutId then
				self:setIsChangingClothe(false)
			end
		end)
	end
end

function Inventory:handleOutfitItem(item, add, outfitAffiliated, bypassAnim)
	if add then
		if item.metadata.items == nil then
			UI:AddNotification("basic", "La tenue est vide", "error", 2500)
			self:setIsChangingClothe(false)
			return false
		end

		for _, clothe in pairs(self:clothes()) do
			self:removeClothe(clothe, false, nil, true)
		end

		for _, clothe in pairs(item.metadata.items) do
			self:addClothingItem(clothe, true)
		end
	else
		item.metadata.items = Functions.DeepCopy(ClientModules.Inventory:CalculateOutfitItem(self:clothes()).metadata.items)
		for _, clothe in pairs(item.metadata.items) do
			self:removeClothe(clothe, true)
		end
	end
end

function Inventory:addSingleClothingItem(item, outfitAffiliated, bypassAnim)
	if self:itemIsNull(item) then return false end

	if not self:action("clothe_add", item, nil, outfitAffiliated) then
		self:setIsChangingClothe(false)
		return false
	end

	if not outfitAffiliated then
		ClientModules.Inventory:HandleOutfitUpdate(item, true, bypassAnim)
		return
	end
end

function Inventory:addClothingItem(item, outfitAffiliated, bypassAnim)
	if self:itemIsNull(item) then return false end

	self:setIsChangingClothe(true, 3000)
	if self:isOutfitItem(item) then
		self:handleOutfitItem(item, true, outfitAffiliated, bypassAnim)
	end

	if self:isBulletProofClothing(item) then
		self:toggleBulletProof(item, true)
	end

	return self:addSingleClothingItem(item, outfitAffiliated)
end

function Inventory:removeSingleClotheAction(item, outfitAffiliated, targetSlot, bypassAnim)
	if not self:action("clothe_remove", item, nil, outfitAffiliated, targetSlot) then
		self:setIsChangingClothe(false)
		return false
	end

	if not outfitAffiliated then
		ClientModules.Inventory:HandleOutfitUpdate(item, false, bypassAnim)
	end

	return true
end

function Inventory:removeClothe(item, outfitAffiliated, targetSlot, bypassAnim)
	if self:itemIsNull(item) then return false end

	self:setIsChangingClothe(true, 3000)

	if self:isOutfitItem(item) then
		self:handleOutfitItem(item, false)
	end

	if self:isBulletProofClothing(item) then
		self:toggleBulletProof(item, false)
	end

	return self:removeSingleClotheAction(item, outfitAffiliated, targetSlot, bypassAnim)
end

function Inventory:updateClothe(oldItem, newItem)
	if oldItem == nil or newItem == nil then return false end

	return self:action("clothe_update", oldItem, newItem)
end

function Inventory:getClothe(category)
	return self._clothes[category]
end

function Inventory:reapplyOutfit()
	local skin = Functions.DeepCopy(Lists.Variations.NakedOutfits[player:sex() or "m"])
	player:skin()._outfit = Functions.DeepCopy(skin)

	local outfit = Functions.DeepCopy(self:clothes())

	skin = ClientModules.Inventory:CalculateItemOutfit(outfit.outfit, true, skin)
	outfit.outfit = nil

	for k, v in pairs(outfit) do
		skin = Functions.DeepCopy(ClientModules.Inventory:CalculateItemOutfit(v, true, skin))
	end

	player:skin():outfit(skin)
end
