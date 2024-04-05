--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace
local ns = select(2, ...)
local O, GC, M = ns.O, ns.GC, ns.M
local Ace, LibStub = ns.KO().AceLibrary.O, ns.LibStub
local E, MSG, L = GC.E, GC.M, ns:AceLocale()
local API = O.API

--[[-----------------------------------------------------------------------------
Lua Vars
-------------------------------------------------------------------------------]]
local sformat = string.format

--[[-----------------------------------------------------------------------------
Blizzard Vars
-------------------------------------------------------------------------------]]
local CreateFrame, FrameUtil = CreateFrame, FrameUtil
local RegisterFrameForEvents, RegisterFrameForUnitEvents = FrameUtil.RegisterFrameForEvents, FrameUtil.RegisterFrameForUnitEvents

--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
local libName = 'MainController'
--- @class MainController
local S = ns:NewLibWithEvent(libName)
local p = ns:CreateDefaultLogger(libName)
local pp = ns:CreateDefaultLogger(ns.name)

--[[-----------------------------------------------------------------------------
Support Functions
-------------------------------------------------------------------------------]]
local function OnPlayerEnteringWorld(msg, source, ...)
    local isLogin, isReload = ...

    S:OnAddOnReady()

    --@debug@
    isLogin = true
    p:d(function() return "IsLogin=%s IsReload=%s", tostring(isLogin), tostring(isReload) end)
    --@end-debug@

    if not isLogin then return end

    pp:vv(GC:GetMessageLoadedText())
end

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
--- @param o MainController | AceEvent
local function PropsAndMethods(o)

    function o.OnAfterInitialize()
        o:RegisterMessage(GC.toMsg(E.PLAYER_ENTERING_WORLD), OnPlayerEnteringWorld)
        o:RegisterMessage(MSG.OnAddOnReady, o.OnAfterOnAddOnReady)
    end

    function o:OnAddOnReady()
        O.MinimapIconController:New(self):InitMinimapIcon()
        S:SendMessage(MSG.OnAddOnReady)
    end

    function o.OnAfterOnAddOnReady()
        C_Timer.After(0.01, function() S:SendMessage(MSG.OnAfterOnAddOnReady) end)
    end

    o:RegisterMessage(MSG.OnAfterInitialize, o.OnAfterInitialize)

end; PropsAndMethods(S)
