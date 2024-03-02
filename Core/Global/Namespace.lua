--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Kapresoft_Base_Namespace
local kns = select(2, ...)

--- @type LibStub
local LibStub = LibStub

--- @type Kapresoft_LibUtil_Objects
local LibUtilObjects = kns.Kapresoft_LibUtil.Objects

--- @type Kapresoft_LibUtil_PrettyPrint
local PrettyPrint = LibUtilObjects.PrettyPrint
PrettyPrint.setup({ show_function = true, show_metatable = true, indent_size = 2, depth_limit = 3 })

--[[--- @class Namespace
local NamespaceObject = {
    ---Usage:
    ---```
    ---local GC = LibStub(LibName('GlobalConstants'), 1)
    ---```
    --- @type fun(moduleName:string, optionalMajorVersion:string)
    --- @return string The full LibStub library name. Example:  '[AddonName]-GlobalConstants-1.0.1'
    LibName = {},
    ---Usage:
    ---```
    ---local L = {}
    ---local mt = { __tostring = ns.ToStringFunction() }
    ---setmetatable(mt, L)
    ---```
    --- @type fun(moduleName:string)
    ToStringFunction = {}
}]]

--- @type string
local addonName
--- @type Kapresoft_Base_Namespace
local _ns
addonName, _ns = ...
local LibName = _ns.LibName

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
    --- @type GlobalConstants
    GlobalConstants = {},
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
    AceLibStub = 'AceLibStub',
    LU = 'LU',
    pformat = 'pformat',
    sformat = 'sformat',
    AceLibrary = 'AceLibrary',

    AceDbInitializerMixin = 'AceDbInitializerMixin',
    Core = 'Core',
    GlobalConstants = 'GlobalConstants',
    Logger = 'Logger',
    MainEventHandler = 'MainEventHandler',
    OptionsMixin = 'OptionsMixin',
}

local InitialModuleInstances = {
    -- External Libs --
    LU = LibUtilObjects,
    AceLibrary = LibUtilObjects.AceLibrary.O,
    AceLibStub = LibStub,
    -- Internal Libs --
    GlobalConstants = LibStub(LibName(M.GlobalConstants)),
    pformat = PrettyPrint.pformat,
}

--- @type GlobalConstants
local GC = LibStub(LibName(M.GlobalConstants))

---Usage:
---```
---local O, LibStub = ADT_Namespace(...)
---local AceConsole = O.AceConsole
---```
--- @return Namespace
function ADT_Namespace(...)
    --- @type string
    local addon
    --- @class Namespace : Kapresoft_Base_Namespace
    local ns
    addon, ns = ...


    --- @type GlobalObjects
    ns.O = ns.O or {}
    --- @type string
    ns.name = addon
    --- @type string
    ns.nameShort = GC:GetLogName()

    for key, val in pairs(LibUtilObjects) do ns.O[key] = val end
    for key, _ in pairs(M) do
        print('key:', key)
        local lib = InitialModuleInstances[key]
        if lib then ns.O[key] = lib end
    end

    ns.O.LibStub = ns.LibStub
    ns.pformat = ns.O.pformat
    ns.sformat = ns.O.sformat
    ns.M = M

    local Table = LibUtilObjects.Table
    local pformat = ns.pformat
    local getSortedKeys = Table.getSortedKeys

    --- @return Kapresoft_LibUtil
    function ns:K() return ns.Kapresoft_LibUtil end

    ---Example:
    ---```
    ---local O, LibStub, M, ns = ADT_Namespace(...):LibPack()
    ---```
    --- @return GlobalObjects, LocalLibStub, Modules, Namespace
    function ns:LibPack() return self.O, ns.LibStub, M, self end

    --- @param libName string The library name. Ex: 'GlobalConstants'
    --- @param o table The library object instance
    function ns:Register(libName, o)
        if not (libName or o) then return end
        self.O[libName] = o
    end

    --- @param libName string The library name. Ex: 'GlobalConstants'
    function ns:NewLogger(libName) return self.O.Logger:NewLogger(libName) end
    function ns:ToStringNamespaceKeys() return pformat(getSortedKeys(_ns)) end
    function ns:ToStringObjectKeys() return pformat(getSortedKeys(_ns.O)) end

    return ns
end

ADDON_SUITE_NS = ADT_Namespace(...)

--- @deprecated Use addonsuite_ns(...)
--- @return GlobalObjects, LocalLibStub, Modules, Namespace
function ADT_LibPack(...) return ADDON_SUITE_NS:LibPack() end

--- @return Namespace
function addonsuite_ns(...) return select(2, ...) end
