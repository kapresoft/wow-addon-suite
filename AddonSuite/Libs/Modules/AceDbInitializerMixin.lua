--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type ADS_Namespace
local ns = select(2, ...)

local GC, M, MSG = ns.GC, ns.M, ns.GC.M
local AceDB, AceEvent = ns:AceDB(), ns:AceEvent()

--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
--- @type string
local libName = M.AceDbInitializerMixin()

--- @class AceDbInitializerMixin
--- @field addon AddonSuite
local S = ns:Register(libName, {})

--[[-----------------------------------------------------------------------------
Support Function
-------------------------------------------------------------------------------]]

--- @param a AddonSuite
local function AddonCallbackMethods(a)
  function a:OnNewProfile(evt, db, profileKey)
    AceEvent:SendMessage(MSG.OnProfileCreated, libName, profileKey)
  end
  function a:OnProfileChanged(evt, db, profileKey)
    AceEvent:SendMessage(MSG.OnProfileChanged, libName, profileKey)
  end
  function a:OnProfileDeleted(evt, db, profileKey)
    AceEvent:SendMessage(MSG.OnProfileDeleted, libName, profileKey)
  end
  function a:OnProfileCopied() end
  function a:OnProfileReset() end

  ns:db().RegisterCallback(a, 'OnNewProfile', 'OnNewProfile')
  ns:db().RegisterCallback(a, 'OnProfileChanged', 'OnProfileChanged')
  ns:db().RegisterCallback(a, 'OnProfileCopied', 'OnProfileCopied')
  ns:db().RegisterCallback(a, 'OnProfileReset', 'OnProfileReset')
  ns:db().RegisterCallback(a, 'OnProfileDeleted', 'OnProfileDeleted')
end

--[[-----------------------------------------------------------------------------
Library Methods
-------------------------------------------------------------------------------]]

--- Usage:  local instance = AceDbInitializerMixin:New(addon)
--- @param addon AddonSuite
--- @return AceDbInitializer
function S:New(addon) return CreateAndInitFromMixin(S, addon) end

--- @class AceDbInitializer
local o = S

--- Called by CreateAndInitFromMixin(..) Automatically
--- @param addon AddonSuite
function o:Init(addon)
  assert(type(addon) == 'table', 'AddonSuite is required')
  self.addon = addon
  self.addon.db = AceDB:New(GC.C.DB_NAME)
  self.addon.dbInit = self
  ns:SetAddOnFn(function() return self.addon.db end)
end

--- @return AceDBObject-3.0
function o:GetDB() return self.addon.db end

function o:InitDb()
  AddonCallbackMethods(self.addon)
  self:InitDbDefaults()
end

function o:InitDbDefaults()
  ns:db():RegisterDefaults(ns.DefaultAddOnDatabase)
  ns:db().profile.enable = true
end
