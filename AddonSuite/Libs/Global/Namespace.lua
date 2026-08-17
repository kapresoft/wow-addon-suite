--[[-----------------------------------------------------------------------------
Base Namespace
-------------------------------------------------------------------------------]]
--- @type string, ADS_CoreNamespace
local addon, kns = ...

--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
local LibStub, GC = LibStub, kns.GC
local EventMessagesMixin = kns.O.EventMessagesMixin
local SequenceMixin = kns.O.SequenceMixin

--[[-----------------------------------------------------------------------------
Class: ADS_Namespace
-------------------------------------------------------------------------------]]

--- @class ADS_Namespace : ADS_CoreNamespace, EventMessagesMixin, Kapresoft-GameVersionMixin-2-0, Kapresoft-AceLib-2-0
--- @field DefaultAddOnDatabase AddOn_DB
--- @field SynchronizedAddOns SynchronizedAddOns
--- @field GC GlobalConstants
--- @field locale LocaleInfo
--- @field LibStub LocalLibStub
--- @field primaryColor string
--- @field colorDef Kapresoft-ColorDefinition-2-0
local ns = kns; ADDON_SUITE_NS = ns

ns.mt = { __tostring = function() return ns.addon .. '::Namespace' end }
setmetatable(ns, ns.mt)


--[[-------------------------------------------------------------------
Formatter/Printer
---------------------------------------------------------------------]]
local cf = ns.O.ColorFormatter
local function predicateFn() return ns.IsDev() end

ns.fmt = LibPrettyPrint:Formatter({ show_all = true, depth_limit = 3 })
fmt = ns.fmt
ns.printer = LibPrettyPrint:Printer({
  prefix = ns.logName,
  formatter = ns.fmt,
  prefix_color = cf:ToHexRGB(ns.colorDef.primary),
  sub_prefix_color = cf:ToHexRGB(ns.colorDef.secondary),
}, predicateFn)

--- @class LogHolder
--- @field printer fun(moduleName:Name) : PrintFn A simple printer
--- @field tracer fun(moduleName:Name) : TraceFn A tracer with auto formatting of variables

ns.LogHolder = {}
do
  local h = ns.LogHolder; local noop = function(_moduleName) return function() end end
  h.printer = noop; h.tracer = noop
end

--[[-----------------------------------------------------------------------------
Mixins
-------------------------------------------------------------------------------]]
local GVM, AceLib = ns.O.GameVersionMixin, ns.O.AceLib
Mixin(ns, GVM, EventMessagesMixin, AceLib)

--[[-----------------------------------------------------------------------------
Namespace Methods
-------------------------------------------------------------------------------]]
--- @type Kapresoft-AddonInfoUtil-2-0
local AddonInfoUtil

--- @return Kapresoft-AddonInfoUtil-2-0
function ns:AIU()
  if AddonInfoUtil then return AddonInfoUtil end
  AddonInfoUtil = self.O.AddonInfoUtil:New(self.addon, self.colorDef, self:IsDev())
  return AddonInfoUtil
end

--- @return AddonSuite
function ns:a() return ADDON_SUITE end

--- Parent frame
--- @see _Lib.xml
function ns:pf() return _G['AddonSuiteFrame'] end

--- Depends on enUS.lua to be loaded first
--- @return string
function ns:GetMessageLoadedText()
  return self:AIU():GetMessageLoadedText(GC.command, GC.commandShort)
end

--- @param dbfn fun() : AddOn_DB | "function() return addon.db end"
function ns:SetAddOnFn(dbfn) self.addonDbFn = dbfn end

--- @return AddOn_DB | "function() return addon.db end"
function ns:db() return self.addonDbFn() end

--- @return Profile_Config?
function ns:profile()
  local db = self.addonDbFn()
  local profile = db and db.profile
  if not profile.enabledAddons then profile.enabledAddons = {} end
  return profile
end

--- @return Profile_Global_Config?
function ns:g() return self.addonDbFn()['global'] end

--- @return Minimap
function ns:minimap() return self:g().minimap end
--- @return LibDataBroker-1.1
function ns:LibDataBroker() return LibStub('LibDataBroker-1.1') end
--- @return LibDBIcon-1.0
function ns:LibDBIcon() return LibStub('LibDBIcon-1.0') end

--- @return Kapresoft-SequenceMixin-2-0
--- @param startingSequence number|nil Optional starting positive index
function ns:CreateSequence(startingSequence) return SequenceMixin.New(startingSequence) end

--- @return table<string, string>
function ns:GetLocale() return self.O.AceLib:AceLocale():GetLocale(self.addon, true) end

--- @return Kapresoft-AceConfigUtil-2-0
function ns:ACU() return self.O.AceConfigUtil:New(ns.addon, not ns:IsDev()) end

--[[-------------------------------------------------------------------
Loggers/Tracers:: NoOp in Official Releases
                  This is overridden in DeveloperSetup
---------------------------------------------------------------------]]

--- Returns the print, delayed-print, tracer, formatted-tracer functions
--- ```
--- local p, t = ns:log('EventHandler')
--- ```
--- @see DeveloperSetup.lua
--- @param moduleName Name  @The module name or any general prefix
--- @return PrintFn
--- @return TraceFn
function ns:log(moduleName)
  return self.LogHolder.printer(moduleName), self.LogHolder.tracer(moduleName)
end
