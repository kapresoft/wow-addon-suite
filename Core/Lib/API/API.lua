--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace
local ns = select(2, ...)
local M, LibStub = ns.M, ns.LibStub
local IsAnyOf = ns:KO().String.IsAnyOf

--[[-----------------------------------------------------------------------------
Blizzard Vars
-------------------------------------------------------------------------------]]
local GetNumAddOns = GetNumAddOns or C_AddOns.GetNumAddOns
local GetAddOnInfo = GetAddOnInfo or C_AddOns.GetAddOnInfo
--- We don't want to use the old global GetAddOnEnableState() because it doesn't work
local C_AddOns_GetAddOnEnableState = C_AddOns.GetAddOnEnableState

--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
--- @return API, Kapresoft_CategoryLogger
local function CreateLib()
    local libName = M.API or 'API'
    --- @class API : BaseLibraryObject
    local newLib = LibStub:NewLibrary(libName); if not newLib then return nil end
    local logger = ns:LC().API:NewLogger(libName)
    return newLib, logger
end; local L, p = CreateLib(); if not L then return end

-- Add to Modules.lua
--API = 'API',
--
----- @type API
--API = {},

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
--- @param o API
local function PropsAndMethods(o)

    function o:GetUIScale()
        local useUiScale = GetCVar("useUiScale") -- This returns "1" if UI scaling is enabled, "0" otherwise.
        if useUiScale == "1" then
            local uiScale = GetCVar("uiScale") -- Get the UI scale setting.
            return tonumber(uiScale) -- Convert to number for calculations.
        else
            return 1 -- UI scaling is not enabled, so scale is effectively 1.
        end
    end

    function o:GetCurrentPlayer()
        return UnitName("player")
    end

    function o:GetEnabledAddOns() return ns:profile().enabledAddons end

    --- @param indexOrName IndexOrName The index from 1 to GetNumAddOns() or The name of the addon (as in TOC/folder filename), case insensitive.
    function o:GetAddOnInfo(indexOrName)
        assert(indexOrName, "The index parameter is required.")
        local name, title, notes, loadable, reason, security = GetAddOnInfo(indexOrName)
        --- @type AddOnInfo
        local info = {
            name = name, title = title, loadable = loadable, notes = notes,
            reason = reason, security = security,

        }
        info.loadOnDemand = info.reason == 'DEMAND_LOADED'
        info.enabled = self:IsAddOnEnabled(info.name, loadable)

        function info:IsNotLoadOnDemand() return self.loadOnDemand ~= true end
        function info:CanBeEnabled() return self.loadOnDemand ~= true and self.enabled ~= true end

        return info
    end

    --- @private
    --- @param indexOrName IndexOrName
    --- @return Enabled
    --- @param loadable boolean
    function o:IsAddOnEnabled(indexOrName, loadable)
        if C_AddOns_GetAddOnEnableState then
            local charName = self:GetCurrentPlayer()
            local intVal = C_AddOns_GetAddOnEnableState(indexOrName, charName)
            p:f3(function() return 'AddOn[%s] is enabled: %s', indexOrName, tostring(intVal == 2) end)
            return intVal == 2
        end
        local enabled = loadable == true
        p:f3(function() return 'WOTLK addon[%s] is enabled: %s',
        tostring(indexOrName), tostring(enabled) end)
        return enabled
    end

    --- @param indexOrName IndexOrName
    --- @return Enabled
    function o:IsAddOnDisabled(indexOrName) return self:IsAddOnEnabled(indexOrName) ~= true end

    --- @param callbackFn AddOnCallbackFn
    function o:ForEachAddOn(callbackFn)
        return self:ForAllAddOns(callbackFn, function(info)
            return IsAnyOf(info.name, ns.name) ~= true
        end)
    end

    --- @param callbackFn AddOnCallbackFn
    --- @param predicateFn fun(info:AddOnInfo) | "function(info) return true end" | "A function that returns true to accept the element"
    function o:ForAllAddOns(callbackFn, predicateFn)
        local addOnCount = GetNumAddOns()
        if addOnCount <= 0 then return end

        for i = 1, addOnCount do
            local info = self:GetAddOnInfo(i)
            if predicateFn and predicateFn(info) then callbackFn(info) end
        end
    end

    --- @param callbackFn fun(info:AddOnInfo) | "function(info) end"
    function o:ForEachCheckedAndLoadableAddon(callbackFn)
        local addons = self:GetEnabledAddOns()
        if not addons then return end
        for name, checked in pairs(addons) do
            if checked == true then
                local info = self:GetAddOnInfo(name)
                if info:CanBeEnabled() then callbackFn(info) end
            end
        end
    end

    --- @param callbackFn fun(info:AddOnInfo) | "function(info) end"
    function o:ForEachAddOnThatCanBeDisabled(callbackFn)
        local addons = self:GetEnabledAddOns()
        if not addons then return end

        local addOnCount = GetNumAddOns()
        if addOnCount <= 0 then return end

        for i = 1, addOnCount do
            local info = self:GetAddOnInfo(i)
            local checked = addons[info.name] == true
            local validCandidate = ns.name ~= info.name and checked ~= true
                    and info:IsNotLoadOnDemand() and info.enabled == true
            if validCandidate == true then callbackFn(info) end
        end
    end

end; PropsAndMethods(L)

