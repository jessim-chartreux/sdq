Item.RegisterUsable("repair_kit", function(item, entity)
    if not entity then
        entity = ClientModules.Vehicles:GetClosest()
    end

    if Math.Distance(player:position(), GetEntityCoords(entity, true)) > 2.5 then
        UI:AddNotification("basic", "~r~Vous êtes trop loin du véhicule", "info", 5000)
        return false
    end

	if GetDutyCount("mechanic_") > 0 then
		return UI:AddNotification("basic", "Des mécanos sont en service, appelez-les.", "info", 5000)
	end

    TaskTurnPedToFaceEntity(PlayerPedId(), entity, 1000)
    Utils.RealWait(1000)

    ClientModules.Misc.Animations:Play("mechanic2")
	UI:Progress(30)
    Utils.RealWait(30000)
    ClientModules.Misc.Animations:Stop()
	ClientModules.Vehicles.Actions:Call("repair", entity, { true })

    return true
end, "vehicle")
