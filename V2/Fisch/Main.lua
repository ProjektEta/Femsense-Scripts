


repeat
    wait()
until game:IsLoaded()

local ___stick = tick()

local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local VIM = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")

local WorldFolder = workspace:WaitForChild("world")
local ActiveFolder = workspace:WaitForChild('active')
local LocalPlayerPawn = Players.LocalPlayer

if WorldFolder == nil then
    LocalPlayerPawn:Kick("[FEMSENSE] Sorry but couldn't find world folder, Did Fisch have an update?")

    return
end

if ActiveFolder == nil then
    LocalPlayerPawn:Kick("[FEMSENSE] Sorry but couldn't find active folder, Did Fisch have an update?")
    return
end

local TpFolder = WorldFolder:WaitForChild("spawns"):WaitForChild("TpSpots") 
local NpcFolder = WorldFolder:WaitForChild("npcs")

local tp_locations = loadstring(game:HttpGet("https://raw.githubusercontent.com/ProjektEta/Femsense-Beta/refs/heads/main/Scripts/tools/Fisch/tplocations.lua"))()
local worldevents = loadstring(game:HttpGet("https://raw.githubusercontent.com/ProjektEta/Femsense-Beta/refs/heads/main/Scripts/tools/Fisch/worldevents.lua"))()

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/i77lhm/vaderpaste/refs/heads/main/library.lua"))() 
local pointers = library.flags 

library:notification({text = "Femsense is loading..."})

local window = library:window({
    name = "FemsenseV2 Beta",
    size = UDim2.fromOffset(500, 500)
})


local automatic = window:tab({name = "automatic"})
local client = window:tab({name = "Client"})
local world = window:tab({name = "world"})
local visuals = window:tab({name = "visuals wip"})
local misc = window:tab({name = "misc"})

do
    local _autofish = automatic:section({name = "Auto Farm", side = "left"})

    _autofish:toggle({name = "Enable Auto Fish", flag = "autofishEnable", default = false, tooltip = "Start the Auto farm."})
    _autofish:toggle({name = "Enable Auto Sell", flag = "autoSell", default = false, tooltip = "Sell everything every auto farm cycle"})

    --_autofish:toggle({name = "Freeze Character", flag = "freezeCharacter", default = false, tooltip = "Freeze the character to a position every auto farm cycle."})
    _autofish:dropdown({name = "Auto Shake Type", flag = "autoShake", items = {"GuiService"}, multi = false, tooltip = "How should Femsense do the Shake Minigame?"})
    _autofish:dropdown({name = "Auto Reel Type", flag = "autoReel", items = {"Always Perfect", "Legit", "Instant", "Legit Instant"}, multi = false, tooltip = "How should Femsense do the Reel Minigame?"})    

    local _autofishsettings = automatic:section({name = "Auto Farm Settings", side = "right"})

    _autofishsettings:slider({
        name = "Auto Cast Delay", 
        suffix = "s", 
        flag = "autocastdelay", 
        default = 2, 
        min = 0, 
        max = 5, 
        interval = 0.5
    })

    _autofishsettings:slider({
        name = "Auto Shake Delay", 
        suffix = "ms", 
        flag = "autoshakedelay", 
        default = 500, 
        min = 0, 
        max = 1000, 
        interval = 0.5
    })

    _autofishsettings:slider({
        name = "Instant Reel Delay", 
        suffix = "s", 
        flag = "autoreeldelay", 
        default = 2, 
        min = 0, 
        max = 5, 
        interval = 0.5
    })

    
    _autofishsettings:slider({
        name = "Instant Reel Perfect Chance", 
        suffix = "%", 
        flag = "autoreelchance", 
        default = 50, 
        min = 0, 
        max = 100, 
        interval = 0.5
    })
    
end

