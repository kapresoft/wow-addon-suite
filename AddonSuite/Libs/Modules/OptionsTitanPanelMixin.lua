--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type ADS_Namespace
local ns = select(2, ...)
local M, MSG = ns.M, ns.GC.M
local API = ns.O.API
local StepperSlider = ns.O.StepperSliderWidget
local L = ns:GetLocale()

--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
local libName = M.OptionsTitanPanelMixin()
--- @class OptionsTitanPanelMixin : AceEvent-3.0
local S = ns:Register(libName, ns:NewAceEvent())

--[[-----------------------------------------------------------------------------
Library Methods
-------------------------------------------------------------------------------]]
--- @public
--- @param options Options
--- @return OptionsTitanPanel
function S:New(options) return CreateAndInitFromMixin(S, options) end

--[[-----------------------------------------------------------------------------
Instance Methods
-------------------------------------------------------------------------------]]
--- @class OptionsTitanPanel : OptionsTitanPanelMixin
local o = S

--- Called Automatically by CreateAndInitFromMixin
--- @private
--- @param options Options
function o:Init(options)
  self.util = options.util
  self.order = options.order
end

--- The General > Titan Panel tab; greyed out without Titan Panel
--- @return AceConfigOption
function o:CreateTab()
  return {
    type = 'group',
    name = L['Titan Panel'],
    order = self.order:next(),
    -- A function: Titan may load after us, so check on each build
    disabled = function() return not API:IsTitanPanelAvailable() end,
    args = self:CreateOptions(),
  }
end

--- @return table<string, AceConfigOption>
function o:CreateOptions()
  local order, util = self.order, self.util
  local minimap = ns:minimap()
  local titan = minimap.titan_panel
  local options = {}

  local function HideIconGet() return minimap.hide_when_titan_panel_added == true end
  local function HideIconSet(_, v)
    minimap.hide_when_titan_panel_added = (v == true)
    self:SendMessage(MSG.OnToggleMinimapIconTitanPanel, libName)
  end
  local function OutOfSyncGet() return titan.show_out_of_sync_count == true end
  local function OutOfSyncSet(_, v)
    titan.show_out_of_sync_count = (v == true)
    self:SendMessage(MSG.OnUpdateMinimapState, libName)
  end
  local function ProfileNameGet() return titan.show_profile_name == true end
  local function ProfileNameSet(_, v)
    titan.show_profile_name = (v == true)
    options.maxProfileName.disabled = not titan.show_profile_name
    self:SendMessage(MSG.OnUpdateMinimapState, libName)
  end

  options.hideMinimapIcon = util:SettingsCheckbox(
    'Hide Minimap Icon TitanPanel',
    order:next(),
    HideIconGet,
    HideIconSet
  )
  options.showOutOfSyncCount = util:SettingsCheckbox(
    'Show Out of Sync Count',
    order:next(),
    OutOfSyncGet,
    OutOfSyncSet
  )
  options.showProfileName = util:SettingsCheckbox(
    'Show Profile Name',
    order:next(),
    ProfileNameGet,
    ProfileNameSet
  )
  options.maxProfileName = self:CreateMaxProfileName(order:next(), not ProfileNameGet())
  return options
end

--- @param order number
--- @param disabled boolean
--- @return AceConfigOption
function o:CreateMaxProfileName(order, disabled)
  local titan = ns:minimap().titan_panel
  return self.util:SettingsRow('Limit Profile Name Characters', {
    disabled = disabled,
    type = 'range',
    dialogControl = StepperSlider.Type,
    order = order,
    step = 1,
    min = 1,
    max = 50,
    softMin = 5,
    softMax = 20,
    get = function() return titan.profile_name_max_chars end,
    set = function(_, v)
      titan.profile_name_max_chars = v
      self:SendMessage(MSG.OnUpdateMinimapState, libName)
    end,
  })
end
