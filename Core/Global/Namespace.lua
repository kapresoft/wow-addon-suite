--[[-----------------------------------------------------------------------------
Base Namespace
-------------------------------------------------------------------------------]]
--- @type CoreNamespace
local kns = select(2, ...)

--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type LibStub
local LibStub = LibStub
local GC, K = kns.GC, kns.Kapresoft_LibUtil
local KO = K.Objects
local CategoryLoggerMixin, EventMessagesMixin = kns.O.CategoryLoggerMixin, kns.O.EventMessagesMixin

--[[-----------------------------------------------------------------------------
Type: Modules
-------------------------------------------------------------------------------]]
--- @class Modules
local M = {
    --- @type AceDbInitializerMixin
    AceDbInitializerMixin = {},
    --- @type AddOnManagerMixin
    AddOnManagerMixin = {},
    --- @type AddOnStateController
    AddOnStateController = {},
    --- @type API
    API = {},
    --- @type DebuggingSettingsGroup
    DebuggingSettingsGroup = {},
    --- @type EventMessagesMixin
    EventMessagesMixin = {},
    --- @type EventToMessageRelay
    EventToMessageRelay = {},
    --- @type CategoryLoggerMixin
    CategoryLoggerMixin = {},
    --- @type ConfigDialogController,
    ConfigDialogController = {},
    --- @type MainController
    MainController = {},
    --- @type MinimapIconControllerMixin
    MinimapIconControllerMixin = {},
    --- @type OptionsAddonsMixin
    OptionsAddonsMixin = {},
    --- @type OptionsMixin
    OptionsMixin = {},
    --- @type OptionsMinimapMixin
    OptionsMinimapMixin = {},
    --- @type OptionsUtil
    OptionsUtil = {},
}; KO.LibModule.EnrichModules(M)

--- @alias Namespace __Namespace | CategoryLoggerMixin | EventMessagesMixin | Kapresoft_LibUtil_NamespaceAceLibraryMixin

--[[-----------------------------------------------------------------------------
Type: __Namespace
-------------------------------------------------------------------------------]]
--- @class __Namespace : CoreNamespace
--- @field DefaultAddOnDatabase AddOn_DB
--- @field GC GlobalConstants
local ns = kns;
--- @type Modules
ns.M = M
ns.mt = { __tostring = function() return ns.addon .. '::Namespace'  end }
setmetatable(ns, ns.mt)

--[[-----------------------------------------------------------------------------
Namespace Methods
-------------------------------------------------------------------------------]]
--- @type __Namespace | Namespace
local o = ns; do
    ---@param nSpace __Namespace | Namespace
    local function InitLocalLibStub(nSpace)
        --- @class LocalLibStub : Kapresoft_LibUtil_LibStubMixin
        local LocalLibStub = nSpace:K().Objects.LibStubMixin:New(nSpace.name, 1.0, function(name, newLibInstance)
            -- local p = LogCategories.DEFAULT:NewLogger("Namespace::InitLocalLibStub")
            -- can only use verbose here because global vars are not yet loaded
            -- p:vv( function() return 'New Lib: %s', newLibInstance.major end)
            nSpace:Register(name, newLibInstance)
        end)
        nSpace.LibStubAce  = LibStub
        nSpace.LibStub     = LocalLibStub
        nSpace.O.LibStub   = LocalLibStub
    end; InitLocalLibStub(o)
end

CategoryLoggerMixin:Configure(ns)
EventMessagesMixin:Mixin(ns)

--- @type string
o.nameShort = GC:GetLogName()

o.locale = o.locale or {}

--- @return AddonSuite
function o:a() return ADDON_SUITE end

--- @see _Lib.xml
function o:pf() return _G['AddonSuiteFrame'] end

--- @param moduleName string The module name, i.e. MainController
--- @param optionalMajorVersion number|string
--- @return string The complete module name, i.e. 'ActionbarPlus-MainController-1.0'
function o:LibName(moduleName, optionalMajorVersion) return GC.LibName(moduleName, optionalMajorVersion) end
--- @param moduleName string The module name, i.e. MainController
function o:ToStringFunction(moduleName) return GC.ToStringFunction(moduleName) end

--- Simple Library
---@param libName Name
--- @vararg any|nil Optional Mixins
function o:NewLib(libName, ...)
    assert(libName, "LibName is required")
    local newLib = {}
    local len = select("#", ...)
    if len > 0 then newLib = self:K():Mixin({}, ...) end
    newLib.mt = { __tostring = GC.ToStringFunction(libName)}
    setmetatable(newLib, newLib.mt)
    self.O[libName] = newLib
    return newLib
end
--- Simple Library with AceEvent
--- @param libName Name
--- @vararg any|nil Optional Mixins
function o:NewLibWithEvent(libName, ...)
    assert(libName, "LibName is required")
    local newLib = o:AceEvent()
    local len = select("#", ...)
    if len > 0 then newLib = self:K():Mixin(newLib, ...) end
    newLib.mt = { __tostring = GC.ToStringFunction(libName)}
    setmetatable(newLib, newLib.mt)
    self.O[libName] = newLib
    return newLib
end

--- @param obj table The library object instance
function o:Register(libName, obj)
    if not (libName or obj) then return end
    self.O[libName] = obj
end

--- @param dbfn fun() : AddOn_DB | "function() return addon.db end"
function o:SetAddOnFn(dbfn) self.addonDbFn = dbfn end

--- @return AddOn_DB
function o:db() return self.addonDbFn() end

--- @return Profile_Config
function o:profile()
    local db = self.addonDbFn()
    local profile = db and db.profile
    if not profile.enabledAddons then
        profile.enabledAddons = {}
    end
    return profile
end

--- @return Profile_Global_Config
function o:global() return self.addonDbFn().global end
--- @return Minimap
function o:minimap() return self:global().minimap end
--- @return LibDataBroker
function o:LibDataBroker() return LibStub("LibDataBroker-1.1") end
--- @return LibDBIcon
function o:LibDBIcon() return LibStub("LibDBIcon-1.0") end

--[[-----------------------------------------------------------------------------
Namespace Global Var
-------------------------------------------------------------------------------]]
--- @type Namespace
ADDON_SUITE_NS = ns
