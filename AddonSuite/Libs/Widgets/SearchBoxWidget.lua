--[[-----------------------------------------------------------------------------
SearchBox Widget
A Blizzard search box (icon, placeholder, clear button) for live filtering.
Typing calls `arg.search.onChange` after a short pause instead of Ace's
`set`, which rebuilds the whole dialog and would drop the box's focus.
The box hangs under the widget's row, e.g. onto a tab strip that follows.
Use via `dialogControl = O.SearchBoxWidget.Type` on an 'input' option.
-------------------------------------------------------------------------------]]
--- @type ADS_Namespace
local ns = select(2, ...)
local AceGUI = ns:AceGUI()
local CONFIG = ns.O.Ace3WidgetConfig

local libName = ns.M.SearchBoxWidget()
--- @class ADS_SearchBoxWidget
local o = { Type = 'AddonSuite_SearchBox', Version = 1 }; ns:Register(libName, o)

local DEBOUNCE_SECONDS = 0.25

--- Frame times; one search box shows at a time, so shared by type
local releasedAt, focusLostAt

--[[-----------------------------------------------------------------------------
Support functions
-------------------------------------------------------------------------------]]
--- A rebuild releases and re-acquires the box in one frame:
--- only a box that lost focus to it takes focus back
--- @return boolean
local function IsNewViewOrHadFocus()
  local now = GetTime()
  return releasedAt ~= now or focusLostAt == now
end

--- Once per acquire; waits a frame so the box is shown
--- @param self table
local function TakeFocusOnShow(self)
  local search = CONFIG:SearchArg(self)
  if self.focusChecked or not search then return end
  self.focusChecked = true
  if not (search.focusOnShow and IsNewViewOrHadFocus()) then return end
  self.focusPending = true
  C_Timer.After(0, function()
    if not self.focusPending then return end
    self.focusPending = nil
    self.editBox:SetFocus()
  end)
end

--- @param self table
local function NotifyChange(self)
  self.timer = nil
  local text = self.editBox:GetText()
  if text == self.query then return end
  self.query = text
  local search = CONFIG:SearchArg(self)
  if search then search.onChange(text, self) end
end

--- Clear button and typing both land here
--- @param self table
local function EditBox_OnTextChanged(self)
  if self.timer then self.timer:Cancel() end
  self.timer = C_Timer.NewTimer(DEBOUNCE_SECONDS, function() NotifyChange(self) end)
end

--- Runs on each SetWidth; the option is only known by then
--- @param self table
local function ApplyLayout(self)
  local size = CONFIG:Layout(self).search
  self.editBox:SetSize(size.width, size.height)
  self.editBox:ClearAllPoints()
  self.editBox:SetPoint('TOPRIGHT', self.frame, 'BOTTOMRIGHT', size.x, size.y)
  TakeFocusOnShow(self)
end

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
local methods = {
  OnAcquire = function(self)
    self.focusChecked, self.focusPending = false, nil
    self:SetWidth(200)
    -- Height 0 means unset; anchors would stretch the row
    self:SetHeight(1)
    self:SetDisabled(false)
  end,

  OnRelease = function(self)
    if self.timer then self.timer:Cancel() end
    releasedAt = GetTime()
    -- Focus still on its way counts as held
    if self.focusPending then focusLostAt = releasedAt end
    self.timer, self.focusPending = nil, nil
    self.editBox:ClearFocus()
  end,

  OnWidthSet = ApplyLayout,

  --- The option's name is the placeholder
  SetLabel = function(self, text) self.editBox.Instructions:SetText(text or SEARCH) end,

  --- From the option's `get`; a matching query skips onChange
  SetText = function(self, text)
    self.query = text or ''
    self.editBox:SetText(self.query)
  end,

  SetDisabled = function(self, disabled) self.editBox:SetEnabled(not disabled) end,
}

--[[-----------------------------------------------------------------------------
Constructor
-------------------------------------------------------------------------------]]
local function Constructor()
  local frame = CreateFrame('Frame', nil, UIParent)

  local template = 'SearchBoxTemplate' --[[@as Template ]]
  local editBox = CreateFrame('EditBox', nil, frame, template)
  editBox:SetAutoFocus(false)

  local widget = {
    editBox = editBox,
    frame = frame,
    query = '',
    type = o.Type,
  }
  for method, func in pairs(methods) do
    widget[method] = func
  end

  editBox:HookScript('OnTextChanged', function() EditBox_OnTextChanged(widget) end)
  editBox:HookScript('OnEditFocusLost', function() focusLostAt = GetTime() end)

  return AceGUI:RegisterAsWidget(widget)
end

AceGUI:RegisterWidgetType(o.Type, Constructor, o.Version)
