--- @type string, AddonNamespace
local addon, kns = ...

--- @class ADS_CoreNamespace : AddonNamespace
--- @field GC GlobalConstants
--- @field M Modules
--- @field LogHolder LogHolder
local ns = kns

ns.name = addon -- ns.name is internal use only (kapresoft libs use)
ns.addon = addon -- use this in the addon
ns.nameShort = 'ads'
ns.logName = strupper(ns.nameShort)
ns.traceName = strupper(ns.addon)
ns.sformat = string.format
ns.locale = ns.locale or {}

--- @type Modules
ns.O = ns.O or {}

local String = LibStub('Kapresoft-String-2-0')
local Str_IsBlank = String.IsBlank
local colorFormatter = LibStub('Kapresoft-ColorFormatter-2-0')
ns.O.ColorFormatter = colorFormatter

--- @param rgbHex RGBHex?     @Optional
--- @return cfFn, colorRGBA?
function ns:ColorFn(rgbHex) return colorFormatter:ColorFn(rgbHex) end

--- @type Kapresoft-ColorDefinition-2-0
local colorDef = {
    primary   = CreateColorFromRGBHexString('7ACFFB'),
    secondary = CreateColorFromRGBHexString('fbeb2d'),
    tertiary  = CreateColorFromRGBHexString('ffffff'),
}; ns.colorDef = colorDef

local primaryC = ns:ColorFn(ns.colorDef.primary)
local CHM = LibStub('Kapresoft-ConsoleHelperMixin-2-0')
--- @type Kapresoft-ConsoleHelperMixin-2-0
local ch = CreateAndInitFromMixin(CHM, colorDef); ns.ch = ch

local TimeUtil = LibStub('Kapresoft-TimeUtil-2-0')

--- Get the timestamp
--- @return (string|osdate)?
function ns:ts() return ('[%s]'):format(TimeUtil:NowInHoursMinSeconds()) end

--- Register a Namespace Module
--- @generic T
--- @param anyObj T The library object instance
--- @return T
function ns:Register(libName, anyObj)
  assert(
    type(libName) == 'string' and type(anyObj) == 'table',
    'Register(libName, obj): libName(string) and obj(table) is required.'
  )
  self.O[libName] = anyObj
  return anyObj
end

--- Generate the colorized Log Prefix
--- @param module string The module name
--- @param subPrefix? string Defaults to the addOn name
function ns:CreateLogPrefix(module, subPrefix)
  if not subPrefix then
  return string.format(
          ns.ch:T('{{') .. '%s::%s' .. ns.ch:T('}}:'),
          ns.ch:P(ns.logName), ns.ch:S(module))
  end
  return string.format(
          ns.ch:T('{{') .. '%s::%s::%s' .. ns.ch:T('}}:'),
          ns.ch:P(ns.logName), ns.ch:S(module), ns.ch:S(subPrefix))
end

function ns.tr(prefix, ...)
  --- @type EventTrace
  local et = EventTrace; if not (et and et.LogEvent) then return end
  local c1, logNamePlain = primaryC, ns.traceName
  local n = c1(logNamePlain)
  if not Str_IsBlank(prefix) then n = n .. '::' .. prefix end
  et:LogEvent(n, ...)
end

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
function ns:IsDev()
  --@do-not-package@
  ns.debug.flag.developer = true
  --@end-do-not-package@
  return ns.debug.flag.developer == true
end

