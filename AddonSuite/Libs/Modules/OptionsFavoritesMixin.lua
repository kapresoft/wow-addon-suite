--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type ADS_Namespace
local ns = select(2, ...)
local M, MSG = ns.M, ns.GC.M
local ACU = ns:ACU()
local L = ns:GetLocale()
local sformat = ns.sformat

-- Keeps profile names apart from the tab's other option keys
local PROFILE_KEY_PREFIX = 'profile:'

--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
local libName = M.OptionsFavoritesMixin()
--- @class OptionsFavoritesMixin : AceEvent-3.0
local S = ns:Register(libName, ns:NewAceEvent())

--[[-----------------------------------------------------------------------------
Library Methods
-------------------------------------------------------------------------------]]
--- @public
--- @param options Options
--- @return OptionsFavorites
function S:New(options) return CreateAndInitFromMixin(S, options) end

--[[-----------------------------------------------------------------------------
Instance Methods
-------------------------------------------------------------------------------]]
--- @class OptionsFavorites : OptionsFavoritesMixin
local o = S

--- Called Automatically by CreateAndInitFromMixin
--- @private
--- @param options Options
function o:Init(options)
  self.util = options.util
  self.order = options.order
end

--- The General > Favorite Profiles tab
--- @return AceConfigOption
function o:CreateTab()
  --- @type table<string, AceConfigOption>
  local args = {
    desc = ACU:CreateLabel('Favorite Profiles::Desc', { order = 1 }),
    spacer = ACU:CreateSpacer(2),
  }
  self.args = args
  self:CreateToggles()
  self:RegisterCallbacks()

  return { type = 'group', name = L['Favorite Profiles'], order = self.order:next(), args = args }
end

--- @return string[]
local function SortedProfileKeys()
  local keys = ns:db():GetProfiles()
  table.sort(keys)
  return keys
end

--- @param pkey string
--- @return string
local function CurrentProfileLabel(pkey)
  local cfn = ns:ColorFn(L['Current Profile Color'])
  return cfn(sformat('%s %s', pkey, L['Current::Symbol::Options']))
end

function o:RemoveToggles()
  for key in pairs(self.args) do
    if key:find(PROFILE_KEY_PREFIX, 1, true) == 1 then self.args[key] = nil end
  end
end

function o:CreateToggles()
  self:RemoveToggles()
  local current = ns:db():GetCurrentProfile()
  for index, pkey in ipairs(SortedProfileKeys()) do
    --- @type AceConfigOption
    local toggle = {
      name = pkey,
      type = 'toggle',
      width = 1.3,
      order = 2 + index,
      get = self.util:ProfileMenuCheckboxGetFn(pkey),
      set = self.util:ProfileMenuCheckboxSetFn(pkey),
    }
    if pkey == current then
      toggle.name = CurrentProfileLabel(pkey)
      toggle.desc = 'This is the current profile.'
    end
    self.args[PROFILE_KEY_PREFIX .. pkey] = toggle
  end
end

--- @param deletedProfileKey string
function o:OnProfileDeleted(deletedProfileKey)
  ns:db().char.showInQuickProfileMenu[deletedProfileKey] = nil
  self:CreateToggles()
end

--- AceDB also fires OnProfileChanged on profile creation and deletion
function o:RegisterCallbacks()
  self:RegisterMessage(
    MSG.OnProfileCreated,
    function(_, _, newProfileKey) ns:db().char.showInQuickProfileMenu[newProfileKey] = true end
  )
  self:RegisterMessage(MSG.OnProfileChanged, function() self:CreateToggles() end)
  self:RegisterMessage(
    MSG.OnProfileDeleted,
    function(_, _, deletedProfileKey) self:OnProfileDeleted(deletedProfileKey) end
  )
end
