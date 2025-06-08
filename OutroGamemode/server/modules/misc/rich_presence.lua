Callbacks.Register("rich_presence:info", function()
	return {
		name = GetConvar("sv_hostname", "Outro"),
		max = GetConvarInt("sv_maxclients", 512),
		count = #GetPlayers(),
	}
end)