do
    local Modifiers = client:section({name = "Modifiers", side = "left"})

    local __freezeCFrame = CFrame.new(0,0,0)
    local __freezeConn = nil
    Modifiers:toggle({name = "Freeze Character", flag = "freezeCharacter", default = false, tooltip = "Freeze the character to a position every auto farm cycle.", callback = function(v)
        __freezeCFrame = LocalPlayerPawn.Character.HumanoidRootPart.CFrame

        if v == true then
            __freezeConn = game:GetService("RunService").RenderStepped:Connect(function()
                LocalPlayerPawn.Character.HumanoidRootPart.CFrame = __freezeCFrame
            end)
        else
            if __freezeConn then
                __freezeConn:Disconnect()
            end
        end
    end})

    local CharAntiDrownCon = nil
    Modifiers:toggle({name = "Inf Oxygen", flag = "InfOxygen", default = false, tooltip = "Gives you inf oxygen", callback = function(v)
        local s,e = pcall(function()
            if v == true then
                if LocalPlayerPawn.Character ~= nil and LocalPlayerPawn.Character:WaitForChild("oxygen") ~= nil and LocalPlayerPawn.Character:WaitForChild("oxygen").Enabled == true then	
                    LocalPlayerPawn.Character.oxygen.Enabled = false	
                end	
                if LocalPlayerPawn.Character ~= nil and LocalPlayerPawn.Character:WaitForChild("oxygen(peaks)") ~= nil and LocalPlayerPawn.Character:WaitForChild("oxygen(peaks)").Enabled == true and pointers["InfOxygen"] == true then	
                    LocalPlayerPawn.Character["oxygen(peaks)"].Enabled = false	
                end	
                CharAntiDrownCon = LocalPlayerPawn.Character.CharacterAdded:Connect(function()	
                    if LocalPlayerPawn.Character ~= nil and LocalPlayerPawn.Character:WaitForChild("oxygen") ~= nil and LocalPlayerPawn.Character:WaitForChild("oxygen").Enabled == true and pointers["InfOxygen"] == true then	
                        LocalPlayerPawn.Character.oxygen.Enabled = false	
                    end	

                    if LocalPlayerPawn.Character ~= nil and LocalPlayerPawn.Character:WaitForChild("oxygen(peaks)") ~= nil and LocalPlayerPawn.Character:WaitForChild("oxygen(peaks)").Enabled == true and pointers["InfOxygen"] == true then	
                        LocalPlayerPawn.Character["oxygen(peaks)"].Enabled = false	
                    end	
                end)
            else	
                if LocalPlayerPawn.Character ~= nil and LocalPlayerPawn.Character:WaitForChild("oxygen") ~= nil and LocalPlayerPawn.Character:WaitForChild("oxygen").Enabled == false then	
                    LocalPlayerPawn.Character.client.oxygen.Enabled = true	
                end	
                if LocalPlayerPawn.Character ~= nil and LocalPlayerPawn.Character:WaitForChild("oxygen(peaks)") ~= nil and LocalPlayerPawn.Character:WaitForChild("oxygen(peaks)").Enabled == true and pointers["InfOxygen"] == true then	
                    LocalPlayerPawn.Character["oxygen(peaks)"].Enabled = true	
                end	
    
                if CharAntiDrownCon then
                    CharAntiDrownCon:Disconnect()
                end
            end 
        end)
    end})

    local AntiTempCharConn = nil
    Modifiers:toggle({name = "No Tempeture", flag = "NoTemp", default = false, tooltip = "Gives you No heat/cold", callback = function(v)
        local s,e = pcall(function()
            if v == true then
                if LocalPlayerPawn.Character ~= nil and LocalPlayerPawn.Character:WaitForChild("temperature") ~= nil and LocalPlayerPawn.Character:WaitForChild("temperature").Enabled == true then	
                    LocalPlayerPawn.Character.temperature.Enabled = false	
                end	
                if LocalPlayerPawn.Character ~= nil and LocalPlayerPawn.Character:WaitForChild("temperature(heat)") ~= nil and LocalPlayerPawn.Character:WaitForChild("temperature(heat)").Enabled == true and pointers["NoTemp"] == true then	
                    LocalPlayerPawn.Character["temperature(heat)"].Enabled = false	
                end	
                AntiTempCharConn = LocalPlayerPawn.Character.CharacterAdded:Connect(function()	
                    if LocalPlayerPawn.Character ~= nil and LocalPlayerPawn.Character:WaitForChild("temperature") ~= nil and LocalPlayerPawn.Character:WaitForChild("temperature").Enabled == true and pointers["NoTemp"] == true then	
                        LocalPlayerPawn.Character.temperature.Enabled = false	
                    end	

                    if LocalPlayerPawn.Character ~= nil and LocalPlayerPawn.Character:WaitForChild("temperature(heat)") ~= nil and LocalPlayerPawn.Character:WaitForChild("temperature(heat)").Enabled == true and pointers["NoTemp"] == true then	
                        LocalPlayerPawn.Character["temperature(heat)"].Enabled = false	
                    end	
                end)
            else	
                if LocalPlayerPawn.Character ~= nil and LocalPlayerPawn.Character:WaitForChild("temperature") ~= nil and LocalPlayerPawn.Character:WaitForChild("temperature").Enabled == false then	
                    LocalPlayerPawn.Character.client.temperature.Enabled = true	
                end	
                if LocalPlayerPawn.Character ~= nil and LocalPlayerPawn.Character:WaitForChild("oxygen(peaks)") ~= nil and LocalPlayerPawn.Character:WaitForChild("temperature(heat)").Enabled == false then	
                    LocalPlayerPawn.Character["temperature(heat)"].Enabled = true	
                end	
    
                if AntiTempCharConn then
                    AntiTempCharConn:Disconnect()
                end
            end 
        end)
        if e then

        end
    end})

    local Interactables = client:section({name = "Interactables", side = "right"})

    Interactables:button({name = "Sell Held Fish", callback = function()
        game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("Sell"):InvokeServer()
    end})

    Interactables:button({name = "Sell All Fish", callback = function()
        game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("SellAll"):InvokeServer()
    end})

    Interactables:button({name = "Appraise Held Fish (450)", callback = function()
        local _oldCF = LocalPlayerPawn.Character.HumanoidRootPart.CFrame
        task.wait()
        LocalPlayerPawn.Character.HumanoidRootPart.CFrame = CFrame.new(448.253815, 150.538727, 206.717392, 0.0551895462, -4.95227894e-08, -0.998475909, 3.75087801e-08, 1, -4.75251305e-08, 0.998475909, -3.4828723e-08, 0.0551895462)
        workspace:WaitForChild("world"):WaitForChild("npcs"):WaitForChild("Appraiser"):WaitForChild("appraiser"):WaitForChild("appraise"):InvokeServer()
        task.wait()
        LocalPlayerPawn.Character.HumanoidRootPart.CFrame = _oldCF
    end})

    Interactables:button({name = "Fix Treasure map (250)", callback = function()
        local _oldCF = LocalPlayerPawn.Character.HumanoidRootPart.CFrame
        task.wait()
        LocalPlayerPawn.Character.HumanoidRootPart.CFrame = CFrame.new(-2823.90112, 214.34288, 1515.54041, -0.20666413, -3.82791967e-08, 0.978411973, 5.99187189e-08, 1, 5.17800807e-08, -0.978411973, 6.93262763e-08, -0.20666413)
        workspace:WaitForChild("world"):WaitForChild("npcs"):WaitForChild("Jack Marrow"):WaitForChild("treasure"):WaitForChild("repairmap"):InvokeServer()
        task.wait()
        LocalPlayerPawn.Character.HumanoidRootPart.CFrame = _oldCF
    end})

