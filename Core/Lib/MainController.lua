--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace
local ns = select(2, ...)
local O, GC, M = ns.O, ns.GC, ns.M
local Ace, LibStub = ns.KO().AceLibrary.O, ns.LibStub
local E, MSG, L = GC.E, GC.M, ns:AceLocale()
local API = O.API

--[[-----------------------------------------------------------------------------
Lua Vars
-------------------------------------------------------------------------------]]
local sformat = string.format

--[[-----------------------------------------------------------------------------
Blizzard Vars
-------------------------------------------------------------------------------]]
local CreateFrame, FrameUtil = CreateFrame, FrameUtil
local RegisterFrameForEvents, RegisterFrameForUnitEvents = FrameUtil.RegisterFrameForEvents, FrameUtil.RegisterFrameForUnitEvents

--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
--- @class MainController : BaseLibraryObject_WithAceEvent
local S = LibStub:NewLibrary(M.MainController, 1); if not S then return end
Ace.AceEvent:Embed(S)
local p = ns:CreateDefaultLogger(M.MainController)
local pp = ns:CreateDefaultLogger(ns.name)

--[[-----------------------------------------------------------------------------
Support Functions
-------------------------------------------------------------------------------]]

---Other modules can listen to message
---```Usage:
---AceEvent:RegisterMessage(MSG.OnAddonReady, function(evt, ...) end
---```
--- @param addon AddonSuite
local function SendAddonReadyMessage(addon)
    S:SendMessage(MSG.OnAddonReady, addon)
end

--- @param f MainControllerFrame
local function OnPlayerEnteringWorld(f, event, ...)
    local isLogin, isReload = ...
    local addon = f.ctx.addon

    SendAddonReadyMessage(addon)

    --@debug@
    isLogin = true
    p:d(function() return "IsLogin=%s IsReload=%s", tostring(isLogin), tostring(isReload) end)
    --@end-debug@

    if not isLogin then return end

    pp:vv(GC:GetMessageLoadedText())
end

---@param addons table<number, AddOnName>
---@param action string
local function AddOnsToString(action, addons)
    if #addons <=0 then return '' end
    local str = ''
    for _, n in ipairs(addons) do
        str = sformat('%s%s (%s)\n', str, n, action)
    end
    return str
end

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
--- @param o MainController
local function InstanceMethods(o)

    local ADDON_SUITE_RELOAD_CONFIRM = 'ADDON_SUITE_RELOAD_CONFIRM'


    ---Init Method: Called by Mixin
    ---Example:
    ---```
    ---local newInstance = Mixin:MixinAndInit(O.MainControllerMixin, addon)
    ---```
    --- @param addon AddonSuite
    function o:Init(addon)
        self.addon = addon
        self:RegisterMessage(MSG.OnAfterInitialize, function(evt, ...) self:OnAfterInitialize() end)
    end

    function o:OnAfterInitialize() self:RegisterEvents() end

    --- @private
    function o:RegisterEvents()
        p:f1("RegisterEvents called...")
        self:RegisterOnPlayerEnteringWorld()
        self:RegisterMessage(MSG.OnAddonReady, function() self:OnAddonReady()  end)
    end

    --- @private
    function S:OnAddonReady()
        O.MinimapIconController:New(self):InitMinimapIcon()
        self:RefreshAutoLoadedAddons()
    end

    function o:RefreshAutoLoadedAddons()
        local addons = API:GetEnabledAddOns()
        if not addons then return end

        local addonsToEnable = {}
        local addonsToDisable = {}
        API:ForEachCheckedAndLoadableAddon(function(info)
            table.insert(addonsToEnable, info.name)
        end)

        API:ForEachAddOnThatCanBeDisabled(function(info)
            p:f1(function() return 'Addon should be disabled: %s', info.name end)
            table.insert(addonsToDisable, info.name)
        end)

        -- TODO: Add prompt_for_reload_to_enable_addons option or check it on the fly as the user checks
        -- TODO: an addon?
        p:f1(function() return 'AddOns:: enable=%s disable=%s',
                                    pformat(addonsToEnable), pformat(addonsToDisable) end)

        if true == ns:db().global.prompt_for_reload_to_enable_addons
                and (#addonsToEnable > 0 or #addonsToDisable > 0) then
            -- TODO: add this config
            local prompt = ns:db().global.prompt_for_reload_to_enable_addons
                p:f1(function() return 'prompt-for-reload=%s addons to enable=%s disable=%s',
                        tostring(prompt), pformat(addonsToEnable), pformat(addonsToDisable) end)

            local msg = ''
            if #addonsToEnable > 0 then
                msg = AddOnsToString('Enable', addonsToEnable)
            end
            if #addonsToDisable > 0 then
                msg = msg .. AddOnsToString('Disable', addonsToDisable)
            end

            StaticPopup_Show(DEV_RELOAD_CONFIRM, msg)
        end
    end

    --- @private
    function S:RegisterOnPlayerEnteringWorld()
        local f = self:CreateEventFrame()
        f:SetScript(E.OnEvent, OnPlayerEnteringWorld)
        RegisterFrameForEvents(f, { E.PLAYER_ENTERING_WORLD })
    end

    --- @param eventFrame MainControllerFrame
    --- @return MainEventContext
    function o:CreateEventContext(eventFrame)
        --- @class MainEventContext
        --- @field frame MainControllerFrame
        --- @field addon AddonSuite
        local ctx = {
            frame = eventFrame,
            addon = self.addon,
        }
        return ctx
    end

    --- @return MainControllerFrame
    function o:CreateEventFrame()
        --- @class MainControllerFrame : _Frame
        --- @field ctx MainEventContext
        local f = CreateFrame("Frame", nil, self.addon.frame)
        f.ctx = self:CreateEventContext(f)
        return f
    end
end

InstanceMethods(S)
