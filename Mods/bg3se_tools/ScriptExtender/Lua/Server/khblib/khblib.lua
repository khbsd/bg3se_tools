-- a little function and var that identifies this mod's console outputs
local ID = "{bg3se_tools} "
function _IDP(message)
    _P(ID .. message)
end


-- displays "not recognized" errors
function notRecognizedError(arg, name)
    _IDP("Argument '" .. arg .. "' not recognized. \nPlease run '!" .. name ..  " -h' for information on how to use this command.")
end


-- shortcut function for GetHostCharacter()
function _GHC(stat)
    if stat == nil then
        return Ext.Entity.Get(Osi.GetHostCharacter())
    end

    if stat == "name" then
        return _GHC().CharacterCreationStats.Name
    end

    if stat == "uuid" then
        return _GHC().Uuid.EntityUuid
    end

    if stat == "class" then
        return _GHC().Classes.Classes[1].ClassUUID
    end

    if stat == "subclass" then
        return _GHC().Classes.Classes[1].SubClassUUID
    end
end