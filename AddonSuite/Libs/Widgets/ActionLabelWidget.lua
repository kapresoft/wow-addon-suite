--[[-----------------------------------------------------------------------------
ActionLabel Widget
A description with icon buttons pinned right: [text ...] [a] [b].
Each button comes from the option's `arg.actions`, in order.
`arg.actionsAnchor = 'below'` hangs the buttons under the text instead,
e.g. onto the tab strip of a tab group that follows it.
Use via `dialogControl = O.ActionLabelWidget.Type` on a 'description' option.
-------------------------------------------------------------------------------]]
--- @type ADS_Namespace
local ns = select(2, ...)
local AceGUI = ns:AceGUI()
local CONFIG = ns.O.Ace3WidgetConfig
local Util = ns.O.Ace3WidgetUtil

local libName = ns.M.ActionLabelWidget()
--- @class ADS_ActionLabelWidget
local o = { Type = 'AddonSuite_ActionLabel', Version = 1 }; ns:Register(libName, o)

local BUTTON_GAP = 4
local TEXT_GAP = 10

--[[-----------------------------------------------------------------------------
Support functions
-------------------------------------------------------------------------------]]
--- @param widget table
--- @param button Button
local function Button_OnEnter(widget, button)
  local tooltip = button.action.tooltip
  if not tooltip then return end
  GameTooltip:SetOwner(button, 'ANCHOR_NONE')
  Util:AnchorTooltip(widget, GameTooltip, button)
  tooltip(GameTooltip)
  GameTooltip:Show()
end

--- @param button Button
local function Button_OnClick(button)
  PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
  button.action.onClick()
end

--- @param widget table
--- @return Button
local function CreateButton(widget)
  local button = CreateFrame('Button', nil, widget.frame)
  button.icon = button:CreateTexture(nil, 'ARTWORK')
  button.icon:SetAllPoints()
  button.overlay = button:CreateTexture(nil, 'OVERLAY')
  button.overlay:SetAllPoints()
  button.highlight = button:CreateTexture(nil, 'HIGHLIGHT')
  button.highlight:SetAllPoints()
  button.highlight:SetBlendMode('ADD')
  button:SetScript('OnClick', Button_OnClick)
  button:SetScript('OnEnter', function() Button_OnEnter(widget, button) end)
  button:SetScript('OnLeave', function() GameTooltip:Hide() end)
  return button
end

--- @param button Button
--- @param action ADS_Ace3WidgetActionArg
--- @param size ADS_Ace3WidgetAction
local function ShowButton(button, action, size)
  button.action = action
  button.icon:SetAtlas(action.atlas)
  button.highlight:SetAtlas(action.atlas)
  button.overlay:SetShown(action.overlay ~= nil)
  if action.overlay then button.overlay:SetAtlas(action.overlay) end
  button:SetSize(size.width, size.height)
  button:Show()
end

--- @param self table
--- @param button Button
--- @param size ADS_Ace3WidgetAction
local function PinRight(self, button, size)
  if CONFIG:ActionsAnchor(self) == 'below' then
    return button:SetPoint('TOPRIGHT', self.frame, 'BOTTOMRIGHT', size.x, size.y)
  end
  button:SetPoint('RIGHT', self.frame, 'RIGHT', size.x, size.y)
end

--- Lays buttons out right to left, last action pinned right
--- @param self table
--- @return number @Width the buttons take, gaps included
local function LayoutButtons(self)
  local actions = CONFIG:ActionsArg(self)
  local size = CONFIG:Layout(self).action
  local anchor, used = nil, 0
  for i = #actions, 1, -1 do
    self.buttons[i] = self.buttons[i] or CreateButton(self)
    local button = self.buttons[i]
    ShowButton(button, actions[i], size)
    button:ClearAllPoints()
    if anchor then
      button:SetPoint('RIGHT', anchor, 'LEFT', -BUTTON_GAP, 0)
      used = used + BUTTON_GAP
    else
      PinRight(self, button, size)
    end
    anchor, used = button, used + size.width
  end
  for i = #actions + 1, #self.buttons do
    self.buttons[i]:Hide()
  end
  return used
end

--- Runs on each SetWidth; the option is only known by then
--- @param self table
--- @param width number
local function ApplyLayout(self, width)
  local used = LayoutButtons(self)
  -- Buttons hung below take no room on the text's row
  if CONFIG:ActionsAnchor(self) == 'below' then
    self.label:SetWidth(width)
    return self:SetHeight(self.label:GetStringHeight())
  end
  local gap = used > 0 and TEXT_GAP or 0
  self.label:SetWidth(width - used - gap)
  local height = math.max(self.label:GetStringHeight(), CONFIG:Layout(self).action.height)
  self:SetHeight(height)
end

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
local methods = {
  OnAcquire = function(self)
    self:SetText('')
    self:SetFontObject(nil)
    self:SetWidth(200)
  end,

  OnWidthSet = ApplyLayout,

  SetText = function(self, text) self.label:SetText(text) end,

  SetFontObject = function(self, font) self.label:SetFontObject(font or GameFontHighlightSmall) end,

  -- AceConfigDialog calls these only when the option sets an image
  SetImage = function() end,
  SetImageSize = function() end,
}

--[[-----------------------------------------------------------------------------
Constructor
-------------------------------------------------------------------------------]]
local function Constructor()
  local frame = CreateFrame('Frame', nil, UIParent)

  local label = frame:CreateFontString(nil, 'OVERLAY', 'GameFontHighlightSmall')
  label:SetPoint('LEFT')
  label:SetJustifyH('LEFT')

  local widget = {
    label = label,
    buttons = {},
    frame = frame,
    type = o.Type,
  }
  for method, func in pairs(methods) do
    widget[method] = func
  end

  return AceGUI:RegisterAsWidget(widget)
end

AceGUI:RegisterWidgetType(o.Type, Constructor, o.Version)
