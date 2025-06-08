local cache = {}

local DISCORD_API_URL = "https://discord.com/api/guilds/1269957339822161940/members/"
local BOT_TOKEN = ""
local CACHE_TIMEOUT = 15 * 60 * 1000 
local REQUEST_TIMEOUT = 5000 

function GetGuildMember(memberId)
    if cache[memberId] ~= nil then
        return cache[memberId]
    end

    local response, code = nil, nil
    local isResponseReceived = false

    PerformHttpRequest(
        DISCORD_API_URL .. memberId,
        function(_code, body, headers)
            response = body
            code = _code
            isResponseReceived = true
        end,
        "GET",
        "",
        {
            ["Content-Type"] = "application/json",
            ["Authorization"] = "Bot " .. BOT_TOKEN
        }
    )

    local waited = 0
    while not isResponseReceived and waited < REQUEST_TIMEOUT do
        Citizen.Wait(50)
        waited = waited + 50
    end

    if not isResponseReceived then
        print("[Erreur] Timeout : aucune réponse de l'API Discord après " .. REQUEST_TIMEOUT .. "ms.")
        return nil
    elseif code ~= 200 then
        print("[Erreur] Échec de la requête API Discord. Code HTTP : " .. tostring(code))
        return nil
    end

    local decodedResponse = json.decode(response)
    if not decodedResponse then
        print("[Erreur] Impossible de décoder la réponse JSON de l'API Discord.")
        return nil
    end

    cache[memberId] = decodedResponse

    Citizen.SetTimeout(CACHE_TIMEOUT, function()
        cache[memberId] = nil
    end)

    return cache[memberId]
end

function GetPermissions(memberId)
    local member = GetGuildMember(memberId)

    if member == nil then
        print("[Erreur] Impossible de récupérer les permissions. Membre introuvable ou erreur API.")
        return nil
    end

    local permission_level = 0

    for _, role in pairs(member.roles or {}) do
        if Config.PermissionLevels and Config.PermissionLevels[role] ~= nil then
            if Config.PermissionLevels[role] > permission_level then
                permission_level = Config.PermissionLevels[role]
            end
        end
    end

    return permission_level
end