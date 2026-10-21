--[[-----------------------------------------------------------------------------
HelpTour: picks which tour step a host dialog's help tip shows.

One tour per session: the first eligible tour with unseen steps owns the
session until /reload, even after it finishes. A step's close button or
its action (CompleteStep) advances to the next step.
@see TourList.lua
-------------------------------------------------------------------------------]]
--- @type ADS_Namespace
local ns = select(2, ...)

--- @class ADS_HelpTourStep
--- @field key string                       @Key in global.helpTipsDismissed
--- @field textKey string                   @Locale key of the step text
--- @field anchor fun(host: table): Region? @Step is skipped while this is nil or hidden

--- @class ADS_HelpTourDef
--- @field id string
--- @field host string           @Host name passed to OnHostShown
--- @field since number?         @Feature tours only; nil means always eligible
--- @field steps ADS_HelpTourStep[]

--- @class ADS_HelpTourShowing
--- @field hostName string
--- @field host table @Frame or AceGUI widget
--- @field tip ADS_HelpTip
--- @field step ADS_HelpTourStep

--[[-----------------------------------------------------------------------------
Support Functions
-------------------------------------------------------------------------------]]
--- @type ADS_HelpTourDef?
local sessionTour
--- @type ADS_HelpTourShowing?
local showing

--- @return table<string, boolean>
local function Dismissed() return ns:g().helpTipsDismissed end

--- @return number
local function HighestSince()
  local highest = 0
  for _, tour in ipairs(ns.O.HelpTourList) do
    highest = math.max(highest, tour.since or 0)
  end
  return highest
end

--- Saved on the first open, so new users skip older feature tours.
--- @return number
local function Baseline()
  local g = ns:g()
  if not g.tourBaseline then g.tourBaseline = HighestSince() end
  return g.tourBaseline
end

--- @param tour ADS_HelpTourDef
--- @return boolean
local function IsEligible(tour) return tour.since == nil or tour.since > Baseline() end

--- @param tour ADS_HelpTourDef
--- @return boolean
local function HasUnseenStep(tour)
  for _, step in ipairs(tour.steps) do
    if not Dismissed()[step.key] then return true end
  end
  return false
end

--- @param tour ADS_HelpTourDef
--- @param host table
--- @return number? @nil if every unseen step's anchor is missing or hidden
local function FirstShowableStep(tour, host)
  for index, step in ipairs(tour.steps) do
    if not Dismissed()[step.key] then
      local anchor = step.anchor(host)
      if anchor and anchor:IsVisible() then return index end
    end
  end
end

--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
local libName = ns.M.HelpTour()
--- @class ADS_HelpTour
local o = {}; ns:Register(libName, o)

--- @param hostName string
--- @return ADS_HelpTourDef? @nil if another host's tour owns the session, or none is left
function o:SessionTour(hostName)
  if not sessionTour then
    for _, tour in ipairs(ns.O.HelpTourList) do
      if tour.host == hostName and IsEligible(tour) and HasUnseenStep(tour) then
        sessionTour = tour
        break
      end
    end
  end
  return sessionTour and sessionTour.host == hostName and sessionTour or nil
end

--- Call from the host's OnShow; shows its next step or hides the tip.
--- @param hostName string
--- @param host table
--- @param tip ADS_HelpTip
function o:OnHostShown(hostName, host, tip)
  local tour = self:SessionTour(hostName)
  local index = tour and FirstShowableStep(tour, host)
  if not index then
    showing = nil
    tip:Hide()
    return
  end
  local step = tour.steps[index]
  showing = { hostName = hostName, host = host, tip = tip, step = step }
  tip.onClose = function() self:CompleteStep(step.key) end
  tip:ShowStep(step.textKey, step.anchor(host), index, #tour.steps)
end

--- Marks a step done, e.g. when the user does what it points at;
--- advances if it's the step on screen.
--- @param key string
function o:CompleteStep(key)
  Dismissed()[key] = true
  if not (showing and showing.step.key == key) then return end
  self:OnHostShown(showing.hostName, showing.host, showing.tip)
end

--- Hides the tip when its host goes away, e.g. a released dialog.
--- @param host table
function o:OnHostHidden(host)
  if not (showing and showing.host == host) then return end
  showing.tip:Hide()
  showing = nil
end
