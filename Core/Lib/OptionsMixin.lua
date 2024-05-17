--[[-----------------------------------------------------------------------------
Type: Options
-------------------------------------------------------------------------------]]
--- @class Options

--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace
local ns = select(2, ...)
local O, GC, M, LibStub = ns.O, ns.GC, ns.M, ns.LibStub
local ACE, API = ns:AceLibrary(), O.API
local AceConfig, AceConfigDialog, AceDBOptions = ACE.AceConfig, ACE.AceConfigDialog, ACE.AceDBOptions
local DebugSettings = O.DebuggingSettingsGroup
local OptionsAddonsMixin, OptionsMinimapMixin = O.OptionsAddonsMixin, O.OptionsMinimapMixin

local libName = M.OptionsMixin()
--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
--- @class OptionsMixin : BaseLibraryObject
--- @field util OptionsUtil
local S = LibStub:NewLibrary(libName); if not S then return end;
local p = ns:LC().OPTIONS:NewLogger(libName)

-- todo: prompt user to reload if addons need to be enabled/disabled in general settings

--[[-----------------------------------------------------------------------------
Library Methods
-------------------------------------------------------------------------------]]
--- @type OptionsMixin
local LIB = S

--- Usage:  local instance = OptionsMixin:New(addon)
--- @param addon AddonSuite
--- @return Options
function LIB:New(addon) return ns:K():CreateAndInitFromMixin(S, addon) end

--[[-----------------------------------------------------------------------------
Instance Methods
-------------------------------------------------------------------------------]]
--- @type Options
local o = S
local L = ns:AceLocale()

--- Called automatically by CreateAndInitFromMixin(..)
--- @param addon AddonSuite
function o:Init(addon)
    assert(addon, "AddonSuite is required")
    self.addon = addon
    self.util = O.OptionsUtil:New(o)
    self.locale = L
end

---@param opt AceConfigOption
local function ConfigureDebugging(opt)
    --@do-not-package@
    if ns:IsDev() then
        opt.args.debugging = DebugSettings:CreateDebuggingGroup()
        p:a(function() return 'Debugging tab in Settings UI is enabled with LogLevel=%s', ADDON_SUITE_LOG_LEVEL end)
        return
    end
    --@end-do-not-package@
    ADDON_SUITE_LOG_LEVEL = 0
end

function o:CreateOptions()
    local order = ns:CreateSequence()
    --- @type AceConfigOption
    local options = {
        name = GC.C.FRIENDLY_NAME,
        handler = self,
        type = "group",
        args = {
            general = OptionsAddonsMixin:New(self):CreateAddOnsGroup(order),
            minimap = OptionsMinimapMixin:New(self, order):CreateOptions(),
        },
    }; ConfigureDebugging(options)
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

