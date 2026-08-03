--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type ADS_Namespace
local ns = select(2, ...)
local MSG = ns.GC.M
local AceEvent = LibStub('AceEvent-3.0')
--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
local libName = 'EventMessagesMixin'
--- @class EventMessagesMixin : AceEvent-3.0
local S = {}; ns.O[libName] = S
AceEvent:Embed(S)

--[[-----------------------------------------------------------------------------
Mixin Methods
-------------------------------------------------------------------------------]]
local o = S

--- Create a new instance of AceEvent or embed to an obj if passed
--- @return AceEvent-3.0
function o:E() return AceEvent:Embed({}) end

--- @param obj any
function o:Mixin(obj) Mixin(obj, o) end

--- @param callbackFn fun() | 'function() print("hello") end'
function o:OnAddOnReady(callbackFn) self:E():RegisterMessage(MSG.OnAddOnReady, callbackFn) end

--- @param callbackFn fun() | 'function() print("hello") end'
function o:OnAddOnEnabled(callbackFn) self:E():RegisterMessage(MSG.OnAddOnEnabled, callbackFn) end

--- @param callbackFn fun() | 'function() print("hello") end'
function o:OnBeforeInitialize(callbackFn) self:E():RegisterMessage(MSG.OnBeforeInitialize, callbackFn) end
--- @param callbackFn fun() | 'function() print("hello") end'
function o:OnAfterInitialize(callbackFn) self:E():RegisterMessage(MSG.OnAfterInitialize, callbackFn) end
