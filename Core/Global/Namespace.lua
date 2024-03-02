--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Kapresoft_Base_Namespace
local kns = select(2, ...)
local LibName = kns.LibName

--- @type LibStub
local LibStub = LibStub
--- @type Kapresoft_LibUtil_Objects
local LibUtilObjects = kns.Kapresoft_LibUtil.Objects

--- @type Kapresoft_LibUtil_PrettyPrint
local PrettyPrint = LibUtilObjects.PrettyPrint
PrettyPrint.setup({ show_function = true, show_metatable = true, indent_size = 2, depth_limit = 3 })

--[[-----------------------------------------------------------------------------
GlobalObjects
-------------------------------------------------------------------------------]]
--- @class GlobalObjects
local GlobalObjects = {
    --- @type Kapresoft_LibUtil_AceLibraryObjects
    AceLibrary = {},
    --- @type LibStub
    AceLibStub = {},

    --- @type fun(fmt:string, ...)|fun(val:string)
    pformat = {},
    --- @type fun(fmt:string, ...)|fun(val:string)
    sformat = {},

    --- @type Kapresoft_LibUtil_Objects
    LU = {},

    --- @type AceDbInitializerMixin
    AceDbInitializerMixin = {},
    --- @type Core
    Core = {},
    --- @type Logger
    Logger = {},
    --- @type MainEventHandler
    MainEventHandler = {},
    --- @type OptionsMixin
    OptionsMixin = {},
}
--[[-----------------------------------------------------------------------------
Modules
-------------------------------------------------------------------------------]]

--- @class Modules
local M = {
    LibStubAce = 'LibStubAce',
    LU = 'LU',
    pformat = 'pformat',
    sformat = 'sformat',
    AceLibrary = 'AceLibrary',

    AceDbInitializerMixin = 'AceDbInitializerMixin',
    Core = 'Core',
    Logger = 'Logger',
    MainEventHandler = 'MainEventHandler',
    OptionsMixin = 'OptionsMixin',
}

--[[-----------------------------------------------------------------------------
Type: LibPackMixin
-------------------------------------------------------------------------------]]
--- @class LibPackMixin
--- @field O GlobalObjects
--- @field KO fun() : Kapresoft_LibUtil_Objects
--- @field name Name The addon name
local LibPackMixin = { };

---@param o LibPackMixin
local function LibPackMixinMethods(o)

    --- Create a new instance of AceEvent or embed to an obj if passed
    --- @return AceEvent
    --- @param obj|nil The object to embed or nil
    function o:AceEvent(obj) return self.O.AceLibrary.AceEvent:Embed(obj or {}) end

    --- Create a new instance of AceBucket or embed to an obj if passed
    --- @return AceBucket
    --- @param obj|nil The object to embed or nil
    function o:AceBucket(obj) return self.LibStubAce('AceBucket-3.0'):Embed(obj or {}) end

    --- @return AceLocale
    function o:AceLocale() return LibStub("AceLocale-3.0"):GetLocale(self.name, true) end

    --- @return Kapresoft_LibUtil_SequenceMixin
    --- @param startingSequence number|nil
    function o:CreateSequence(startingSequence)
        return self:KO().SequenceMixin:New(startingSequence)
    end

end; LibPackMixinMethods(LibPackMixin)

--- @param ns __Namespace | Namespace
--- @return LocalLibStub
local function NewLocalLibStub(ns)
    --- @class LocalLibStub : Kapresoft_LibUtil_LibStubMixin
    local LocalLibStub = LibUtilObjects.LibStubMixin:New(ns.name, 1.0,
            function(name, newLibInstance)
                ns:Register(name, newLibInstance)
                ---@type Logger
                local loggerLib = LibStub(LibName(ns.M.Logger), 1)
                newLibInstance.logger = loggerLib:NewLogger(moduleName)
            end)
    return LocalLibStub
end

--- @alias Namespace __Namespace | LibPackMixin

---@param o __Namespace | Namespace
local function NameSpacePropertiesAndMethods(o)
    local getSortedKeys = LibUtilObjects.Table.getSortedKeys
    local pformat = o.pformat

    --[[------------------------------------------
    Properties
    ----------------------------------------------]]
    --- @type LocalLibStub
    o.LibStub = NewLocalLibStub(o)
    --- @type LibStub
    o.LibStubAce = LibStub
    o.pformat = PrettyPrint.pformat
    o.M = M

    -- External Libs --
    o.O.LU = LibUtilObjects
    o.O.AceLibrary = LibUtilObjects.AceLibrary.O

    --[[------------------------------------------
    Instance Methods
    ----------------------------------------------]]

    --- @return Kapresoft_LibUtil
    function o:K() return kns.Kapresoft_LibUtil end
    --- @return Kapresoft_LibUtil_Objects
    function o:KO() return kns.Kapresoft_LibUtil.Objects  end

    ---Example:
    ---```
    ---local O, LibStub, M, ns = ADT_Namespace(...):LibPack()
    ---```
    --- @return GlobalObjects, LocalLibStub, Modules, Namespace
    function o:LibPack() return self.O, self.LibStub, self.M, self end

    --- @param libName string The library name. Ex: 'GlobalConstants'
    --- @param o table The library object instance
    function o:Register(libName, o)
        if not (libName or o) then return end
        self.O[libName] = o
    end

    --- @param libName string The library name. Ex: 'GlobalConstants'
    function o:NewLogger(libName) return self.O.Logger:NewLogger(libName) end
    function o:ToStringNamespaceKeys() return pformat(getSortedKeys(self)) end
    function o:ToStringObjectKeys() return pformat(getSortedKeys(self.O)) end

end

---Usage:
---```
---local O, LibStub = ADT_Namespace(...)
---local AceConsole = O.AceConsole
---```
--- @return Namespace
function AddonSuite_Namespace(...)
    --- @type string
    local addon
    --- @class __Namespace : Kapresoft_Base_Namespace
    local ns; addon, ns = ...

    --- @type GlobalObjects
    ns.O = ns.O or {}
    --- @type string
    ns.name = addon
    --- @type string
    ns.nameShort = ns.GC:GetLogName()
    ns.mt = { __tostring = function() return addon .. '::Namespace'  end }
    setmetatable(ns, ns.mt)

    --- @see BlizzardInterfaceCode:Interface/SharedXML/Mixin.lua
    Mixin(ns, LibPackMixin)

    NameSpacePropertiesAndMethods(ns)

    --- print(ns.name .. '::Namespace:: pformat:', pformat)
    --- Global Function
    pformat = pformat or ns.pformat

    return ns
end


ADDON_SUITE_NS = AddonSuite_Namespace(...)

--- @return Namespace
function addonsuite_ns(...) return select(2, ...) end
