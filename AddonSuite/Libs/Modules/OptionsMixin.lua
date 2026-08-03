--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type ADS_Namespace
local ns = select(2, ...)

local O, GC, M = ns.O, ns.GC, ns.M
local API, L = O.API, ns:AceLocale()
local AceConfig, AceConfigDialog = ns:AceConfig(), ns:AceConfigDialog()
local AceDBOptions = ns:AceDBOptions()
local OptionsAddonsMixin, OptionsMinimapMixin = O.OptionsAddonsMixin, O.OptionsMinimapMixin

--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
local libName = M.OptionsMixin()

--- @class OptionsMixin
--- @field util OptionsUtil
local S = ns:Register(libName, {})
local p, t = ns:log(libName)

--[[-----------------------------------------------------------------------------
Library Methods
-------------------------------------------------------------------------------]]
--- Usage:  local instance = OptionsMixin:New(addon)
--- @param addon AddonSuite
--- @return Options
function S:New(addon) return CreateAndInitFromMixin(S, addon) end

--[[-----------------------------------------------------------------------------
Instance Methods
-------------------------------------------------------------------------------]]
--- @class Options
local o = S

--- Called automatically by CreateAndInitFromMixin(..)
--- @param addon AddonSuite
function o:Init(addon)
  assert(addon, 'AddonSuite is required')
  self.addon = addon
  self.util = O.OptionsUtil:New(o)
  self.locale = L
end

function o:CreateOptions()
  local order = ns:CreateSequence()
  self.order = order
  --- @type AceConfigOption
  local options = {
    name = GC:GetAddOnTitle(),
    handler = self,
    type = 'group',
    args = {
      general = OptionsAddonsMixin:New(self):CreateAddOnsGroup(),
      minimap = OptionsMinimapMixin:New(self):CreateOptions(),
    },
  }
  return options
end

function o:InitOptions()
  local options = self:CreateOptions()
  -- This creates the Profiles Tab/Section in Settings UI
  options.args.profiles = AceDBOptions:GetOptionsTable(ns:db())
  options.args.profiles.order = 1000
  AceConfig:RegisterOptionsTable(ns.addon, options, { GC.C.CONSOLE_COMMAND_OPTIONS })
  if API:GetUIScale() > 1.0 then return end

  AceConfigDialog:SetDefaultSize(ns.addon, 950, 600)
end
