Ext.Require("Server/khblib/khblib.lua")
Ext.Require("Server/commands/shcs.lua")
Ext.Require("Server/commands/gtt.lua")
Ext.Require("Server/commands/xp.lua")
Ext.Require("Server/commands/rsc.lua")


--[[
    later you can make this a table that finds commands in the commands/ directory.

    this table has one element, though it is extensible in case we need to add more
    commands later. 
    new commands need to add another {} block, and separate each command {} block with
    a comma. ostensibly they'll need name, params, and func as variables too. params 
    appears to be a reference for when you write the func variable.

    /// 
    IMPORTANT! when listing your params in func = function(params), the first param
    must be 'cmd'. i believe this is a placeholder for the command itself, as without
    it the variables are out of place.
--]]
local commands = {
    {
        name = gtt_func.name,
        params = gtt_func.params,
        func = gtt_func.func
    },

    {
        name = shcs_func.name,
        params = shcs_func.params,
        func = shcs_func.func
    },

    {
        name = xp_func.name,
        params = xp_func.params,
        func = xp_func.func
    },

    {
        name = rsc_func.name,
        params = rsc_func.params,
        func = rsc_func.func
    }
}


--[[ 
    this takes each element in commands and registers 
    it all at once. pretty cool honestly.
--]]
local function RegisterCommands()
    for _, command in ipairs(commands) do
        _IDP(string.format('Registered command [%s]', command.name))
        Ext.RegisterConsoleCommand(command.name, command.func)
    end
end


RegisterCommands()


_IDP("bg3se_tools loaded.")