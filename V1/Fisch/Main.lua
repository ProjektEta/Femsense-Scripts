repeat
    task.wait()
until game:IsLoaded()

local Client = game.Players.LocalPlayer

local enabled = true

local Config = {
    AutoFish = false,
    ShakeType = "GuiService",
    ReelType = "Always Perfect",
    FreezeCFrame = false,
    LockedCFrame = nil,
    AutoSell = false,
    UseWebhook = shared.UseWebhook,
    WebhookURL = shared.Webhook,
}

local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local VIM = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

loadstring(game:HttpGet('https://raw.githubusercontent.com/drillygzzly/Roblox-UI-Libs/main/Yun%20V2%20Lib/Yun%20V2%20Lib%20Source.lua'))()

local Library = initLibrary()
local Window = Library:Load({name = "Femsense MOBILE", sizeX = 425, sizeY = 512, color = Color3.fromRGB(255, 255, 255)})


local AutoFish = Window:Tab("Fisch")
local Misc = Window:Tab("Misc")
local Femsense = Window:Tab("Femsense")

local __A = AutoFish:Section({name = "Auto Farm", column = 1})
local __C = Misc:Section({name = "Misc", column = 1})
local __E = Misc:Section({name = "World", column = 2})
local __D = AutoFish:Section({name = "Interact", column = 2})
local __B = Femsense:Section({name = "About us", column = 1})


__A:Toggle ({
    Name = "Enable",
    flag = "AutofishEnable", 
    callback = function(bool)
        Config.AutoFish = bool
    end
})

__A:Toggle ({
    Name = "Freeze Character",
    flag = "FreezeCharacter", 
    callback = function(bool)
		Config.FreezeCFrame = bool
    end
})


__A:Toggle ({
    Name = "Auto Sell",
    flag = "Autosell", 
    callback = function(bool)
		Config.AutoSell = bool
    end
})


__A:dropdown ({
    name = "Shake Type",
    content = {"GuiService"},
    multichoice = false,
    callback = function(t) 
		Config.ShakeType = t
    end
})

__A:dropdown ({
    name = "Reel Type",
    content = {"Always Perfect", "Legit", "Instant", "Legit Instant"},
    multichoice = false, 
    callback = function(t)
		Config.ReelType = t
    end
})

__A:Button ({
    name = "Save Position",
    callback = function()
		Config.LockedCFrame = Client.Character.HumanoidRootPart.CFrame
    end
})

__D:Button ({
    name = "Sell All Fish",
    callback = function()
		game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("SellAll"):InvokeServer()
    end
})

__D:Button ({
    name = "Sell Held Fish",
    callback = function()
		game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("Sell"):InvokeServer()
    end
})

__D:Button ({
    name = "Appraise Fish (C$ 450)",
    callback = function()
		workspace:WaitForChild("world"):WaitForChild("npcs"):WaitForChild("Appraiser"):WaitForChild("appraiser"):WaitForChild("appraise"):InvokeServer()
    end
})

__C:Button({
    name = "Claim all codes",
    callback = function()
		local codes = require(game.ReplicatedStorage.modules.CreatorCodes)

        for _,v in pairs(codes) do
            game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("runcode"):FireServer(v) 
        end
    end
})

local _spawnFolder = workspace.world.spawns

for _,v in pairs(_spawnFolder:GetChildren()) do
    if v.Name ~= "loading" or v.Name ~= "TpSpots" then
        
        __E:Button({
            name = v.Name,
            callback = function()
                Client.Character.HumanoidRootPart.CFrame = v:GetChildren()[1].CFrame + Vector3.new(0, 4, 0)
            end
        })

    end
end

__E:Button({
    name = "Trident Puzzle",
    callback = function()
        Client.Character.HumanoidRootPart.CFrame = _spawnFolder.TpSpots.trident.CFrame + Vector3.new(0, 4, 0)
    end
})

__E:Button({
    name = "Sunken Cave",
    callback = function()
        Client.Character.HumanoidRootPart.CFrame = _spawnFolder.TpSpots.sunkencave.CFrame + Vector3.new(0, 4, 0)
    end
})

