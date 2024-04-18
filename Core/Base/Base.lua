--- @type string
local addon
--- @type BaseNamespace
local kns
addon, kns = ...

--[[-----------------------------------------------------------------------------
Type: DebugSettingsFlag
-------------------------------------------------------------------------------]]
--- @class DebugSettingsFlag
--- @see GlobalDeveloper
local flag = {
    --- Enable developer mode: logging and debug tab settings
    developer = false,
}

--- @return DebugSettings
local function debug()
    --- @class DebugSettings
    local o = {
        flag = flag,
    }
    function o:IsDeveloper() return self.flag.developer == true  end
    return o;
end

kns.debug = debug()
