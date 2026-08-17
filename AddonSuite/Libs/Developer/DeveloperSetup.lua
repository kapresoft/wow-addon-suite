--- @type ADS_Namespace
local ns = select(2, ...)
--- @type LibTraceKit-1.0
local LibTraceKit = LibStub('LibTraceKit-1.0')
assertsafe(type(LibTraceKit) ~= nil, 'Failed to reference LibTraceKit-1.0')

--[[-----------------------------------------------------------------------------
Debug Flags
-------------------------------------------------------------------------------]]
local d = ns.debug
local flag = ns.debug.flag
flag.developer = true
d.alwaysEnabledAddOns = { 'Ace3', '!BugGrabber', 'BugSack' }

--[[-----------------------------------------------------------------------------
Main Code
Available Fonts:
 ConsoleMonoCondensedSemiBold
 ConsoleMonoCondensedSemiBoldOutline
 ConsoleMonoSemiCondensedBlack
 ConsoleMedium
 ConsoleMediumOutline
 SystemFont_Outline_Small
-------------------------------------------------------------------------------]]

--[[-----------------------------------------------------------------------------
Core:: Namespace Override for Dev Namespace
-------------------------------------------------------------------------------]]

--- @return string|nil
local function resolveModuleName(moduleName)
  if type(moduleName) == 'string' then return strtrim(moduleName) end
  return nil
end

--- @param prefix string|any
--- @return TraceFn
local function traceFn(prefix)
  local t = LibTraceKit:New(ns.addon, prefix)
      :WithDelimiter('_')
      :WithColor(ns.colorDef.primary)
  return t --[[@as TraceFn ]]
end

--- @param moduleName Name
local function printerFn(moduleName)
  local _ns = ns
  local m = resolveModuleName(moduleName)
  local pr = _ns.printer
  if m and #m > 0 then pr = _ns.printer:WithSubPrefix(m) end
  return pr
end

do
  local h = ns.LogHolder
  h.printer = printerFn
  h.tracer = traceFn
end
