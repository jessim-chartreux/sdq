Item.RegisterUsable("weapon_id_kit", function(item, entity)
	if LocalPlayer.state.current_weapon == nil then
		UI:AddNotification("basic", "~r~Vous n'avez pas d'arme en main~s~", "info", 5000)
		return false
	end

	UI:AddNotification("basic", ("ID de l'arme: ~b~%d~s~ (copié dans le presse-papiers)"):format(LocalPlayer.state.current_weapon), "info", 5000)
	UI:CopyToClipboard(tostring(LocalPlayer.state.current_weapon))

    return false
end)