end

-- worksapce.Megalodon

do
    local Teleports = world:section({name = "Teleports", side = "left"})

    Teleports:button({name = "Teleport to held Treasure map", tooltip="The treasure map needs to be repaired.",callback = function()
        local getTool = LocalPlayerPawn.Character:FindFirstChild("Treasure Map")
        if not getTool then
            library:notification({text = "You need to hold a map!"})
            return
        end

        if getTool.link.Value.Repaired.Value == false then
            library:notification({text = "Map needs to be repaired!"})
            return
        end

        LocalPlayerPawn.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(getTool.link.Value.x.Value, getTool.link.Value.y.Value, getTool.link.Value.z.Value))
    end})

    local _tps = {}

    for i,v in pairs(tp_locations) do
        table.insert(_tps, i)
    end

    Teleports:dropdown({name = "Teleport", flag = "teleportArea", items = _tps, default="Moosewood", multi = false, tooltip = "Where to teleport you to?", callback = function(v)
        LocalPlayerPawn.Character.HumanoidRootPart.CFrame = TpFolder[tp_locations[v]].CFrame + Vector3.new(0,4,0)
    end})   
    
    local ___tFolder1 = {}
    local ___tFolder2 = {}
    
    local worldEvents = Teleports:dropdown({name = "World Events", flag = "worldEvents", items = {}, multi = false, tooltip = "Where to teleport you to?", callback = function(v)
        if v == nil then return end
        library:panel({
            name = "Are you in your boat? (You wont be tp'd otherwise)",
            options = {"Yes", "No"},
            callback = function(option)
                if option == "Yes" then     
                    ActiveFolder.boats:FindFirstChild(LocalPlayerPawn.Name):GetChildren()[1].PrimaryPart.CFrame = ___tFolder1[v].CFrame + Vector3.new(0,4,0)
                end 
            end
        })
    end})    

    ActiveFolder.ChildAdded:Connect(function(c)
        if worldevents[c.Name] then
            ___tFolder1[c.Name..tostring(os.time())] = c

            table.insert(___tFolder2, c.Name..tostring(os.time()))
            worldEvents:refresh_options(___tFolder2)
        end
    end)

    for _,c in pairs(ActiveFolder:GetChildren()) do
        if worldevents[c.Name] then
            ___tFolder1[c.Name..tostring(os.time())] = c

            table.insert(___tFolder2, c.Name..tostring(os.time()))
        end
    end
    worldEvents:refresh_options(___tFolder2)

