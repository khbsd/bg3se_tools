--[[
    reference array for how CharacterCreationStats stores Ability Scores.
    the first value is null because for some reason, each stat array for
    each character starts with a 0. not sure what it does, but i'm not 
    fucking with it lol
--]]


local Abilities = {
    "null",
    "str",
    "dex",
    "con",
    "int",
    "wis",
    "cha"
}

-- checks for a match between the string passed and the list of stats in Abilities
function abilityCheck(ability)
    for index, stat in ipairs(Abilities) do
        if stat == ability then
            _IDP("Ability " .. stat .. " found.")
            return index
        end
    end

    if ability == "all" then
        return 8
    end

    -- just needs to return 0 quietly
    if ability == "-s" or ability == "-h" or ability == nil then
        return 0
    end

    wrongAbility(ability)
    return 0
end


-- makes sure number passed is within the limits of the game
function abilityLimiter(ability, number)
    -- min stat is 0, so give feedback about why it won't go lower
    if number < -8 then
        _IDP(number .. " is too low; min stat is 0.\nSetting " .. Abilities[ability] .. " to -8 (because we add 8 later on).")
        number = -8

    -- max stat is 30, so give feedback about why it won't go higher
    elseif number > 22 then
        _IDP(number .. " is too high; max stat is 30. \nSetting " .. Abilities[ability] ..  " to 22 (because we add 8 later on).")
        number = 22
    end

    return number
end


-- prints out the acceptable values for the ability param, excluding null.
function abilityPrint()
    local acceptAbilities = {}

    for _, stat in ipairs(Abilities) do
        if stat ~= "null" then
            table.insert(acceptAbilities, stat)
            _P(stat)
        end
    end
    return acceptAbilities
end


function currentAbilities()
    _IDP("Brushing crumbs off of the character sheet...")
    for index, stat in ipairs(Abilities) do
        if stat ~= "null" then
            _P("    " .. Abilities[index] .. ": " .. _GHC().Stats.Abilities[index])
        end
    end
end


function setAllAbilities(number)

    for index, _ in ipairs(Abilities) do
        if index > 1 then
            setAbility(index, number)
        end
    end
end


function setAbility(ability, number)
    -- get the final number that will be shown in the character sheet, not counting bonuses from proficiencies 
    local statTotal = number + 8

    _GHC().CharacterCreationStats.Abilities[ability] = number
    _GHC().Stats.Abilities[ability] = statTotal

    -- sync stats between client and server. this makes them show up without a save/reload.
    replicateStats()

    -- make it clear that the number that shows up will be 8 greater the number submitted
    _IDP("Ability " .. Abilities[ability] .. " set to ".. statTotal .. " (8 + (" .. number .. "))" .. ".")
end


function replicateStats()
    _GHC():Replicate("CharacterCreationStats")
    _GHC():Replicate("Stats")
end


function wrongAbilityScore(number)
    _IDP(tostring(number) .. " is not an acceptable ability score.")
end


function wrongAbility(ability)
    ability = tostring(ability)
    _IDP("Ability " .. tostring(ability) .. " not found.")
    _IDP("Make sure your selected ability is one of the following:")
    abilityPrint()
end


-- handles the -h help command. returns true if help is displayed.
function shcs_Subcommands(arg)
    local argIndex = abilityCheck(arg)
    if arg == "-h" or arg == nil then
        _IDP("Wildshaping into help section...\n")
        _P(shcs_func.help_output)
        return true

    elseif arg == "-s" or arg == "all" then
        currentAbilities()
        return true

    elseif argIndex > 1 and argIndex < 8 then
        _IDP(Abilities[argIndex] .. ": " .. _GHC().Stats.Abilities[argIndex])
        return true
    else
        return false
    end
end


shcs_func = {
    name = "shcs",  -- [s]et [h]ost [c]har [s]tat
    params = "ability, number",
    func = function(cmd, ability, number)
        -- check for subcommands before anything else
        if number == nil then
            if shcs_Subcommands(ability) == false then
            return
        end

        -- make sure something was passed 
        elseif ability ~= nil and number ~= nil then
            ability = abilityCheck(string.lower(ability))

            --[[ 
                lua arrays start at one, so Abilities[0] is nil. we check if the value is above 0, because 0 is
                the "not found" response from abilityCheck()
            --]]
            if ability > 1 then
                if tonumber(number) ~= nil then
                    number = math.floor(tonumber(number))

                    number = abilityLimiter(ability, number)
                    
                    -- this needs to come after the balancing done by abilityLimiter()
                    if ability == 8 then
                        setAllAbilities(number)
                        return
                    end

                    -- use index given from abilityCheck to assign numbers to the correct stats
                    setAbility(ability, number)

                elseif tonumber(number) == nil then
                    wrongAbilityScore(number)
                    return
                end
            end
        else
            notRecognizedError(ability, shcs_func.name)
            return
        end
    end,

-- these are dedented here for formatting reasons
help_output =
[[
    Explanation:
    -----------------------------------------------------------
        This command is used to set character stats.
        Every character stat has a base of 8. The number
        you give this command should be 8 lower than your
        final desired stat.
        
        'shcs' stands for [s]et [h]ost [c]har [s]tat


    Usage:
    -----------------------------------------------------------
        Acceptable syntax:
            !shcs <ability>
        
            !shcs <ability> <number>
        
            !shcs <subcommand>
        
        Acceptable abilities:
            str
            dex
            con
            int
            wis
            cha
        
        Acceptable numbers:
            any integer, as long as it is:
                - greater than or equal to -8, and \n
                - less than or equal to 22
        
            Decimals will be rounded down.
        
        Acceptable subcommands:
            -h
                Shows this help section.
        
            -s
                Shows the host character's current stats.


    Example commands:
    -----------------------------------------------------------
        !shcs cha
            Result:
                Host character's current cha score will be 
                displayed.

        !shcs int 3
            Result: 
                Host character int score set to 11 (8 + 3).
        
        !shcs -h
            Result:
                This help section will be displayed.
        
        !shcs -s
            Result:
                The host character's stats will be displayed.
]]
}