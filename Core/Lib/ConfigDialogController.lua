--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace
local ns = select(2, ...)
local O, MS = ns.O, ns.GC.M
local AceConfigDialog = ns:AceConfigDialog()
--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
local libName = ns.M.ConfigDialogController()
--- @class ConfigDialogController
local S = ns:NewLibWithEvent(libName)
local p = ns:CreateDefaultLogger(libName)

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
--- @type ConfigDialogController | AceEventInterface
local o = S

function o.OnAddOnReady() o:CreateDialogEventFrame() end

function o:CreateDialogEventFrame()
    local frameName = ns.sformat("%s_%sEventFrame", ns.name, libName)
    --- @type _Frame
    local f = CreateFrame("Frame", frameName, UIParent, "SecureHandlerStateTemplate")
    f:Hide()
    f:SetScript("OnHide", function(self)
        if not AceConfigDialog.OpenFrames[ns.name] then return end
        AceConfigDialog:Close(ns.name)
    end)
    self.dialogEventFrame = f
    RegisterStateDriver(self.dialogEventFrame, "visibility", "[combat]hide;show")
end

o:RegisterMessage(MS.OnAddOnReady, o.OnAddOnReady)


