--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace
local ns = select(2, ...)
local M, LibStub = ns.M, ns.LibStub
local String = ns:KO().String
local IsAnyOf = String.IsAnyOf
local EqualsIgnoreCase = String.EqualsIgnoreCase

--[[-----------------------------------------------------------------------------
Blizzard Vars
-------------------------------------------------------------------------------]]
local GetNumAddOns = GetNumAddOns or C_AddOns.GetNumAddOns
local GetAddOnInfo = GetAddOnInfo or C_AddOns.GetAddOnInfo
--- We don't want to use the old global GetAddOnEnableState() because it doesn't work
local C_AddOns_GetAddOnEnableState = C_AddOns.GetAddOnEnableState
local EnableAddOn, DisableAddOn = EnableAddOn or C_AddOns.EnableAddOn, DisableAddOn or C_AddOns.DisableAddOn

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

--[[-----------------------------------------------------------------------------
Support Functions
-------------------------------------------------------------------------------]]
--- @class AddOnInfoMixin
local AddOnInfoMixin = {}

--- @param o AddOnInfoMixin
local function AddonInfoPropsAndMethods(o)

    --- @public
    --- @param addOnInfo AddOnInfo
    --- @return AddOnInfoMixin
    function o:New(addOnInfo)
        return ns:K():CreateAndInitFromMixin(o, addOnInfo)
    end

    --- @param addOnInfo AddOnInfo
    --- @private
    function o:Init(addOnInfo)
        assert(addOnInfo, "AddOnInfo is missing.")
        self.addOnInfo = addOnInfo
        self.name = addOnInfo.name
        self.reason = self.addOnInfo.reason or ''
        self.loadOnDemand = EqualsIgnoreCase(self.reason, 'DEMAND_LOADED')
        self.enabled = L:IsAddOnEnabled(self.name, self.addOnInfo.loadable)
        self.missing = EqualsIgnoreCase(self.reason, 'MISSING')
        self.canBeEnabled = L:IsAddOnDisabled(self.addOnInfo.name)
    end

    function o:IsNotLoadOnDemand() return not self.loadOnDemand end
    function o:IsEnabled() return self.enabled end
    function o:CanBeEnabled() return not (self.missing or self.loadOnDemand or self.enabled) end

    --reason = info.reason or ''
    --info.loadOnDemand = EqualsIgnoreCase(reason, 'DEMAND_LOADED')
    --info.missing = info.reason and EqualsIgnoreCase(reason, 'MISSING')
    --info.enabled = self:IsAddOnEnabled(info.name, loadable)
end; AddonInfoPropsAndMethods(AddOnInfoMixin)

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

    function o:GetEnabledAndInstalledAddOns()
        local toRemove = {}
        for name in pairs(ns:profile().enabledAddons) do
            local a = self:GetAddOnInfo(name)
            if a.missing then
                table.insert(toRemove, name)
                --p:vv(function() return 'Missing addon removed: %s', a.name end)
            end
        end
        for _, name in ipairs(toRemove) do
            ns:profile().enabledAddons[name] = nil
        end

    return ns:profile().enabledAddons
end

    function o:GetEnabledAddOns() return self:GetEnabledAndInstalledAddOns() end

    --- @param indexOrName IndexOrName The index from 1 to GetNumAddOns() or The name of the addon (as in TOC/folder filename), case insensitive.
    --- @return AddOnInfoMixin
    function o:GetAddOnInfo(indexOrName)
        assert(indexOrName, "The index parameter is required.")
        local name, title, notes, loadable, reason, security = GetAddOnInfo(indexOrName)
        --- @type AddOnInfo
        local info = {
            name = name, title = title, loadable = loadable, notes = notes,
            reason = reason, security = security,
        }
        return AddOnInfoMixin:New(info)
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
    --- @param predicateFn fun(info:AddOnInfoMixin) | "function(info) return true end" | "A function that returns true to accept the element"
    function o:ForAllAddOns(callbackFn, predicateFn)
        local addOnCount = GetNumAddOns()
        if addOnCount <= 0 then return end

        for i = 1, addOnCount do
            local info = self:GetAddOnInfo(i)
            if predicateFn and predicateFn(info) then callbackFn(info) end
        end
    end

    --- @param callbackFn fun(info:AddOnInfoMixin) | "function(info) end"
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

    --- @param callbackFn fun(info:AddOnInfoMixin) | "function(info) end"
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

    --- @param name Name The addOn name
    function o:EnableAddOnForCharacter(charName, name)
        assert(name, "AddOn name is required.")
        charName = charName or UnitName("player")
        EnableAddOn(name, charName)
        p:d(function() return 'AddOn Enabled: %s', name end)
    end

    --- @param name Name The addOn name
    function o:DisableAddOnForCharacter(charName, name)
        assert(name, "AddOn name is required.")
        charName = charName or UnitName("player")
        DisableAddOn(name, charName)
        p:d(function() return 'AddOn Disabled: %s', name end)
    end

    --- @param addOnNames table<number, Name> The array of addOn names
    function o:EnableAddOnsForCharacter(addOnNames)
        assert(type(addOnNames) == 'table', "AddOn names array are required.")
        if #addOnNames <= 0 then return end
        local charName = UnitName("player")
        for i, name in ipairs(addOnNames) do
            self:EnableAddOnForCharacter(charName, name)
        end
    end

    --- @param addOnNames table<number, Name> The array of addOn names
    function o:DisableAddOnsForCharacter(addOnNames)
        assert(type(addOnNames) == 'table', "AddOn names array are required.")
        if #addOnNames <= 0 then return end
        local charName = UnitName("player")
        for i, name in ipairs(addOnNames) do
            self:DisableAddOnForCharacter(charName, name)
        end
    end

end; PropsAndMethods(L)

