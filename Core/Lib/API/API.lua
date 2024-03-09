--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace
local ns = select(2, ...)
local O, GC, M, LibStub = ns.O, ns.O.GlobalConstants, ns.M, ns.LibStub

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

    ---@param indexOrName IndexOrName The index from 1 to GetNumAddOns() or The name of the addon (as in TOC/folder filename), case insensitive.
    function o:GetAddOnInfo(indexOrName)
        assert(indexOrName, "The index parameter is required.")
        local name, title, notes, loadable, reason, security, newVersion = GetAddOnInfo(indexOrName)
        --- @type AddOnInfo
        local info = {
            name = name, title = title, loadable = loadable, notes = notes,
            reason = reason, security = security, newVersion = newVersion
        }
        return info
    end

    ---@param callbackFn AddOnCallbackFn
    function o:ForEachAddOn(callbackFn)
        local addOnCount = GetNumAddOns()
        if addOnCount <= 0 then return end

        for i = 1, addOnCount do
            callbackFn(self:GetAddOnInfo(i))
        end
    end

end; PropsAndMethods(L)

