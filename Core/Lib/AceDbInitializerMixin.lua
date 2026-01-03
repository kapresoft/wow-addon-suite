--[[-----------------------------------------------------------------------------
Type: AceDbInitializer
-------------------------------------------------------------------------------]]
--- @class AceDbInitializer

--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace
local ns = select(2, ...)

local GC, M, LibStub, MSG = ns.GC, ns.M, ns.LibStub, ns.GC.M
local AceDB, AceEvent     = ns:AceDB(), ns:AceEvent()

--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
local libName = M.AceDbInitializerMixin()

--- @class AceDbInitializerMixin
local S = LibStub:NewLibrary(libName); if not S then return end
local p = ns:LC().DB:NewLogger(libName)

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
--- @param a AddonSuite
local function AddonCallbackMethods(a)
    function a:OnNewProfile(evt, db, profileKey)
        p:d('OnNewProfile called...')
        AceEvent:SendMessage(MSG.OnProfileCreated, libName, profileKey)
    end
    function a:OnProfileChanged(evt, db, profileKey)
        p:d('OnProfileChanged called...')
        AceEvent:SendMessage(MSG.OnProfileChanged, libName, profileKey)
    end
    function a:OnProfileDeleted(evt, db, profileKey)
        p:d('OnProfileDeleted called...key=' .. profileKey)
        AceEvent:SendMessage(MSG.OnProfileDeleted, libName, profileKey)
    end
    function a:OnProfileCopied()
        p:d('OnProfileCopied called...')
    end
    function a:OnProfileReset()
        p:d('OnProfileReset called...')
    end

    ns:db().RegisterCallback(a, "OnNewProfile", "OnNewProfile")
    ns:db().RegisterCallback(a, "OnProfileChanged", "OnProfileChanged")
    ns:db().RegisterCallback(a, "OnProfileCopied", "OnProfileCopied")
    ns:db().RegisterCallback(a, "OnProfileReset", "OnProfileReset")
    ns:db().RegisterCallback(a, "OnProfileDeleted", "OnProfileDeleted")
end

--[[-----------------------------------------------------------------------------
Library Methods
-------------------------------------------------------------------------------]]
--- @type AceDbInitializerMixin
local LIB = S

--- Usage:  local instance = AceDbInitializerMixin:New(addon)
--- @param addon AddonSuite
--- @return AceDbInitializer
function LIB:New(addon) return ns:K():CreateAndInitFromMixin(S, addon) end

--[[-----------------------------------------------------------------------------
Instance Methods
-------------------------------------------------------------------------------]]
--- @type AceDbInitializer
local o = S

--- Called by CreateAndInitFromMixin(..) Automatically
--- @param addon AddonSuite
function o:Init(addon)
    assert(addon, "AddonSuite is required")
    self.addon = addon
    self.addon.db = AceDB:New(GC.C.DB_NAME)
    self.addon.dbInit = self
    ns:SetAddOnFn(function() return self.addon.db end)
end

--- @return AceDB
function o:GetDB() return self.addon.db end

function o:InitDb()
    p:f1( 'Initialize called...')
    AddonCallbackMethods(self.addon)
    self:InitDbDefaults()
end

function o:InitDbDefaults()
    ns:db():RegisterDefaults(ns.DefaultAddOnDatabase)
    ns:db().profile.enable = true
    p:i(function() return 'Profile: %s', ns:db():GetCurrentProfile() end)
end