end

do
    
    local ImportantButtons = misc:section({name = "Important Buttons", side = "left"})
    ImportantButtons:button({name = "Join our discord!",callback = function()
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
    end})

    local WebhookSettings = misc:section({name = "Webhook Settings", side = "left"})
    WebhookSettings:textbox({flag = "webhookURL"})
    WebhookSettings:toggle({name = "Use Webhooks", flag = "usewebhooks", default = false, tooltip = "Should Femsense use a webhook?"})

    local UICOnfig = misc:section({name = "UI Config", side = "left"})
    UICOnfig:toggle({name = "Watermark", flag = "watermark", default = false, callback = function(bool)
        window.toggle_watermark(bool)
    end})
    UICOnfig:keybind({name = "UI Bind", default = Enum.KeyCode.End, callback = window.set_menu_visibility})
    UICOnfig:colorpicker({name = "UI Accent", color = Color3.fromHex("#6464FF"), flag = "accent", callback = function(color)
        library:update_theme("accent", color)
    end})

    local AccountInfo = misc:section({name = "Account Info", side = "right"})
    AccountInfo:button({
        name = "Key Time Length",
        callback = function()
            library:panel({
                name = "You have... "..SecondsToDays(tonumber(__loginInfo.TimeLength)).." Days left",
                options = {"Continue"},
            })
        end
    })
end

library:notification({text = "Loaded! "..math.floor(tick() - ___stick).."s"})

automatic.open_tab()
window.toggle_playerlist(false)
window.toggle_list(false)

