--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]

--- @type ADS_Namespace
local ns     = select(2, ...)
local O, GC  = ns.O, ns.GC
local E, MSG, toMsg = GC.E, GC.M, GC.toMsg

--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
local libName = ns.M.MainController()
--- @class MainController : AceEvent-3.0
local o  = ns:Register(libName, ns:NewAceEvent())

local p, t = ns:log(libName)

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]

function o:PLAYER_ENTERING_WORLD(evt, ...)
    local isLogin, isReload = ...

    self:OnAddOnReady()

    --@do-not-package@
    if ns:IsDev() then
        isLogin = true
        ns.printer(("IsLogin=%s IsReload=%s LogLevel=%s"):format(tostring(isLogin),
              tostring(isReload), ADDON_SUITE_LOG_LEVEL))
    end
    --@end-do-not-package@

    if not isLogin then return end

    ns.printer(ns:GetMessageLoadedText())
end

function o:OnAddOnReady()
  O.MinimapIconControllerMixin:New(self):InitMinimapIcon()
  o:SendMessage(MSG.OnAddOnReady)
  C_Timer.After(0.5, function() o:SendMessage(MSG.OnAfterOnAddOnReady, libName) end)
end

o:RegisterEvent('PLAYER_ENTERING_WORLD')
