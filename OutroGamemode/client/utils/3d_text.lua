Utils = Utils or {}

Utils.Fonts = {}

local function StringToArray(str, linesize)
    local charCount = #str
    local strCount = math.ceil(charCount / linesize)
    local strings = {}

    for i = 1, strCount do
        local start = (i - 1) * (linesize) + 1
        local clamp = Math.Clamp(#string.sub(str, start), 0, linesize)
        local finish = ((i ~= 1) and (start - 1) or 0) + clamp

        strings[i] = string.sub(str, start, finish)
    end

    return table.concat(strings, "~n~")
end

local colors = {
	["blue"]	= { r = 0,		g = 181, 	b = 254,	a = 255 },
	["white"]	= { r = 255,	g = 255, 	b = 255,	a = 255 },
	["yellow"]	= { r = 250,	g = 204, 	b = 21,		a = 255 },
	["orange"]	= { r = 249,	g = 115, 	b = 22,		a = 255 },
	["pink"]	= { r = 236,	g = 72, 	b = 153,	a = 255 },
	["red"]		= { r = 220,	g = 38,		b = 38,		a = 255 },
	["green"]	= { r = 34,		g = 197,	b = 94,		a = 255 },
	["purple"]	= { r = 147,	g = 51,		b = 234,	a = 255 },
}

Citizen.CreateThread(function()
    RegisterFontFile('archivo')
    Utils.Fonts.chalet 			= 0
    Utils.Fonts.sign_painter	= 1
    Utils.Fonts.slab_serif		= 2
    Utils.Fonts.chalet_comprime	= 4
    Utils.Fonts.pricedown		= 7
    Utils.Fonts.archivo			= RegisterFontId('Archivo')
end)

Utils.Draw3DText = function(coords, text, size, distance, linebreak)
	local onScreen, x, y = GetScreenCoordFromWorldCoord(coords.x, coords.y, coords.z + 1.0)
	local color = colors[ClientModules.Misc.Settings:Get("me_color")]

    if onScreen == false or Math.Distance(player:position(), coords) > distance then
        return
    end

	if size == nil then
		size = 1
	end

	BeginTextCommandDisplayText('STRING')

	SetTextScale(0.0, 0.55 * (size / Math.Distance(GetFinalRenderedCamCoord(), coords)) * 2 * (1 / GetGameplayCamFov()) * 100)
	SetTextFont(ClientModules.Misc.Settings:Get("me_font"))
	SetTextColour(color.r, color.g, color.b, color.a)
	SetTextCentre(true)
	SetTextOutline()

	AddTextComponentSubstringPlayerName(StringToArray(text, linebreak == true and 25 or 2000))
	EndTextCommandDisplayText(x, y)
end

Utils.Draw2DText = function(screenX, screenY, text, size, linebreak)
	local color = colors[ClientModules.Misc.Settings:Get("me_color")]

	if size == nil then
		size = 1
	end

	BeginTextCommandDisplayText('STRING')

	SetTextScale(0.0, size)
	SetTextFont(ClientModules.Misc.Settings:Get("me_font"))
	SetTextColour(color.r, color.g, color.b, color.a)
	SetTextCentre(true)
	SetTextOutline()

	AddTextComponentSubstringPlayerName(StringToArray(text, linebreak == true and 25 or 2000))
	EndTextCommandDisplayText(screenX, screenY)
end
