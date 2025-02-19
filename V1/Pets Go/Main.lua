
repeat
    task.wait()
until game:IsLoaded()

local Client = game.Players.LocalPlayer

local enabled = true

local Config = {

    AutoBreakAll = false;
    AntiAfk = false;

    UseWebhook = shared.UseWebhook,
    WebhookURL = shared.Webhook,
}

local _colorText = {
    {0x47f817, 0, 5000},
    {0x17f5f8, 5001, 200000},
    {0xe0f817, 200001, 1000000},
    {0xfa6ff4, 1000001, math.huge}
}

local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

loadstring(game:HttpGet('https://raw.githubusercontent.com/drillygzzly/Roblox-UI-Libs/main/Yun%20V2%20Lib/Yun%20V2%20Lib%20Source.lua'))()

local Library = initLibrary()
local Window = Library:Load({name = "Femsense Premium", sizeX = 425, sizeY = 512, color = Color3.fromRGB(255, 255, 255)})

local World = Window:Tab("World")
local Misc = Window:Tab("Misc")

local __A = World:Section({name = "Breakables", column = 1})
local __B = World:Section({name = "Misc", column = 1})

__A:Toggle ({
    Name = "Auto Destroy",
    flag = "BreakablesAutoDestroy", 
    callback = function(bool)
        Config.AutoBreakAll = bool
    end
})

__B:Toggle ({
    Name = "Anti AFK",
    flag = "AntiAFK", 
    callback = function(bool)
        Config.AntiAfk = bool
    end
})

local _RollUI = game.Players.LocalPlayer.PlayerGui:WaitForChild("EggOpenAnimation")

Client.Idled:Connect(function(time)
    if Config.AntiAfk then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

_RollUI.ChildAdded:Connect(function(child)
    if child.Name == "Frame" then
        if child:FindFirstChild("texts") then
            task.wait(.3)

            if child then
                if Config.UseWebhook then
                    local Odds = child:FindFirstChild("texts").Chance.Text
                    local Pet = child:FindFirstChild("texts").Title.Text
    
    
                    local NumberOdds = string.split(Odds, " ")
                    local _Second = NumberOdds[3]
    
                    if #string.split(_Second, ",") > 1 then
                        local _x = ""
                        for _,v in pairs(string.split(_Second, ",")) do
                            _x = _x..v
                        end
    
                        _Second = tonumber(_x)
                    end
    
                    local _color = tonumber(0xffffff)
    
                    for _,v in pairs(_colorText) do
                        if _Second > v[2] and _Second < v[3] then
                            _color = tonumber(v[1])
                        end
                    end
    
                    request({
                        Url = Config.WebhookURL,
                        Method = "Post",
                        Headers = {
                            ['content-type'] = "application/json",
                        },
                        Body = game:GetService("HttpService"):JSONEncode({
                            ['content'] = "",
                            ['embeds'] = {{
                                ['title'] = "__**FEMSENSE PETS GO**__",
                                ['description'] = "You rolled a "..Pet,
                                ['type'] = "rich",
                                ['color'] = _color,
                                ['fields'] = {
                                    {
                                        ["name"] = Client.Name,
                                        ["value"] = "Just rolled a "..Pet.." odds "..Odds
                                    },
                                },
                                ['footer'] = {
                                    ['text'] = "Eta is best femboy ^^"
                                }
                            }}
                        })
                    })
                end
            end
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

local function MainLoop()
    
    local s,e = pcall(function()
        
        if Config.AutoBreakAll then
            local Breakables = workspace.__THINGS.Breakables
            for _,v in pairs(Breakables:GetChildren()) do
                local Hitbox = v:FindFirstChild("Hitbox", true)
                if Hitbox then
                    if Hitbox:FindFirstChild("ClickDetector") then
                        Client.Character.HumanoidRootPart.CFrame = Hitbox.CFrame + Vector3.new(0,4,0)

                        local __PETS = workspace.__THINGS.Pets:GetChildren()

                        for _,v2 in pairs(__PETS) do
                            if v2.Name ~= "Highlight" then
                                local args = {
                                    [1] = {
                                        [v2.Name] = tonumber(v.Name)
                                    }
                                }
                                
                                game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Breakables_JoinPetBulk"):FireServer(unpack(args))
                                task.wait(.1)
                            end
                        end
                    end
                end

            end 
        end
    end)

    if e then
        warn(e)
        return
    end
end

while true do
    task.wait()
    MainLoop()
end
