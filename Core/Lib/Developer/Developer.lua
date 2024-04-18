--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace
local ns = select(2, ...)
local O, GC, M = ns.O, ns.GC, ns.M
local libName = 'Developer'
--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
--- @class Developer
local L = {}
local p = ns:CreateDefaultLogger(libName)

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
---@param o Developer
local function PropsAndMethods(o)
    local a = O.API
    local am = O.AddOnManager
    function o:en(nameOrIndex) return a:IsAddOnEnabled(nameOrIndex) end

    function o:pa(addon)
        local ai = am:New(addon)
        local enabled = a:IsAddOnEnabled(addon)
        local loaded = a:IsAddOnLoaded(addon)
        local info = am.GetAddOnInfo(addon)
        info.title = nil
        info.notes = nil
        p:vv(function()
            return "AddOn[%s]:\nEnabled=%s Loaded=%s deps=%s deps-en=%s Info=%s",
                        addon, enabled, loaded, ai.dependencies, ai.dependencyEnabled, info end)
    end

    function o:r()
        self:pa('Bagnon')
        self:pa('Bagnon_Scrap')
        self:pa('Bagnon_Config')
        self:pa('WeakAurasArchive')
    end

end; PropsAndMethods(L); d = L
