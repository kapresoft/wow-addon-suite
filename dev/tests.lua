--[[-----------------------------------------------------------------------------
For LuaDevKit Editor: run with AddonSuite's settings dialog open.

Drives the settings dialog's real welcome tour through its tip's own buttons.
Uses the real saved data: each test first clears the tour's dismissed steps.
TestSkip leaves the tour skipped; /reload, reopen the settings, then run
TestStaysSkipped.
-------------------------------------------------------------------------------]]
local ns = ADDON_SUITE_NS
local HelpTour = ns.O.HelpTour
local AceConfigDialog = LibStub('AceConfigDialog-3.0')
local tour = HelpTour.config.tours[1]

--- @param label string
--- @param ok boolean
local function Check(label, ok) print(ok and '|cff00ff00PASS|r' or '|cffff0000FAIL|r', label) end

local function ResetTour()
  local dismissed = ns:g().helpTipsDismissed
  for _, step in ipairs(tour.steps) do
    dismissed[step.key] = nil
  end
end

--- @return boolean
local function AllDismissed()
  local dismissed = ns:g().helpTipsDismissed
  for _, step in ipairs(tour.steps) do
    if not dismissed[step.key] then return false end
  end
  return true
end

--- Asks the tour for its next step, as the dialog's open hook does.
--- @param dialog table @The settings dialog's AceGUI frame
--- @return LibHelpTour_Tip? @nil until the tour first shows
local function ShowTour(dialog)
  HelpTour:OnTargetShown('Settings', dialog)
  return HelpTour.tip
end

--- Skip on every step but the last; Close walks to the end.
--- @param dialog table
local function TestWalk(dialog)
  ResetTour()
  local tip = ShowTour(dialog)
  Check('tip shows', tip ~= nil and tip:IsShown())
  if not tip then return end
  -- Bounded: a Close that fails to advance can't loop forever
  for _ = 1, #tour.steps do
    if not tip:IsShown() then break end
    local step = tip.Counter:GetText()
    local isLast = step:match('^(%d+)/%1$') ~= nil
    Check(step .. ': Skip ' .. (isLast and 'hidden' or 'shown'), tip.SkipButton:IsShown() ~= isLast)
    tip.CloseButton:Click()
  end
  Check('tour finished', not tip:IsShown())
  Check('every step dismissed', AllDismissed())
end

--- Skip hides the tip and dismisses every step.
--- @param dialog table
local function TestSkip(dialog)
  ResetTour()
  local tip = ShowTour(dialog)
  Check('Skip shown on the first step', tip ~= nil and tip.SkipButton:IsShown())
  if not tip then return end
  tip.SkipButton:Click()
  Check('tip hidden after Skip', not tip:IsShown())
  Check('every step dismissed', AllDismissed())
end

--- Run after TestSkip and a /reload: the skip was saved.
--- @param dialog table
local function TestStaysSkipped(dialog)
  Check('every step still dismissed', AllDismissed())
  local tip = ShowTour(dialog)
  Check('no tip on show', not (tip and tip:IsShown()))
end

local dialog = AceConfigDialog.OpenFrames[ns.addon]
Check('settings dialog open', dialog ~= nil)
if not dialog then return end

TestWalk(dialog)
--TestSkip(dialog)
--TestStaysSkipped(dialog)
