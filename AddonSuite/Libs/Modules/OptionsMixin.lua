--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type ADS_Namespace
local ns = select(2, ...)

local O, GC, M = ns.O, ns.GC, ns.M
local API, L = O.API, ns:AceLocale()
local AceConfig, AceConfigDialog = ns:AceConfig(), ns:AceConfigDialog()
local AceDBOptions = ns:AceDBOptions()
local AceGUI = ns:AceGUI()
local HelpTour = O.HelpTour
local OptionsAddonsMixin = O.OptionsAddonsMixin

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
    },
  }
  return options
end

--- Narrows the category column (tree) to the divider width
local function SetCategoryTreeWidth()
  local status = AceConfigDialog:GetStatusTable(ns.addon)
  status.groups = status.groups or {}
  status.groups.treewidth = 110
  status.groups.treesizable = true
end

--- The category divider stays locked until the dialog has
--- been moved; a no-op move after each Open unlocks it.
--- @param appName string
local function UnlockCategoryDividerOnOpen(_, appName)
  if appName ~= ns.addon then return end
  local dialog = AceConfigDialog.OpenFrames[appName]
  -- Every Open, refreshes too, re-anchors and relocks it
  if not dialog or dialog:GetUserData('dividerUnlockPending') then return end
  dialog:SetUserData('dividerUnlockPending', true)
  C_Timer.After(0.1, function()
    dialog:SetUserData('dividerUnlockPending', nil)
    if AceConfigDialog.OpenFrames[appName] ~= dialog then return end
    dialog.frame:StartMoving()
    dialog.frame:StopMovingOrSizing()
  end)
end

--- @type ADS_HelpTip?
local helpTip

--- @return ADS_HelpTip
local function HelpTip()
  helpTip = helpTip or CreateFrame('Frame', nil, UIParent, 'ADS_HelpTipTemplate')
  return helpTip
end

--- @return string? @Key of the General tab on screen
local function SelectedGeneralTab()
  local status = AceConfigDialog:GetStatusTable(ns.addon, { 'general' })
  return status.groups and status.groups.selected
end

--- Every Open rebuilds the widgets, so re-pick the tour step after it.
--- @param appName string
local function ShowHelpTourOnOpen(_, appName)
  if appName ~= ns.addon then return end
  local dialog = AceConfigDialog.OpenFrames[appName]
  if not dialog or dialog:GetUserData('helpTourPending') then return end
  dialog:SetUserData('helpTourPending', true)
  C_Timer.After(0.1, function()
    dialog:SetUserData('helpTourPending', nil)
    if AceConfigDialog.OpenFrames[appName] ~= dialog then return end
    if SelectedGeneralTab() == 'favorites' then HelpTour:CompleteStep('FavoritesTab') end
    HelpTour:OnHostShown('Settings', dialog, HelpTip())
  end)
end

function o:InitOptions()
  local options = self:CreateOptions()
  -- This creates the Profiles Tab/Section in Settings UI
  options.args.profiles = AceDBOptions:GetOptionsTable(ns:db())
  options.args.profiles.order = 1000
  AceConfig:RegisterOptionsTable(ns.addon, options, { GC.C.CONSOLE_COMMAND_OPTIONS })
  SetCategoryTreeWidth()
  hooksecurefunc(AceConfigDialog, 'Open', UnlockCategoryDividerOnOpen)
  hooksecurefunc(AceConfigDialog, 'Open', ShowHelpTourOnOpen)
  -- Closing releases the dialog; its widget is pooled and reused
  hooksecurefunc(AceGUI, 'Release', function(_, widget) HelpTour:OnHostHidden(widget) end)
  if API:GetUIScale() > 1.0 then return end

  AceConfigDialog:SetDefaultSize(ns.addon, 950, 600)
end
