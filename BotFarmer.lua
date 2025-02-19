repeat
    wait()
until game:IsLoaded()

local __loadedTime = os.time()

local LocalPlayerPawn = game.Players.LocalPlayer
local GuiService = game:GetService("GuiService")
local VIM = game:GetService("VirtualInputManager")

repeat
    wait()
until LocalPlayerPawn.Character

LocalPlayerPawn.Character.HumanoidRootPart.CFrame = CFrame.new(-1406.72839, -277.854156, -2856.31812, -0.590612888, -0.0480175428, -0.805525124, 9.73045826e-06, 0.998227596, -0.0595117137, 0.80695504, -0.0351562202, -0.589565575)


local StuckBG = Instance.new("BodyGyro", LocalPlayerPawn.Character.Torso)
StuckBG.P = 9e4
StuckBG.maxTorque = Vector3.new(9e9, 9e9, 9e9)
StuckBG.cframe = LocalPlayerPawn.Character.Torso.CFrame
local StuckBV = Instance.new("BodyVelocity", LocalPlayerPawn.Character.Torso)
StuckBV.velocity = Vector3.new(0,0.1,0)
StuckBV.maxForce = Vector3.new(9e9, 9e9, 9e9)

LocalPlayerPawn.Character.Humanoid.PlatformStand = true

VIM:SendKeyEvent(true, Enum.KeyCode.One, false, game)
VIM:SendKeyEvent(false, Enum.KeyCode.One, false, game)

LocalPlayerPawn.Idled:Connect(function(time)
    VIM:SendKeyEvent(true, Enum.KeyCode.B, false, game)
    VIM:SendKeyEvent(false, Enum.KeyCode.B, false, game)
end)

local playerstats_start = {
    Money = 0,
    TotalXP = 0
}

if LocalPlayerPawn.Character ~= nil and LocalPlayerPawn.Character:WaitForChild("oxygen") ~= nil and LocalPlayerPawn.Character:WaitForChild("oxygen").Enabled == true then	
    LocalPlayerPawn.Character.oxygen.Enabled = false	
end	
if LocalPlayerPawn.Character ~= nil and LocalPlayerPawn.Character:WaitForChild("oxygen(peaks)") ~= nil and LocalPlayerPawn.Character:WaitForChild("oxygen(peaks)").Enabled == true then	
    LocalPlayerPawn.Character["oxygen(peaks)"].Enabled = false	
end	

playerstats_start.Money = game.ReplicatedStorage.playerstats:FindFirstChild(LocalPlayerPawn.Name).Stats.coins.Value
playerstats_start.TotalXP = game.ReplicatedStorage.playerstats:FindFirstChild(LocalPlayerPawn.Name).Stats.xp.Value + (game.ReplicatedStorage.playerstats:FindFirstChild(LocalPlayerPawn.Name).Stats.level.Value * 10000)

