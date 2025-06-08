Citizen.CreateThread(function()
	local data = {}
    while true do
		data = Callbacks.Trigger("rich_presence:info") or {}

        SetDiscordAppId("1187526717833752606")
		SetRichPresence(("%d/%d"):format(data.count or 0, data.max or 512))
		SetDiscordRichPresenceAsset("outro_logo")
		SetDiscordRichPresenceAssetText(data.name or "Outro")

        Citizen.Wait(30000)
    end
end)
