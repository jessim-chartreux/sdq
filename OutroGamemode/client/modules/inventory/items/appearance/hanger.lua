Item.RegisterUsable("hanger", function()
	player:metadata().useOutfit = true

	local item = ClientModules.Inventory:CalculateOutfitItem(player:inventory():clothes())
	player:inventory():clothes({})
    player:inventory():addClothingItem(item, true)
	player:inventory():setIsChangingClothe(false)

	ClientModules.Inventory:Refresh()
	return true
end)
