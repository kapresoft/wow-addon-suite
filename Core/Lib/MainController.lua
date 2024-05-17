--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace
local ns     = select(2, ...)
local O, GC  = ns.O, ns.GC
local E, MSG, toMsg = GC.E, GC.M, GC.toMsg

--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
local libName = ns.M.MainController()
--- @class MainController
local S  = ns:NewLibWithEvent(libName)
local p  = ns:CreateDefaultLogger(libName)
local pp = ns:CreateDefaultLogger(ns.name)

--[[-----------------------------------------------------------------------------
Support Functions
-------------------------------------------------------------------------------]]
local function OnPlayerEnteringWorld(msg, source, ...)
    local isLogin, isReload = ...

    S.OnAddOnReady()

    --@do-not-package@
    if ns:IsDev() then
        isLogin = true
        p:vv(function()
            return "IsLogin=%s IsReload=%s LogLevel=%s", isLogin, isReload, ADDON_SUITE_LOG_LEVEL end)
    end
    --@end-do-not-package@

    if not isLogin then return end

    pp:a(GC:GetMessageLoadedText())
end

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
--- @type MainController | AceEventInterface
local o = S

function o.OnAddOnReady()
    O.MinimapIconControllerMixin:New(self):InitMinimapIcon()
    o:SendMessage(MSG.OnAddOnReady)
    C_Timer.After(0.5, function() o:SendMessage(MSG.OnAfterOnAddOnReady, libName) end)
end

o:RegisterMessage(toMsg(E.PLAYER_ENTERING_WORLD), OnPlayerEnteringWorld)

