--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace
local ns = select(2, ...)
local O, GC, MSG = ns.O, ns.GC, ns.GC.M
local EnableAddOn, DisableAddOn = EnableAddOn or C_AddOns.EnableAddOn, DisableAddOn or C_AddOns.DisableAddOn
local L = ns:AceLocale()

local libName = ns.M.OptionsController
--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
--- @class OptionsController : AceEvent
local S = ns:NewLibWithEvent(libName)
local p = ns:CreateDefaultLogger(libName)

local ADDON_CONTROLLER_RELOAD_CONFIRM = "ADDON_CONTROLLER_RELOAD_CONFIRM"

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
--- @param o OptionsController
local function PropsAndMethods(o)
    function o:Init()
        self:InitUI()
        self:RegisterMessage(GC.M.OnSwitchProfile, function(...) self:OnSwitchProfile(...) end)
        self:RegisterMessage(MSG.OnApplyAndRestart, function() self:OnApplyAndRestartConditional() end)
    end

    function o:InitUI()
        if StaticPopupDialogs[ADDON_CONTROLLER_RELOAD_CONFIRM] then return end
        StaticPopupDialogs[ADDON_CONTROLLER_RELOAD_CONFIRM] = {
            text =  ns.sformat(':: %s ::\n\n', ns.name) ..  '%s',
            button1 = YES,
            button2 = NO,
            OnAccept = function() self:OnApplyAndRestart() end,
            timeout = 0,
            whileDead = true,
            hideOnEscape = true,
            showAlert = true,
            preferredIndex = 3, -- to avoid tainting issues
        }

    end

    ---@param msg string The message name
    ---@param source string The libName that triggered the call
    ---@param profileName string
    function o:OnSwitchProfile(msg, source, profileName)
        assert(profileName, "Profile Name is missing.")
        p:vv(function() return "Received: %s from %s", msg, source end )
        ns:db():SetProfile(profileName)
        self:OnApplyAndRestartConditional()
    end

    function o:OnApplyAndRestartConditional()
        print('hello')
        if ns:global().confirm_reloads == true then
            StaticPopup_Show(ADDON_CONTROLLER_RELOAD_CONFIRM, ns.name .. ' ' .. L['REQUIRES_RELOAD_PROFILE_CHANGED'])
            return
        end
        self:OnApplyAndRestart()
    end

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

    S:Init()
end; PropsAndMethods(S)

