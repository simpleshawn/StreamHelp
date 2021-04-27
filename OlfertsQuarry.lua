-- VALUES TO CHANGE --

_G.start = true -- true or false to toggle
cooldown = 1 -- Seconds of cooldown between each event (lower cooldown = higher cpu usage)
amount = 5 -- Amount of times you want to do the event each cooldown time (higher amount = higher cpu usage, too high = risk of crash)

-- SCRIPT --

plrvector = game.Players.LocalPlayer.Character.HumanoidRootPart.Position -- Save player's vector

-- ↓↓ Abusing ModuleScripts content ↓↓ --
for i,v in pairs(getgc(true)) do                          -- Returns every existing thing in the game you can access
    if type(v) == "table" and rawget(v, "MaxDepth") then  -- If the item is a table (a table is a value but a table is a table too) and rawget to avoid metatables
        v.MaxDepth = -2147483648                          -- min int32 value
    end
end

function mine()
    for _,v in pairs(game.Workspace.Ores:GetDescendants()) do                       -- Every children of Ores folder
        if v:IsA"Part" then                                                         -- Check if it's a part (idk if useful)
            distance = (v.Position - plrvector).Magnitude                           -- Magnitude is the sum of every value in a vector (example : Vector3.new(2, 2, 2).Magnitude will be 6)
            if distance < 15 then                                                   -- Mining distance
                game:GetService("ReplicatedStorage").Events.MineOre:InvokeServer(v) -- Event
            end
        end
    end
end
    
while _G.start do               -- Bool value while loop
    wait(cooldown)              -- No need to explain
    for _=1,amount do           -- Amount of time it'll run
        coroutine.wrap(mine)(); -- To make any function run superimposed to other functions
    end
end

--[[
    Ideas to improve your security :
    
  - Make a RemoteFunction to check your level (like you did for the inventory, i'm going to check if something exploitable is possible)
    Make a RemoteEvent to take server information (example take MaxDepth for your level from server)
    So like at every depth stage (example -1; -2; -3) the server simply takes the level from the player then gives the MaxDepth and the main LocalScript from the Pickaxe says if you're able to mine or not (simply visual)
    (You could maybe add a function to calculate the depth of blocks under you and say if you're able to mine it but seems like you done something like this)
    But then you stock the information in ServerSide and keep if for InvokeServer when the player tries to mine the ore to say if he's able or not
    
  - The other idea was the one I said on stream, oh and make sure to make a RemoteFunction to check your pickaxe and like if you want it to be like cheatless but rude, you can do :
    In the script to check the mining's state, precisely in the coroutine.wrap() I said you could use you could like via a RemoteEvent gather the information of the mining progress (so make a function defining it)
    
    That's pretty much it, good day!
  ]]
