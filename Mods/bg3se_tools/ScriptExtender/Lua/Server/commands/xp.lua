function xpInfo()
    _IDP("Getting experience points information for character " .. _GHC("name") .. "...")
    _IDP("These values are a little funky. I put them here for transparency, but they may not correspond to in-game values.")
        _P("    Experience points since last level up: " .. tostring(_GHC().Experience.CurrentLevelExperience))
        _P("    Experience points to next level: " .. tostring(_GHC().Experience.NextLevelExperience))
        _P("    Total experience points: " .. tostring(_GHC().Experience.TotalExperience))
        _P("    Other experience points field 1: " .. tostring(_GHC().Experience.SomeExperience))
        _P("    Other experience points field 2: " .. tostring(_GHC().Experience.field_28))
end


function addXp(amount)
    amount = tonumber(math.floor(amount))

    _IDP("Adding " .. amount .. " experience point(s) to character " .. _GHC("name") .. ".")
    Osi.AddExplorationExperience(_GHC("uuid"), amount)
    _GHC():Replicate("Experience")
end


xp_func =
{
    name = "xp",  -- e[xp]erience or ex[p]erience [p]oints
    params = "amount",
    func = function(cmd, amount)
        if amount == nil then
            xpInfo()
            return
        
        elseif tonumber(amount) ~= nil then
            addXp(amount)
            return
        
        elseif amount == "-h" then
            _IDP("Wildshaping into help section...")
            _P(xp_func.help_output)

        else
            notRecognizedError(amount, xp_func.name)
        end

    end,

help_output =
[[
    Explanation:
    -----------------------------------------------------------
        This command is used to add or subtract experience
        points from the host character, or display experience
        point information. !!!NOTE: this information does 
        not correspond with the information displayed in-game. 
        It's best to go off of what the game displays instead
        unless you know what this information means.
        
        'xp' stands for e[xp]erience or ex[p]erience [p]oints


    Usage:
    -----------------------------------------------------------
        Acceptable syntax:
            !xp <number>
        
            !xp <subcommand>
        
        Acceptable numbers:
            Any integer, positive or negative. Keep in mind
            that subtracting experience points with negative
            numbers will not de-level your character.
            Use at your own risk.
        
            Decimals will be rounded down.
        
        Acceptable subcommands:
            -h
                Shows this help section.


    Example commands:
    -----------------------------------------------------------
        !xp
            Result:
                Host character's current experience point
                info will be displayed.
                
                !!!NOTE: this information does not correspond
                with the information displayed in-game. It's
                best to go off of what the game displays
                unless you know what this information means.

        !xp 200
            Result: 
                Host character will recieve 200 experience
                points.
        
        !xp -200
            Result:
                Host character will lose 200 experience
                points.
        
        !xp -h
            Result:
                This help section will be displayed.

]]
}