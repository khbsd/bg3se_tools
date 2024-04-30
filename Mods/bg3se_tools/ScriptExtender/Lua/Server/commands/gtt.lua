gtt_func = 
{
    name = "gtt",  -- [g]enerate [t]reasure [t]able
    params = "treasureTable, target, level, generateInBag",
    func = function(cmd, treasureTable, target, level, generateInBag)
        --[[ 
            RegisterCommands parses every argument as a string when passed 
            through the console, so most of this is converting arguments back 
            to the type they're supposed to be.
        --]]
        if string.lower(generateInBag) == "false" then
            generateInBag = false
        elseif string.lower(generateInBag) == "true" then
            generateInBag = true
        else
            generateInBag = true
        end
        --_IDP("generateInBag: " .. tostring(generateInBag))

        local bag = generateInBag ~= false and Osi.CreateAt("3e6aac21-333b-4812-a554-376c2d157ba9", 0, 0, 0, 0, 0, "")
        --_IDP("bag: " .. tostring(bag))
        local level = tonumber(level)

        if string.lower(target) == "host" then
            target = Osi.GetHostCharacter()
        else
            target = target
        end
        --_IDP("target: " .. target)

        if level == nil then
            if Osi.IsItem(target) == 1 then
                level = -1
            else
                level = Osi.GetLevel(target)
            end
        end
        --_IDP("level: " .. level)

        -- this variable sucks and i do not care about it.
        if Osi.IsItem(target) == 1 then
            finder = Osi.GetHostCharacter()
        else
            finder = target
        end
        --_IDP("finder: " .. finder)

        --[[ 
            if bag is set to "true", generate items into a bag and send that bag
            to the player specified in target. otherwise, generate those items into 
            target's inventory directly.
        --]]
        if bag then
            _IDP("Sending " .. treasureTable .. " in a bag to " .. target)
            Osi.GenerateTreasure(bag, treasureTable, level, finder)
            Osi.ToInventory(bag, target)
        else
            _IDP("Sending " .. treasureTable .. " to " .. target)
            Osi.GenerateTreasure(target, treasureTable, level, finder)
        end
    end
}