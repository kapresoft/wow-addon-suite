--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace
local ns     = select(2, ...)
local O, GC  = ns.O, ns.GC
local E, MSG = GC.E, GC.M

--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
local libName = 'MainController'
--- @class MainController
local S  = ns:NewLibWithEvent(libName)
local p  = ns:CreateDefaultLogger(libName)
local pp = ns:CreateDefaultLogger(ns.name)

--[[-----------------------------------------------------------------------------
Support Functions
-------------------------------------------------------------------------------]]
local function OnPlayerEnteringWorld(msg, source, ...)
    local isLogin, isReload = ...

    S:OnAddOnReady()

    --@do-not-package@
    if ns.debug:IsDeveloper() then
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
