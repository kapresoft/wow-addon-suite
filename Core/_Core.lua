--- @type CoreNamespace
local ns = select(2, ...)
local K = ns.Kapresoft_LibUtil

K:MixinWithDefExc(ns, K.Objects.CoreNamespaceMixin, K.Objects.NamespaceAceLibraryMixin)

--- The "name" field conflicts with K.Objects. We need to restore it here
--- @deprecated Deprecated. Use ns.addon
ns.name         = ns.addon
ns.shortName    = 'ads'
ns.addonLogName = string.upper(ns.shortName)

--- @type Modules
ns.O = ns.O or {}

--- @type Kapresoft_LibUtil_ColorDefinition
local consoleColors = {
    primary   = '7ACFFB',
    secondary = 'fbeb2d',
    tertiary  = 'ffffff',
}; ns.consoleColors = consoleColors

--- @type Kapresoft_LibUtil_ConsoleHelper
local ch = ns:NewConsoleHelper(consoleColors); ns.ch = ch

--[[-----------------------------------------------------------------------------
Type: DebugSettingsFlag
-------------------------------------------------------------------------------]]
--- @class DebugSettingsFlag
--- @see GlobalDeveloper
local flag = {
    --- Enable developer mode: logging and debug tab settings
    developer = false,
    --- Enables the DebugChatFrame log console
    enableLogConsole = false,
    --- Enable selection of chat frame tab
    selectLogConsoleTab = false,
}

--[[-----------------------------------------------------------------------------
Type: DebugSettings
--- Make sure to match this structure in GlobalDeveloper (which is not packaged in releases)
-------------------------------------------------------------------------------]]
--- @class DebugSettings
ns.debug = { flag = flag, alwaysEnabledAddOns = {}, }

--[[-----------------------------------------------------------------------------
Namespace Methods
-------------------------------------------------------------------------------]]
--- @return boolean
function ns:IsDev() return ns.debug.flag.developer == true end

