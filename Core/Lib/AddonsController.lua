--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace
local ns = select(2, ...)
local O, GC, MSG = ns.O, ns.GC, ns.GC.M
local libName = 'AddonsController'
local EnableAddOn, DisableAddOn = EnableAddOn or C_AddOns.EnableAddOn, DisableAddOn or C_AddOns.DisableAddOn

--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
--- @class AddonsController : AceEvent
local L = ns:NewLib(libName)
local p = ns:CreateDefaultLogger(libName)

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
--- @param o AddonsController
local function PropsAndMethods(o)

    function o:Init() end

    --- @return AddonsController
    function o:New() return ns:K():CreateAndInitFromMixin(o) end

    function o:OnApplyAndRestart()
        p:vv('OnApplyAndRestart called...')
        self:SyncAddOnEnabledState()
        p:vv(function() return "L: %s (%s) %s?",
            ns:GetLogLevel(), type(ns:GetLogLevel()), tostring(ns:GetLogLevel() >= 50)
        end)
        if ns:GetLogLevel() >= 50 then
            p:f3(function()
                return 'LogLevel: %s ReloadUI: No. Set the log level in the debugging tab to less than 50 to ReloadUI', ns:GetLogLevel()
            end)
            return
        end
        ReloadUI()
    end

    function o:SyncAddOnEnabledState()
        local charName = UnitName("player")
        p:d(function() return "CharName=%s", tostring(charName) end)
        --- @table<string,boolean>
        local addons = ns:db().profile.enabledAddons

        local enabled = {}
        local disabled = {}
        O.API:ForEachAddOn(function(addOn)
            local shouldLoad = addons[addOn.name]
            local name = addOn.name
            if name ~= ns.name then
                if shouldLoad and shouldLoad == true then
                    EnableAddOn(name, charName)
                    table.insert(enabled, name)
                else
                    DisableAddOn(name, charName)
                    table.insert(disabled, name)
                end
            end
        end)

        EnableAddOn(ns.name, charName)
        p:f3(function() return "Updating Add-On States:" end)
        p:f3(function() return "%s (this): enabled=true", ns.name end)
        p:f3(function() return "Enabled: %s", pformat(enabled) end)
        p:f3(function() return "Disabled: %s", pformat(disabled) end)
    end

end; PropsAndMethods(L)

