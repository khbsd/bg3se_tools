paladin = "ff4d9497-023c-434a-bd14-82fc367e991c"
oathbreaker_paladin = "6fb3831e-45d8-4b30-9714-6fe73988921b"


rsc_func =
{
    name = "rsc",  -- [r]e[s]pec [c]haracter
    params = "type",
    func = function(cmd, type)
        if type == nil then
            _IDP("Respeccing character " .. _GHC("name") .. ". Click the [Level Up] button when you're ready to respec.")
            Osi.RequestRespec(_GHC("uuid"))
            return

        elseif type == "-h" then
            _IDP("Wildshaping into help section...")
            _P(rsc_func.help_output)
            return

        elseif type == '-s' then
            _IDP("Respeccing character " .. _GHC("name") .. " immediately.")
            Osi.StartRespec(_GHC("uuid"))
            return

        elseif type == '-o' then
            if _GHC("class") == paladin then
                if _GHC("subclass") == oathbreaker_paladin then
                    _IDP("Restoring oath of " .. _GHC("name") .. "...")
                    Osi.StartRespecRestore(_GHC("uuid"))

                else
                    _IDP("Breaking oath of " .. _GHC("name") .. "...")
                    Osi.StartRespecToOathbreaker(_GHC("uuid"))
                end
                return

            else
                _IDP(_GHC("name") .. "is not a Paladin.")
            end
            return

        else
            notRecognizedError(type, rsc_func.name)
        end
    end,

help_output =
[[
    Explanation:
    -----------------------------------------------------------
        This command is used to respec your character,
        similar to how Withers respecs your characters for 
        a "pittance." It can also be used to break your
        Paladin Oath, and restore it.
        
        'rsc' stands for [r]e[s]pec [c]haracter


    Usage:
    -----------------------------------------------------------
        Acceptable syntax:
            !rsc
        
            !rsc <subcommand>
        
        Acceptable subcommands:
            <none>
                Respecs your character quietly- respec screen
                will be available on clicking the [Level Up]
                button under your character portrait.

            -s
                Respecs your character and starts the respec
                screen, similar to Character Creation.
            
            -o
                If your character is not an Oathbreaker
                Paladin, will break your Paladin's Oath and
                start the Oathbreaker respec screen. 

                If your character is an Oathbreaker Paladin,
                will restore your Paladin's Oath and start
                the Restore Oath respec screen.

            -h
                Shows this help section.


    Example commands:
    -----------------------------------------------------------
        !rsc
            Result:
                Respec screen will be displayed upon clicking
                the [Level Up] button.

        !rsc -s
            Result: 
                Respec screen will be displayed immediately.
        
        !rsc -o (while your character is an Oathbreaker 
        Paladin)
            Result:
                Paladin's Oath will be restored, and the 
                Restore Oath respec screen will be displayed.

        !rsc -o (while your character is not an Oathbreaker 
        Paladin)
            Result:
                Paladin's Oath will be broken, and the 
                Oathbreaker respec screen will be displayed.
        
        !rsc -h
            Result:
                This help section will be displayed.

]]
}