ServerModules = ServerModules or {}
ServerModules.Admin = ServerModules.Admin or {}
ServerModules.Admin.Variables = {}
ServerModules.Admin.Variables.Initialized = false

function ServerModules.Admin.Variables:LoadAll()
	Citizen.CreateThread(function()
		for _, v in pairs(DB.Variable.All()) do
			GlobalState[v.name] = tonumber(v.value)
			Citizen.Wait(0)
		end
	end)
end

function ServerModules.Admin.Variables:Set(source, name, value)
	local player = Players.Get(source)

	if player == nil or player:permissions() < Config.Permissions.IGM then return end

	DB.Variable.Update(name, value)
	GlobalState[name] = value
end

function ServerModules.Admin.Variables:List(source)
	local player = Players.Get(source)

    if player == nil or player:permissions() < Config.Permissions.IGM then return end

    local list = {}

    for k, v in pairs(DB.Variable.List()) do
        list[v.name] = v.label
    end

    return list
end

function ServerModules.Admin.Variables:RegisterEvents()
	Events.Register("variable:set", function(source, name, value)
		self:Set(source, name, value)
	end)

	Callbacks.Register("variable:list", function(source)
		return self:List(source)
	end)
end

function ServerModules.Admin.Variables:Initialize()
	if self.Initialized == true then return end

	self:LoadAll()
	self:RegisterEvents()

	self.Initialized = true
end

ServerModules.Admin.Variables:Initialize()
