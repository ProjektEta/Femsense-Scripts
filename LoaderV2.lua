local places = {
    [16732694052] = "https://raw.githubusercontent.com/ProjektEta/Femsense-Scripts/refs/heads/main/V2/Fisch/Main.lua",
}


if not places[game.PlaceId] then
    game.Players.LocalPlayer:Kick("Game unsupported")
    return;
end


loadstring(game:HttpGet(places[game.PlaceId]))()

