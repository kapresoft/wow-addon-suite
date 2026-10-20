--[[-----------------------------------------------------------------------------
SettingsCheckbox Widget
AceGUI toggle control using Blizzard's Settings checkbox.
Use via `dialogControl = O.SettingsCheckboxWidget.Type` on a 'toggle' option.
-------------------------------------------------------------------------------]]
--- @type ADS_Namespace
local ns = select(2, ...)
local AceGUI = ns:AceGUI()
local CONFIG = ns.O.Ace3WidgetConfig
local Util = ns.O.Ace3WidgetUtil

local libName = ns.M.SettingsCheckboxWidget()
--- @class ADS_SettingsCheckboxWidget
local o = { Type = 'AddonSuite_SettingsCheckbox', Version = 1 }; ns:Register(libName, o)

--[[-----------------------------------------------------------------------------
Scripts
-------------------------------------------------------------------------------]]
--- @param self table
local function Check_OnClick(self)
  local checked = self.check:GetChecked() and true or false
  local sound = checked and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON
    or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF
  PlaySound(sound)
  self.value = checked
  self:Fire('OnValueChanged', checked)
end

--- Uses the template's own HoverBackground as row highlight
--- @param self table
--- @param shown boolean
local function Frame_OnHover(self, shown)
  self.check.HoverBackground:SetShown(shown)
  if shown then
    Util:FireEnter(self, self.label)
  else
    self:Fire('OnLeave')
  end
end

--- Clicking the row toggles, like Blizzard's Settings rows
--- @param self table
local function Frame_OnMouseUp(self)
  if not self.disabled then self.check:Click() end
end

--- Runs on each SetWidth; the option is only known by then
--- @param self table
local function ApplyLayout(self)
  local layout = CONFIG:Layout(self)
  self.label:SetWidth(layout.label.width)
  self.check:SetSize(layout.checkbox.width, layout.checkbox.height)
  self:SetHeight(layout.row.height)
end

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
local methods = {
  OnAcquire = function(self)
    self.check.HoverBackground:Hide()
    self:SetWidth(200)
    self:SetValue(false)
    self:SetDisabled(false)
  end,

  OnWidthSet = ApplyLayout,

  SetLabel = function(self, text) self.label:SetText(text) end,

  SetValue = function(self, value)
    self.value = value and true or false
    self.check:SetChecked(self.value)
  end,

  GetValue = function(self) return self.value end,

  SetDisabled = function(self, disabled)
    self.disabled = disabled
    self.check:SetEnabled(not disabled)
    local color = disabled and GRAY_FONT_COLOR or NORMAL_FONT_COLOR
    self.label:SetTextColor(color:GetRGB())
  end,

  -- AceConfigDialog calls these on every toggle; unsupported
  SetTriState = function() end,
  SetDescription = function() end,
  SetImage = function() end,
}

--[[-----------------------------------------------------------------------------
Constructor
-------------------------------------------------------------------------------]]
local function Constructor()
  local frame = CreateFrame('Frame', nil, UIParent)
  frame:EnableMouse(true)

  local label = frame:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
  label:SetPoint('LEFT')
  label:SetJustifyH('LEFT')

  local template = 'SettingsCheckboxTemplate' --[[@as Template ]]
  local check = CreateFrame('CheckButton', nil, frame, template)
  check:SetPoint('LEFT', label, 'RIGHT')

  local widget = {
    label = label,
    check = check,
    frame = frame,
    type = o.Type,
  }
  for method, func in pairs(methods) do
    widget[method] = func
  end

  check:SetScript('OnClick', function() Check_OnClick(widget) end)
  check:HookScript('OnEnter', function() Util:FireEnter(widget, check) end)
  check:HookScript('OnLeave', function() widget:Fire('OnLeave') end)
  frame:SetScript('OnMouseUp', function() Frame_OnMouseUp(widget) end)
  frame:SetScript('OnEnter', function() Frame_OnHover(widget, true) end)
  frame:SetScript('OnLeave', function() Frame_OnHover(widget, false) end)

  return AceGUI:RegisterAsWidget(widget)
end

AceGUI:RegisterWidgetType(o.Type, Constructor, o.Version)
