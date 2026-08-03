--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type ADS_Namespace
local ns = select(2, ...)
local O, GC, M = ns.O, ns.GC, ns.M
local API = O.API
--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
local libName = 'Developer'
--- @class Developer
local o = {}
das = o
local p, t = ns:log(libName)

C_Timer.After(1, function() t('loaded...') end)

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
function o:en(nameOrIndex) return API:IsAddOnEnabled(nameOrIndex) end

-- Can Be Enabled
function o:cbe(addon)
  local info = O.API:GetDependencyDetails(addon)
  return info:CanBeEnabled()
end
