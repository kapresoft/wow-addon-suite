--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type ADS_Namespace
local ns = select(2, ...)
local O, MS = ns.O, ns.GC.M
local AceConfigDialog = ns:AceConfigDialog()

--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
local libName = ns.M.ConfigDialogController()
--- @class ConfigDialogController
local o = ns:Register(libName, {})
local p, t = ns:log(libName)

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]

function o:CreateDialogEventFrame()
  local frameName = ns.sformat('%s_%sEventFrame', ns.addon, libName)
  --- @type Frame
  local f = CreateFrame('Frame', frameName, UIParent, 'SecureHandlerStateTemplate')
  f:Hide()
  f:SetScript('OnHide', function(self)
    if not AceConfigDialog.OpenFrames[ns.addon] then return end
    AceConfigDialog:Close(ns.addon)
  end)
  self.dialogEventFrame = f
  RegisterStateDriver(self.dialogEventFrame, 'visibility', '[combat]hide;show')
end

ns:OnAddOnReady(function() o:CreateDialogEventFrame() end)