__E:Button({
    name = "Enchant Room",
    callback = function()
        Client.Character.HumanoidRootPart.CFrame = _spawnFolder.TpSpots.enchant.CFrame + Vector3.new(0, 4, 0)
    end
})

__B:Button ({
    name = "Join Discord",
    callback = function()
        local s,e = pcall(function()
            request({
                Url = "http://127.0.0.1:6463/rpc?v=1",
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json",
                    ["Origin"] = "https://discord.com"
                },
                Body = game:GetService("HttpService"):JSONEncode({
                    cmd = "INVITE_BROWSER",
                    args = {
                        code = "x4RfPQZvs2"
                    },
                    nonce = game:GetService("HttpService"):GenerateGUID(false)
                }),
            })
        end)
    
        setclipboard("https://discord.gg/x4RfPQZvs2")
    end
})

local function autofarmLoop()
    game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("afk"):FireServer(false)
    
    if Config.AutoFish == false then return end

    if Config.AutoSell == true then
        game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("SellAll"):InvokeServer()
    end

    if Config.LockedCFrame ~= nil and Config.FreezeCFrame then
        Client.Character.HumanoidRootPart.CFrame = Config.LockedCFrame
    end

    local event = Client

    local s,e = pcall(function()

        for _,v in pairs(Client.Character:GetChildren()) do
            if v:IsA("Tool") then event = v end
        end
    
        event.events.cast:FireServer(100, 1)
    end)
    if e then
        warn("No fishing rod equipped!")
        return;
    end

    local ui = Client.PlayerGui:FindFirstChild("shakeui")
    repeat
        ui = Client.PlayerGui:FindFirstChild("shakeui")
        task.wait()
    until ui

    repeat
        if ui:FindFirstChild("safezone") then
            if ui.safezone:FindFirstChild("button") then
                pcall(function()
                    if Config.ShakeType == "GuiService" then
                        GuiService.SelectedObject = ui.safezone:FindFirstChild("button")
                        if GuiService.SelectedObject == ui.safezone:FindFirstChild("button") then
                            VIM:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                            VIM:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                        end
                    elseif Config.ShakeType == "Mouse" then
                        mousemoveabs(
                            ui.safezone:FindFirstChild("button").AbsolutePosition.X / 2 + ui.safezone:FindFirstChild("button").AbsoluteSize.X / 2,
                            ui.safezone:FindFirstChild("button").AbsolutePosition.Y / 2  + ui.safezone:FindFirstChild("button").AbsoluteSize.Y / 2
                        )
                        mouse1click()
                    end
                end)
            end
        end
        task.wait()
        ui = Client.PlayerGui:FindFirstChild("shakeui")
        if not (ui) then ui = false end
    until not ui
    print("Shake ui disappeared")

    local bounceBack = 0
    
    ui = Client.PlayerGui:FindFirstChild("reel")
    repeat
       task.wait(.1)
       ui = Client.PlayerGui:FindFirstChild("reel") 
       bounceBack += 1
       if bounceBack >= 20 then
            print("protection")
            return;
       end
       
    until ui
    print("Found Reel UI")

    if Config.ReelType == "Always Perfect" then
        repeat
            task.wait()
            if ui:FindFirstChild("bar") then
                local b = ui:FindFirstChild("bar")
                if b:FindFirstChild("fish") and b:FindFirstChild("playerbar") then
                    b:FindFirstChild("playerbar").Position = b:FindFirstChild("fish").Position
                end
            end
        
            ui = Client.PlayerGui:FindFirstChild("reel") 
            if not (ui) then ui = false end
        until not ui
        
        print("Finished!")
    elseif Config.ReelType == "Legit" then

        repeat
            task.wait()
            if ui:FindFirstChild("bar") then
                local b = ui:FindFirstChild("bar")
                if b:FindFirstChild("fish") and b:FindFirstChild("playerbar") then
                    b:FindFirstChild("playerbar").Position = b:FindFirstChild("fish").Position
                    local x = TweenService:Create(b:FindFirstChild("playerbar"),
                                TweenInfo.new(1, Enum.EasingStyle.Elastic), {Position = b:FindFirstChild("fish").Position})
                    x:Play()
                    x.Completed:Wait()
                end
            end
        
            ui = Client.PlayerGui:FindFirstChild("reel") 
            if not (ui) then ui = false end
        until not ui
        
        print("Finished!")

    elseif Config.ReelType == "Instant" then
        task.wait(2)
        repeat
            task.wait()
            if ui:FindFirstChild("bar") then
                local b = ui:FindFirstChild("bar")
                if b:FindFirstChild("fish") and b:FindFirstChild("playerbar") then
                    b:FindFirstChild("playerbar").Position = b:FindFirstChild("fish").Position
                end

                game.ReplicatedStorage.events["reelfinished "]:FireServer(100, math.random(1, 2) == 1)
            end
            ui = Client.PlayerGui:FindFirstChild("reel") 
            if not (ui) then ui = false end
        until not ui 

    elseif Config.ReelType == "Legit Instant" then
        task.wait(2)
        repeat
            task.wait()
            if ui:FindFirstChild("bar") then
                local b = ui:FindFirstChild("bar")
                if b:FindFirstChild("fish") and b:FindFirstChild("playerbar") then
                    b:FindFirstChild("playerbar").Position = b:FindFirstChild("fish").Position
                end
    
                if b:FindFirstChild("progress") then
                    if b:FindFirstChild("progress").bar.Size.X.Scale > .5 then
                        game.ReplicatedStorage.events["reelfinished "]:FireServer(100, math.random(1, 2) == 1)
                    end
                end
            end
            ui = Client.PlayerGui:FindFirstChild("reel") 
            if not (ui) then ui = false end
        until not ui 
    end

    return;

