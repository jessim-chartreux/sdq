DB = DB or {}
DB.Marker = {}
Markers = Markers or {}

DB.Marker.Get = function(name)
    if Markers[name] ~= nil then return Markers[name] end

    local result = MySQL.single.await("SELECT * FROM `markers` WHERE `name` = ?", { name })

    if result == nil then return nil end

    Markers[result.name] = {
        name = result.name,
        type = result.type,
        coords = json.decode(result.coords),
        data = json.decode(result.data),
        bucket = result.bucket
    }

    return Markers[result.name]
end

DB.Marker.All = function()
    local result = MySQL.query.await("SELECT * FROM `markers`")

    for i = 1, #result do
        Markers[result[i].name] = {
            name = result[i].name,
            type = result[i].type,
            coords = json.decode(result[i].coords),
            data = json.decode(result[i].data),
            bucket = result[i].bucket
        }
    end

    return Markers
end

DB.Marker.Create = function(name, type, coords, data, bucket)
    Markers[name] = {
        name = name,
        type = type,
        coords = coords,
        data = data,
        bucket = bucket
    }

    return MySQL.insert.await("INSERT INTO `markers` (`name`, `type`, `coords`, `data`, `bucket`) VALUES (?, ?, ?, ?, ?)", {
        Markers[name].name,
        Markers[name].type,
        json.encode({ x = Markers[name].coords.x, y = Markers[name].coords.y, z = Markers[name].coords.z }),
        json.encode(Markers[name].data),
        Markers[name].bucket
    })
end

DB.Marker.Update = function(name, type, coords, data, bucket)
    Markers[name] = {
        name = name,
        type = type,
        coords = coords,
        data = data,
        bucket = bucket
    }

    return MySQL.insert.await("INSERT INTO `markers` (`name`, `type`, `coords`, `data`, `bucket`) VALUES (?, ?, ?, ?, ?)", {
        Markers[name].name,
        Markers[name].type,
        json.encode({ x = Markers[name].coords.x, y = Markers[name].coords.y, z = Markers[name].coords.z }),
        json.encode(Markers[name].data),
        Markers[name].bucket
    })
end

DB.Marker.Delete = function(name)
    Markers[name] = nil
    return MySQL.query.await("DELETE FROM `markers` WHERE `name` = ?", { name })
end
