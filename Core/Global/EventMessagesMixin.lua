--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace
local ns = select(2, ...)
local K, O, GC = ns:K(), ns.O, ns.GC
local MSG = GC.M
--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
local libName = 'EventMessagesMixin'
--- @class EventMessagesMixin
local S = {}; ns.O[libName] = S

--[[-----------------------------------------------------------------------------
Mixin Methods
-------------------------------------------------------------------------------]]
--- @type EventMessagesMixin
local o = S

---@param obj any
function o:Mixin(obj) K:MixinWithDefExc(obj, o) end

--- @param callbackFn fun() | 'function() print("hello") end'
function o:OnAddOnStartLoad(callbackFn)
    self:AceEvent():RegisterMessage(GC.M.OnAddOnStartLoad, callbackFn)
end
--- @param callbackFn fun() | 'function() print("hello") end'
function o:OnBeforeInitialize(callbackFn)
    self:AceEvent():RegisterMessage(GC.M.OnBeforeInitialize, callbackFn)
end
--- @param callbackFn fun() | 'function() print("hello") end'
function o:OnAfterInitialize(callbackFn)
    self:AceEvent():RegisterMessage(GC.M.OnAfterInitialize, callbackFn)
end