end

local CpH = 0
local XpH = 0
local FpH = 0
local lXpH = 0
local lCpH = 0

local lastWebhook = os.time()

game.ReplicatedStorage.playerstats:FindFirstChild(Client.Name).Stats.coins.Changed:Connect(function(v)
    CpH += v - lCpH
end)

game.ReplicatedStorage.playerstats:FindFirstChild(Client.Name).Stats.xp.Changed:Connect(function(v)
    XpH += v - lXpH
end)

game.ReplicatedStorage.playerstats:FindFirstChild(Client.Name).Inventory.ChildAdded:Connect(function(newItem)
    FpH += 1

    if (Config.UseWebhook) then
        local s,e = pcall(function()

            local _multi = 3600 / (os.time() - lastWebhook)

            CpH *= _multi
            XpH *= _multi
            FpH *= _multi

            lastWebhook = os.time()

            local Mutation = newItem:FindFirstChild("Mutation")
            if Mutation == nil then Mutation = "NULL" else Mutation = Mutation.Value end
            request({
                Url = Config.WebhookURL,
                Method = "Post",
                Headers = {
                    ['content-type'] = "application/json",
                },
                Body = game:GetService("HttpService"):JSONEncode({
                    ['embeds'] = {{
                        ['title'] = "__**FEMSENSE AUTO FISHER**__",
                        ['description'] = "You have caught a fish...",
                        ['type'] = "rich",
                        ['color'] = tonumber(0xffffff),
                        ['fields'] = {
                            {
                                ["name"] = "You caught a "..newItem.Value,
                                ["value"] = "Wighet: "..newItem:WaitForChild("Weight").Value.."KG \nMutation: "..Mutation
                            },
                            {
                                ["name"] = Client.Name.." Stats",
                                ["value"] = "C$: "..Client.leaderstats['C$'].Value.."\nLevel: "..Client.leaderstats['Level'].Value
                            },
                            {
                                ["name"] = Client.Name.." Performance",
                                ["value"] = "C$/h: "..CpH.."\nXP/h: "..XpH.."\nLevels/h: "..(XpH / 10000).."\nFishes/h: "..FpH
                            },
                        },
                        ['footer'] = {
                            ['text'] = "Eta is best femboy ^^"
                        }
                    }}
                })
            })

            lXpH = XpH / _multi
            lCpH = CpH / _multi

            CpH = 0
            XpH = 0
            FpH = 0
        end)
        if e then
            warn(e)
        end
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then
        return
    end

    if input.KeyCode == Enum.KeyCode.Delete or input.KeyCode == Enum.KeyCode.RightAlt then
        if enabled then
            Window:Hide()
            enabled = false
        else
            Window:Show()
            enabled = true
        end
    end
end)

while task.wait(2) do
    autofarmLoop()
end
