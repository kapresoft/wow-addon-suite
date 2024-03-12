--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace
local ns = select(2, ...)
local O, GC, M, LibStub, KO = ns.O, ns.GC, ns.M, ns.LibStub, ns:KO()
local AceDB = O.AceLibrary.AceDB
local IsEmptyTable = KO.Table.isEmpty

--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
--- @class AceDbInitializerMixin : BaseLibraryObject
local L = LibStub:NewLibrary(M.AceDbInitializerMixin)
local p = ns:LC().DB:NewLogger(M.AceDbInitializerMixin)

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
--- @param a AddonSuite
local function AddonCallbackMethods(a)
    function a:OnProfileChanged()
        p:d('OnProfileChanged called...')
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
        self:InitDbDefaults()
    end

    function o:InitDbDefaults()
        local profileName = self.addon.db:GetCurrentProfile()
        --- @type Profile_Config
        local defaultProfile = {
            enable = true,
            enabledAddons = {
                ['Ace3'] = true,
                ['Questie'] = true,
                ['VuhDo'] = true,
                ['VuhDoOptions'] = true,
                ['TomTom'] = true,
            }
        }
        local defaults = { profile = defaultProfile }
        ns:db():RegisterDefaults(defaults)
        self.addon.profile = ns:db().profile
        local wowDB = _G[GC.C.DB_NAME]
        if IsEmptyTable(wowDB.profiles[profileName]) then wowDB.profiles[profileName] = defaultProfile end
        self.addon.profile.enable = true
        p:i(function() return 'Profile: %s', ns:db():GetCurrentProfile() end)
    end
end; PropsAndMethods(L)
