--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace
local ns = select(2, ...)
local O, GC, M = ns.O, ns.GC, ns.M
local API = O.API
--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
local libName = 'Developer'
--- @class Developer
local L = {}
local p = ns:CreateDefaultLogger(libName)

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
---@param o Developer
local function PropsAndMethods(o)

    function o:en(nameOrIndex) return API:IsAddOnEnabled(nameOrIndex) end

    -- Can Be Enabled
    function o:cbe(addon)
        local info = O.API:GetDependencyDetails(addon)
        return info:CanBeEnabled()
    end

end; PropsAndMethods(L); das = L
