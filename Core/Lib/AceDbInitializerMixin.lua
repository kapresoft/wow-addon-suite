--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace
local ns = select(2, ...)
local O, GC, M, LibStub, KO = ns.O, ns.GC, ns.M, ns.LibStub, ns:KO()
local AceDB = O.AceLibrary.AceDB
local libName = M.AceDbInitializerMixin
--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
--- @class AceDbInitializerMixin : BaseLibraryObject
local L = LibStub:NewLibrary(libName); if not L then return end
local p = ns:LC().DB:NewLogger(libName)
local AceEvent = ns:AceEvent()
--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
--- @param a AddonSuite
local function AddonCallbackMethods(a)
    function a:OnProfileChanged(evt, db, profileKey)
        p:d('OnProfileChanged called...')
        AceEvent:SendMessage(GC.M.OnProfileChanged, libName, profileKey)
    end
    function a:OnProfileDeleted(evt, db, profileKey)
        p:d('OnProfileDeleted called...key=' .. profileKey)
        AceEvent:SendMessage(GC.M.OnProfileDeleted, libName, profileKey)
    end
    function a:OnProfileCopied()
        p:d('OnProfileCopied called...')
    end
    function a:OnProfileReset()
        p:d('OnProfileReset called...')
    end
end

--- @param o AceDbInitializerMixin
local function PropsAndMethods(o)

    --- Called by CreateAndInitFromMixin(..) Automatically
    --- @param addon AddonSuite
    function o:Init(addon)
        assert(addon, "AddonSuite is required")
        self.addon = addon
        self.addon.db = AceDB:New(GC.C.DB_NAME)
        self.addon.dbInit = self
        ns:SetAddOnFn(function() return self.addon.db end)
    end

    --- Usage:  local instance = AceDbInitializerMixin:New(addon)
    --- @param addon AddonSuite
    --- @return AceDbInitializerMixin
    function o:New(addon) return ns:K():CreateAndInitFromMixin(o, addon) end

    --- @return AceDB
    function o:GetDB() return self.addon.db end

    function o:InitDb()
        p:f1( 'Initialize called...')
        AddonCallbackMethods(self.addon)
        ns:db().RegisterCallback(self.addon, "OnProfileChanged", "OnProfileChanged")
        ns:db().RegisterCallback(self.addon, "OnProfileCopied", "OnProfileCopied")
        ns:db().RegisterCallback(self.addon, "OnProfileReset", "OnProfileReset")
        ns:db().RegisterCallback(self.addon, "OnProfileDeleted", "OnProfileDeleted")
        self:InitDbDefaults()
    end

    function o:InitDbDefaults()
        ns:db():RegisterDefaults(ns.DefaultAddOnDatabase)
        ns:db().profile.enable = true
        p:i(function() return 'Profile: %s', ns:db():GetCurrentProfile() end)
    end
end; PropsAndMethods(L)
