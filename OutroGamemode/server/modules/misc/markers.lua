Events.Register("marker:create", function(source, name, type, coords, data)
    if type == "" then
        type = nil
    end

	local bucket = GetPlayerRoutingBucket(source)

    DB.Marker.Create(name, type, coords, data, bucket)
    Events.TriggerClient("marker:create", -1, name, type, coords, data, bucket)
end)

Events.Register("marker:update", function(source, name, type, coords, data, bucket)
    DB.Marker.Update(name, type, coords, data, bucket)
    Events.TriggerClient("marker:update", -1, name, type, coords, data, bucket)
end)

Events.Register("marker:updatePrecisely", function(source, name, adress, value)
    local marker = DB.Marker.Get(name)
    if marker == nil then return end

    local editedData = Table.Navigate(marker, adress)

    if editedData == nil then return end

    editedData = value

    DB.Marker.Update(name, marker.type, marker.coords, marker.data, marker.bucket)

    Events.TriggerClient("marker:updatePrecisely", -1, name, adress, value)
end)

Events.Register("marker:delete", function(source, name)
    DB.Marker.Delete(name)
    Events.TriggerClient("marker:delete", -1, name)
end)

Events.Register("marker:load", function(source)
	Events.TriggerClientLatent("marker:load", source, DB.Marker.All())
end)