local function mainLoop()
    game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("afk"):FireServer(false)
    game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("SellAll"):InvokeServer()  

    local s,e = pcall(function()
        LocalPlayerPawn.Character.HumanoidRootPart.CFrame = CFrame.new(-1406.72839, -277.854156, -2856.31812, -0.590612888, -0.0480175428, -0.805525124, 9.73045826e-06, 0.998227596, -0.0595117137, 0.80695504, -0.0351562202, -0.589565575)

        local event;

        for _,v in pairs(LocalPlayerPawn.Character:GetChildren()) do
            if v:IsA("Tool") then event = v end
        end
    
        event.events.cast:FireServer(100, 1)
    end)
    if e then
        return
    end

    local _bounceback = 0
    local ui = LocalPlayerPawn.PlayerGui:FindFirstChild("shakeui")
    repeat
        ui = LocalPlayerPawn.PlayerGui:FindFirstChild("shakeui")
        task.wait(.1)
        _bounceback += 1

        if (_bounceback >= 20) then
            print("protection")
            return
        end
    until ui

    repeat
        if ui:FindFirstChild("safezone") then
            if ui.safezone:FindFirstChild("button") then
                pcall(function()
                    GuiService.SelectedObject = ui.safezone:FindFirstChild("button")
                    if GuiService.SelectedObject == ui.safezone:FindFirstChild("button") then
                        VIM:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                        VIM:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                    end
                end)
            end
        end
        task.wait()
        ui = LocalPlayerPawn.PlayerGui:FindFirstChild("shakeui")
        if not (ui) then ui = false end
    until not ui
    print("Shake ui disappeared")

    local bounceBack = 0
    
    ui = LocalPlayerPawn.PlayerGui:FindFirstChild("reel")
    repeat
       task.wait(.1)
       ui = LocalPlayerPawn.PlayerGui:FindFirstChild("reel") 
       bounceBack += 1
       if bounceBack >= 20 then
            print("protection")
            return;
       end
       
    until ui
    print("Found Reel UI")

    task.wait(1)
    repeat
        task.wait()
        if ui:FindFirstChild("bar") then
            local b = ui:FindFirstChild("bar")
            if b:FindFirstChild("fish") and b:FindFirstChild("playerbar") then
                b:FindFirstChild("playerbar").Position = b:FindFirstChild("fish").Position
            end

            game.ReplicatedStorage.events["reelfinished "]:FireServer(100, true)
        end
        ui = LocalPlayerPawn.PlayerGui:FindFirstChild("reel") 
        if not (ui) then ui = false end
    until not ui 

    return;

end

if shared.usewebhook == true then
    task.spawn(function()
        while task.wait(30) do
            local s,e = pcall(function()
    
                local curTime = os.time()
    
                local curTotalXP = game.ReplicatedStorage.playerstats:FindFirstChild(LocalPlayerPawn.Name).Stats.xp.Value + (game.ReplicatedStorage.playerstats:FindFirstChild(LocalPlayerPawn.Name).Stats.level.Value * 10000)
                local curTotalMoney = game.ReplicatedStorage.playerstats:FindFirstChild(LocalPlayerPawn.Name).Stats.coins.Value
                local curTotalLevels = curTotalXP / 10000
    
                request({
                    Url = shared.webhook,
                    Method = "Post",
                    Headers = {
                        ['content-type'] = "application/json",
                    },
                    Body = game:GetService("HttpService"):JSONEncode({
                        ['embeds'] = {{
                            ['title'] = "__**FEMSENSE AUTO FISHER**__",
                            ['description'] = "Time running... "..math.round(((curTime - __loadedTime) / 86400)).." Hours",
                            ['type'] = "rich",
                            ['color'] = tonumber(0xffffff),
                            ['fields'] = {
                                {
                                    ["name"] = "Money",
                                    ["value"] = "Money Earned: "..math.round((curTotalMoney - playerstats_start.Money)).."\nC$/h: "..math.round(((curTotalMoney - playerstats_start.Money) / ((curTime - __loadedTime) / 86400)))
                                },
                                {
                                    ["name"] = "XP",
                                    ["value"] = "XP Earned: "..math.round((curTotalXP - playerstats_start.TotalXP)).."\nXP/h: "..math.round(((curTotalXP - playerstats_start.TotalXP) / ((curTime - __loadedTime) / 86400)))
                                },
                                {
                                    ["name"] = "Levels",
                                    ["value"] = "Levels Earned: "..math.round((curTotalLevels - (playerstats_start.TotalXP / 10000))).."\nLevels/h: "..math.round(((curTotalLevels - (playerstats_start.TotalXP / 10000)) / ((curTime - __loadedTime) / 86400)))
                                },
                                {
                                    ["name"] = "**ADVERTISEMENT**",
                                    ["value"] = "JOIN FEMSENSE NOW! https://discord.gg/x4RfPQZvs2"
                                },
                            },
                            ['footer'] = {
                                ['text'] = "Eta is best femboy ^^"
                            }
                        }}
                    })
                })
            end)
            if e then
                warn(e)
            end
        end
    end)
end

while task.wait(1) do
    mainLoop()
end
