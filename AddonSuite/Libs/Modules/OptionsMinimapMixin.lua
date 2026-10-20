--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type ADS_Namespace
local ns = select(2, ...)
local M, MSG = ns.M, ns.GC.M
local L = ns:GetLocale()
local sformat = ns.sformat

--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
local libName = M.OptionsMinimapMixin()
--- @class OptionsMinimapMixin : AceEvent-3.0
local S = ns:Register(libName, ns:NewAceEvent())
local p, t = ns:log(libName)

--[[-----------------------------------------------------------------------------
Support Functions
-------------------------------------------------------------------------------]]
local function h1(header) return '     ' .. header .. '     ' end
local sp = '                                                                   '

--[[-----------------------------------------------------------------------------
Library Methods
-------------------------------------------------------------------------------]]

--- @public
--- @param optionsMixin OptionsMixin
--- @param order Kapresoft_LibUtil_SequenceMixin
--- @return OptionsMinimap
function S:New(optionsMixin, order) return CreateAndInitFromMixin(S, optionsMixin, order) end

--[[-----------------------------------------------------------------------------
Instance Methods
-------------------------------------------------------------------------------]]
--- @class OptionsMinimap : AceEvent-3.0
local o = S

--- Called Automatically by CreateAndInitFromMixin
--- @private
--- @param options Options
function o:Init(options)
  self.mainOptions = options
  self.util = options.util
  self.order = options.order
  self.startingOrder = self.order:get()
end

--- @return AceConfigOption
function o:CreateOptions()
  --- @type AceConfigOption
  local options = {}; self.options = options

  --- @type AceConfigOption
  local group = {
    type = 'group',
    name = L['Minimap'],
    desc = L['Minimap::Desc'],
    order = self.order:next(),
    args = self:CreateSubGroup(),
  }
  return group
end

--- @return AceConfigOption
function o:CreateSubGroup()
  local options = self.options
  local order = self.order

  --- @type AceConfigOption
  options.h3 = {
    type = 'header',
    name = h1(L['Favorite Profiles']),
    descStyle = 'inline',
    order = order:next(),
  }
  options.spacer2 = { type = 'description', name = sp, width = 'full', order = order:next() }
  options.desc1 = {
    type = 'description',
    name = L['Favorite Profiles::Desc'],
    fontSize = 'medium',
    order = order:next(),
  }
  options.spacer3 = { type = 'description', name = sp, width = 'full', order = order:next() }

  self.startingOrder = order:get()
  self:CreateToggles(options)
  self:RegisterCallbacks()

  return options
end

function o:GetProfileKeys()
  local keys = {}
  for name in pairs(ns:db().profiles) do
    table.insert(keys, name)
  end
  local currentProfile = ns:db():GetCurrentProfile()
  if not self.options[currentProfile] then table.insert(keys, currentProfile) end
  table.sort(keys, function(a, b) return a < b end)
  return keys
end

function o:CreateToggles()
  local options = self.options
  local currentColor = L['Current Profile Color']
  local currentSymbol = L['Current::Symbol::Options']

  -- reset each time we re-create
  self.order:Init(self.startingOrder)

  local profileKeys = self:GetProfileKeys()
  for _, pkey in ipairs(profileKeys) do
    --- @type AceConfigOption
    local toggle = {
      name = pkey,
      type = 'toggle',
      width = 1.3,
      order = self.order:next(),
      get = self.util:ProfileMenuCheckboxGetFn(pkey),
      set = self.util:ProfileMenuCheckboxSetFn(pkey),
    }
    local current = ns:db():GetCurrentProfile()
    if pkey == current then
      --toggle.name = ns.ch:FormatColor(currentColor, sformat('%s %s', toggle.name, currentSymbol))
      local cfn = ns:ColorFn(currentColor)
      toggle.name = cfn(sformat('%s %s', toggle.name, currentSymbol))
      toggle.desc = 'This is the current profile.'
    end
    options[pkey] = toggle
  end
end

--- @param deletedProfileKey string
function o:OnProfileDeleted(deletedProfileKey)
  self.options[deletedProfileKey] = nil
  ns:db().char.showInQuickProfileMenu[deletedProfileKey] = nil
  self:CreateToggles()
end
--- Handles profile change and profile creation events. The OnNewProfile doesn't fire
--- Note: AceDb OnProfileChanged also gets fired during a delete (for reason I do not know yet)
---@param newProfile string
function o:OnProfileChanged(newProfile) self:CreateToggles() end

function o:RegisterCallbacks()
  --- Use "self" to register here so we have visibility to the instance
  --- @param evt string
  --- @param source string The source Event
  --- @param newProfileKey string
  self:RegisterMessage(
    MSG.OnProfileCreated,
    function(evt, source, newProfileKey) ns:db().char.showInQuickProfileMenu[newProfileKey] = true end
  )

  --- Use "self" to register here so we have visibility to the instance
  --- @param evt string
  --- @param source string The source Event
  --- @param newProfileKey string
  self:RegisterMessage(
    MSG.OnProfileChanged,
    function(evt, source, newProfileKey) self:OnProfileChanged(newProfileKey) end
  )

  --- Use "self" to register here so we have visibility to the instance
  --- @param evt string
  --- @param source string The source Event
  --- @param deletedProfileKey string
  self:RegisterMessage(
    MSG.OnProfileDeleted,
    function(evt, source, deletedProfileKey) self:OnProfileDeleted(deletedProfileKey) end
  )
end
