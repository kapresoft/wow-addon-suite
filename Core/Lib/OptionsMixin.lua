--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace
local ns = select(2, ...)
local O, GC, M, LibStub = ns.O, ns.GC, ns.M, ns.LibStub
local ACE, API = O.AceLibrary, O.API
local AceConfig, AceConfigDialog, AceDBOptions = ACE.AceConfig, ACE.AceConfigDialog, ACE.AceDBOptions
local DebugSettings = O.DebuggingSettingsGroup
local libName = M.OptionsMixin
--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
--- @class OptionsMixin : BaseLibraryObject
--- @field util OptionsUtil
local S = LibStub:NewLibrary(libName); if not S then return end;
local p = ns:LC().OPTIONS:NewLogger(libName)

-- todo: prompt user to reload if addons need to be enabled/disabled in general settings

--[[-----------------------------------------------------------------------------
Method and Properties
-------------------------------------------------------------------------------]]
--- @param o OptionsMixin
local function MethodsAndProps(o)
    local L = ns:AceLocale()

    --- Called automatically by CreateAndInitFromMixin(..)
    --- @param addon AddonSuite
    function o:Init(addon)
        assert(addon, "AddonSuite is required")
        self.addon = addon
        self.util = O.OptionsUtil:New(o)
        self.locale = L
    end

    --- Usage:  local instance = OptionsMixin:New(addon)
    --- @param addon AddonSuite
    --- @return OptionsMixin
    function o:New(addon) return ns:K():CreateAndInitFromMixin(o, addon) end

    function o:CreateOptions()
        local order = ns:CreateSequence()

        --- @type AceConfigOption
        local options = {
            name = GC.C.FRIENDLY_NAME,
            handler = self,
            type = "group",
            args = {
                general = O.OptionsAddonsMixin:New(self):CreateAddOnsGroup(order),
                minimap = O.OptionsMinimapMixin:New(self, order):CreateOptions(),
                debugging = DebugSettings:CreateDebuggingGroup(),
            }
        }

        return options
    end

    function o:InitOptions()
        local options = self:CreateOptions()
        -- This creates the Profiles Tab/Section in Settings UI
        options.args.profiles = AceDBOptions:GetOptionsTable(ns:db())
        AceConfig:RegisterOptionsTable(ns.name, options, { GC.C.CONSOLE_COMMAND_OPTIONS })
        if API:GetUIScale() > 1.0 then return end

        AceConfigDialog:SetDefaultSize(ns.name, 950, 600)
    end

end; MethodsAndProps(S)
