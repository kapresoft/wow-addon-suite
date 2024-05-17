--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace
local ns = select(2, ...)

local O, M           = ns.O, ns.M
local String         = ns:String()
local AddOnManager   = M.AddOnManagerMixin
local excludedAddOns = { ns.addon, 'DebugChatFrame' }

local IsAnyOfString, EqualsIgnoreCase = String.IsAnyOf, String.EqualsIgnoreCase

--[[-----------------------------------------------------------------------------
Blizzard Vars
-------------------------------------------------------------------------------]]
local GetNumAddOns = GetNumAddOns or C_AddOns.GetNumAddOns
local GetAddOnInfo = GetAddOnInfo or C_AddOns.GetAddOnInfo
--- We don't want to use the old global GetAddOnEnableState() because it doesn't work
local C_AddOns_GetAddOnEnableState = C_AddOns.GetAddOnEnableState
local EnableAddOn, DisableAddOn = EnableAddOn or C_AddOns.EnableAddOn, DisableAddOn or C_AddOns.DisableAddOn
local IsAddOnLoaded = C_AddOns.IsAddOnLoaded or IsAddOnLoaded

ns:OnAddOnStartLoad(function() AddOnManager = O.AddOnManagerMixin end)

--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
local libName = M.API()
--- @class API
local L = ns:NewLib(libName)
local p = ns:LC().API:NewLogger(libName)
--[[-----------------------------------------------------------------------------
Support Functions
-------------------------------------------------------------------------------]]
--- @return boolean Returns true if it is to be included
--- @param info AddOnInfo
local function developerAddOnsPredicateFn(info)
    local include = not IsAnyOfString(info.name, unpack(excludedAddOns))
    return include
end

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
            local a = AddOnManager:New(name)
            if a.missing then table.insert(toRemove, name) end
        end
        for _, name in ipairs(toRemove) do
            ns:profile().enabledAddons[name] = nil
        end

        return ns:profile().enabledAddons
    end

    function o:GetEnabledAddOns() return self:GetEnabledAndInstalledAddOns() end

    function o:IsTitanPanelAvailable() return type(TitanPanelButton_OnShow) == 'function' end

    --- @param indexOrName IndexOrName
    --- @return Enabled
    function o:IsAddOnEnabled(indexOrName)
        local charName = self:GetCurrentPlayer()
        local intVal = -1
        if C_AddOns_GetAddOnEnableState then
            intVal = C_AddOns_GetAddOnEnableState(indexOrName, charName)
        elseif GetAddOnEnableState then
            intVal = GetAddOnEnableState(charName, indexOrName)
        end
        return intVal == 2
    end

    --- @param indexOrName IndexOrName
    --- @return Enabled
    function o:IsAddOnDisabled(indexOrName) return self:IsAddOnEnabled(indexOrName) ~= true end

    --- @param indexOrName Name|IndexOrName
    --- @return boolean
    function o:IsAddOnLoadOnDemand(indexOrName) return AddonList_IsAddOnLoadOnDemand(indexOrName) == true end

    --- @param indexOrName IndexOrName
    --- @boolean
    function o:IsAddOnLoaded(indexOrName) return IsAddOnLoaded(indexOrName) end

    --  TODO: New Option to "Sort By Index", checked by default, else sort by name
    --- @param callbackFn AddOnCallbackFn
    function o:ForEachAddOn(callbackFn)
        return self:ForAllAddOns(callbackFn, developerAddOnsPredicateFn, true)
    end

    ---@param name Name
    function o:IsAddOnLibraryType(name)
        local type = GetAddOnMetadata(name, 'X-Category')
        return type and EqualsIgnoreCase(type, 'library')
    end

    --- @param callbackFn AddOnCallbackFn
    --- @param predicateFn fun(info:AddOnInfo) | "function(info) return true end" | "A function that returns true to accept the element"
    ---@param sortByName boolean|nil Defaults to true
    function o:ForAllAddOns(callbackFn, predicateFn, sortByName)
        sortByName = sortByName or true

        local addOnCount = GetNumAddOns()
        if addOnCount <= 0 then return end

        local addOns = {}
        for i = 1, addOnCount do
            local info = AddOnManager.GetAddOnInfo(i)
            info.sortKey = info.name
            local type = GetAddOnMetadata(info.name, 'X-Category') or ''
            if EqualsIgnoreCase(type, 'library') then
                info.sortKey = '!!A' .. info.name
            end
            table.insert(addOns, info)
            if not sortByName and predicateFn and predicateFn(info) then
                callbackFn(info)
            end
        end
        if not sortByName then return end

        --- @param a AddOnInfo
        --- @param b AddOnInfo
        table.sort(addOns, function(a,b) return a.sortKey < b.sortKey end)
        for _, info in pairs(addOns) do
            if predicateFn and predicateFn(info) then callbackFn(info) end
        end
    end

    --- @param callbackFn fun(info:AddOnManager) | "function(info) end"
    function o:ForEachCheckedAndLoadableAddon(callbackFn)
        local addons = self:GetEnabledAddOns()
        if not addons then return end
        for name, checked in pairs(addons) do
            if checked == true then
                local info =  AddOnManager:New(name)
                if info then callbackFn(info) end
            end
        end
    end

    --- @param callbackFn fun(info:AddOnManager) | "function(info) end"
    function o:ForEachAddOnThatCanBeDisabled(callbackFn)
        local addons = self:GetEnabledAddOns()
        if not addons then return end

        local addOnCount = GetNumAddOns()
        if addOnCount <= 0 then return end

        for i = 1, addOnCount do
            local info = AddOnManager:New(i)
            local checked = addons[info.name] == true
            local validCandidate = ns.name ~= info.name and checked ~= true
                    and not info.loadOnDemand and info.enabled == true
            if validCandidate == true then callbackFn(info) end
        end
    end

    --- @param name Name The addOn name
    --- @param charName Name|nil The character name. Defaults to current
    function o:EnableAddOnForCharacter(name, charName)
        assert(name, "AddOn name is required.")
        charName = charName or UnitName("player")
        EnableAddOn(name, charName)
        p:d(function() return 'AddOn Enabled: %s', name end)
    end

    --- @param name Name The addOn name
    --- @param charName Name|nil The character name. Defaults to current
    function o:DisableAddOnForCharacter(name, charName)
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
        for _, name in ipairs(addOnNames) do
            self:EnableAddOnForCharacter(name, charName)
        end
    end

    --- @param addOnNames table<number, Name> The array of addOn names
    function o:DisableAddOnsForCharacter(addOnNames)
        assert(type(addOnNames) == 'table', "AddOn names array are required.")
        if #addOnNames <= 0 then return end
        local charName = UnitName("player")
        for _, name in ipairs(addOnNames) do
            self:DisableAddOnForCharacter(name, charName)
        end
    end

end; PropsAndMethods(L)

