local places = {
    [16732694052] = "https://raw.githubusercontent.com/ProjektEta/Femsense-Beta/refs/heads/main/Scripts/Fisch.lua",
}


if not places[game.PlaceId] then
    game.Players.LocalPlayer:Kick("Game unsupported")
    return;
end


loadstring(game:HttpGet(places[game.PlaceId]))()

