--[[-----------------------------------------------------------------------------
HelpTour: the settings dialog's LibHelpTour controller.

Keeps the saved fields AddonSuite used before the library, so existing users
don't see tours again. The tip is parented to UIParent and drawn above the
settings dialog, whose AceGUI frame is pooled and reused.
@see TourList.lua
-------------------------------------------------------------------------------]]
--- @type ADS_Namespace
local ns = select(2, ...)
local L = ns:GetLocale()
local HelpTourList = ns.O.HelpTourList
local HelpTourLib = LibStub('LibHelpTour-1.0')

local libName = ns.M.HelpTour()
local o = HelpTourLib:New({
  tours = HelpTourList,
  dismissed = function() return ns:g().helpTipsDismissed end,
  getBaseline = function() return ns:g().tourBaseline end,
  setBaseline = function(baseline) ns:g().tourBaseline = baseline end,
  text = function(textKey) return L[textKey] end,
  skipTextKey = 'Skip Tour',
  tipParent = function() return UIParent end,
  tipStrata = 'FULLSCREEN_DIALOG',
})
ns:Register(libName, o)
