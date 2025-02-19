
local places = {
    [16732694052] = "https://raw.githubusercontent.com/ProjektEta/Femsense-Scripts/refs/heads/main/V1/Fisch/Main.lua",
    [18901165922] = 'https://raw.githubusercontent.com/ProjektEta/Femscr.dll/refs/heads/main/Scripts/Pets%20Go/Premium.lua'
}


if not places[game.PlaceId] then
    game.Players.LocalPlayer:Kick("Game unsupported")
end


loadstring(game:HttpGet(places[game.PlaceId]))()

