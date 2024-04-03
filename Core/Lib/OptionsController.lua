--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace
local ns = select(2, ...)
local GC, MSG = ns.GC, ns.GC.M
--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
local libName = ns.M.OptionsController
--- @class OptionsController : AceEvent
local S = ns:NewLibWithEvent(libName)
local p = ns:CreateDefaultLogger(libName)


--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
--- @param o OptionsController
local function PropsAndMethods(o)

    ---@param msg string The message name
    ---@param source string The libName that triggered the call
    ---@param profileName string
    function o.OnSwitchProfile(msg, source, profileName)
        assert(profileName, "Profile Name is missing.")
        p:f3(function() return "Received: %s from %s", msg, source end )
        ns:db():SetProfile(profileName)
        ns:a():CloseConfig()
        o:SendMessage(MSG.OnAddOnStateChanged, libName)
    end

    function o.OnAddOnReady() o:RegisterMessage(GC.M.OnSwitchProfile, o.OnSwitchProfile) end

    o:RegisterMessage(MSG.OnAddOnReady, o.OnAddOnReady)
end; PropsAndMethods(S)