local function mainLoop()
    
    game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("afk"):FireServer(false)
    
    if pointers["autofishEnable"] == false then return end

    if pointers["autoSell"] == true then
        game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("SellAll"):InvokeServer()
    end

    local s,e = pcall(function()
        
        local event;

        for _,v in pairs(LocalPlayerPawn.Character:GetChildren()) do
            if v:IsA("Tool") then event = v end
        end
    
        event.events.cast:FireServer(100, 1)
    end)
    if e then
        library:notification({text = "You need to have a rod equipped"})
        return
    end

    local ui = LocalPlayerPawn.PlayerGui:FindFirstChild("shakeui")
    repeat
        ui = LocalPlayerPawn.PlayerGui:FindFirstChild("shakeui")
        task.wait()
    until ui

    repeat
        if ui:FindFirstChild("safezone") then
            if ui.safezone:FindFirstChild("button") then
                pcall(function()
                    if pointers["autoShake"] == "GuiService" then
                        GuiService.SelectedObject = ui.safezone:FindFirstChild("button")
                        if GuiService.SelectedObject == ui.safezone:FindFirstChild("button") then
                            VIM:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                            VIM:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                        end
                    end
                end)
            end
        end
        task.wait(pointers["autoshakedelay"] / 1000)
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

    if pointers["autoReel"] == "Always Perfect" then
        repeat
            task.wait()
            if ui:FindFirstChild("bar") then
                local b = ui:FindFirstChild("bar")
                if b:FindFirstChild("fish") and b:FindFirstChild("playerbar") then
                    b:FindFirstChild("playerbar").Position = b:FindFirstChild("fish").Position
                end
            end
        
            ui = LocalPlayerPawn.PlayerGui:FindFirstChild("reel") 
            if not (ui) then ui = false end
        until not ui
        
        print("Finished!")
    elseif pointers["autoReel"]  == "Legit" then

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
        
            ui = LocalPlayerPawn.PlayerGui:FindFirstChild("reel") 
            if not (ui) then ui = false end
        until not ui
        
        print("Finished!")

    elseif pointers["autoReel"]  == "Instant" then
        task.wait(pointers["autoreeldelay"])
        repeat
            task.wait()
            if ui:FindFirstChild("bar") then
                local b = ui:FindFirstChild("bar")
                if b:FindFirstChild("fish") and b:FindFirstChild("playerbar") then
                    b:FindFirstChild("playerbar").Position = b:FindFirstChild("fish").Position
                end

                local isPerfect = math.random(1, 100) < pointers["autoreelchance"]
                game.ReplicatedStorage.events["reelfinished "]:FireServer(100, isPerfect)
            end
            ui = LocalPlayerPawn.PlayerGui:FindFirstChild("reel") 
            if not (ui) then ui = false end
        until not ui 

    elseif pointers["autoReel"]  == "Legit Instant" then
        task.wait(pointers["autoreeldelay"])
        repeat
            task.wait()
            if ui:FindFirstChild("bar") then
                local b = ui:FindFirstChild("bar")
                if b:FindFirstChild("fish") and b:FindFirstChild("playerbar") then
                    b:FindFirstChild("playerbar").Position = b:FindFirstChild("fish").Position
                end
    
                if b:FindFirstChild("progress") then
                    if b:FindFirstChild("progress").bar.Size.X.Scale > .5 then
                        local isPerfect = math.random(1, 100) < pointers["autoreelchance"]
                        game.ReplicatedStorage.events["reelfinished "]:FireServer(100, isPerfect)
                    end
                end
            end
            ui = LocalPlayerPawn.PlayerGui:FindFirstChild("reel") 
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


game.ReplicatedStorage.playerstats:FindFirstChild(LocalPlayerPawn.Name).Stats.coins.Changed:Connect(function(v)
    CpH += v - lCpH
end)

game.ReplicatedStorage.playerstats:FindFirstChild(LocalPlayerPawn.Name).Stats.xp.Changed:Connect(function(v)
    XpH += v - lXpH
end)

game.ReplicatedStorage.playerstats:FindFirstChild(LocalPlayerPawn.Name).Inventory.ChildAdded:Connect(function(newItem)
    FpH += 1

    if (pointers["usewebhooks"]) then
        local s,e = pcall(function()

            local _multi = 3600 / (os.time() - lastWebhook)

            CpH *= _multi
            XpH *= _multi
            FpH *= _multi

            lastWebhook = os.time()

            local Mutation = newItem:FindFirstChild("Mutation")
            if Mutation == nil then Mutation = "NULL" else Mutation = Mutation.Value end
            request({
                Url = pointers["webhookURL"],
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
                                ["name"] = LocalPlayerPawn.Name.." Stats",
                                ["value"] = "C$: "..LocalPlayerPawn.leaderstats['C$'].Value.."\nLevel: "..LocalPlayerPawn.leaderstats['Level'].Value
                            },
                            {
                                ["name"] = LocalPlayerPawn.Name.." Performance",
                                ["value"] = "C$/h: "..CpH.."\nXP/h: "..XpH.."\nLevels/h: "..(XpH / 10000).."\nFishes/h: "..FpH
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


while task.wait(pointers["autocastdelay"]) do
    local s,e = pcall(function()
        mainLoop()
    end)
    if e then
        library:notification({text = "Fatal error: "..e})
    end
end
