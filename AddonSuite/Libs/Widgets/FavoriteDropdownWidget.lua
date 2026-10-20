--[[-----------------------------------------------------------------------------
FavoriteDropdown Widget
A StepperDropdown with a favorite star between the label and the dropdown:
[Label] [star] [< dropdown >] [reload]. The dropdown uses the option's
get/set; the star binds to `arg.favorite`, which also marks favorite
menu entries; the reload button shows only when the option sets `arg.reload`.
Use via `dialogControl = O.FavoriteDropdownWidget.Type` on a 'select' option.
-------------------------------------------------------------------------------]]
--- @type ADS_Namespace
local ns = select(2, ...)
local AceGUI = ns:AceGUI()
local CONFIG = ns.O.Ace3WidgetConfig
local Util = ns.O.Ace3WidgetUtil
local StepperDropdown = ns.O.StepperDropdownWidget

local libName = ns.M.FavoriteDropdownWidget()
--- @class ADS_FavoriteDropdownWidget
local o = { Type = 'AddonSuite_FavoriteDropdown', Version = 1 }; ns:Register(libName, o)

local STAR_ATLAS_ON = 'auctionhouse-icon-favorite'
local STAR_ATLAS_OFF = 'auctionhouse-icon-favorite-off'
local STAR_GAP = 4
local BUTTON_GAP = 4
local MENU_STAR = CreateAtlasMarkup(STAR_ATLAS_ON, 14, 14)

--[[-----------------------------------------------------------------------------
Support functions
-------------------------------------------------------------------------------]]
--- @param self table
local function RefreshStar(self)
  local favorite = CONFIG:FavoriteArg(self)
  local isFavorite = favorite and favorite.get()
  self.star.icon:SetAtlas(isFavorite and STAR_ATLAS_ON or STAR_ATLAS_OFF)
end

--- @param self table
local function Star_OnClick(self)
  local favorite = CONFIG:FavoriteArg(self)
  if self.disabled or not favorite then return end
  favorite.set(not favorite.get())
  RefreshStar(self)
end

--- @param self table
local function Star_OnEnter(self)
  local favorite = CONFIG:FavoriteArg(self)
  if not (favorite and favorite.tooltip) then return end
  GameTooltip:SetOwner(self.star, 'ANCHOR_NONE')
  Util:AnchorTooltip(self, GameTooltip, self.star)
  favorite.tooltip(GameTooltip)
  GameTooltip:Show()
end

--- @param frame Frame
--- @return Button
local function CreateStar(frame)
  local star = CreateFrame('Button', nil, frame)
  star.icon = star:CreateTexture(nil, 'ARTWORK')
  star.icon:SetAllPoints()
  star:SetHighlightAtlas(STAR_ATLAS_OFF, 'ADD')
  return star
end

--- Favorite entries get a trailing star in the menu
--- @param self table
--- @param key any
--- @return string
local function EntryText(self, key)
  local text = self.list[key]
  local favorite = CONFIG:FavoriteArg(self)
  if not (favorite and favorite.isFavorite and favorite.isFavorite(key)) then return text end
  return text .. ' ' .. MENU_STAR
end

--- @param self table
local function Reload_OnClick(self)
  local reload = CONFIG:ReloadArg(self)
  if reload then reload.onClick() end
end

--- @param self table
local function Reload_OnEnter(self)
  local reload = CONFIG:ReloadArg(self)
  if not (reload and reload.tooltip) then return end
  GameTooltip:SetOwner(self.reload, 'ANCHOR_NONE')
  Util:AnchorTooltip(self, GameTooltip, self.reload)
  reload.tooltip(GameTooltip)
  GameTooltip:Show()
end

--- Blizzard's square refresh button, after the dropdown
--- @param widget table
--- @return Button
local function CreateReload(widget)
  local template = 'RefreshButtonTemplate' --[[@as Template ]]
  local reload = CreateFrame('Button', nil, widget.frame, template)
  reload:SetPoint('LEFT', widget.control, 'RIGHT', BUTTON_GAP, 0)
  reload:SetScript('OnClick', function() Reload_OnClick(widget) end)
  reload:HookScript('OnEnter', function() Reload_OnEnter(widget) end)
  reload:HookScript('OnLeave', function() GameTooltip:Hide() end)
  return reload
end

--- Wraps a StepperDropdown method; `fn` runs after the original
--- @param widget table
--- @param name string
--- @param fn fun(self: table, ...)
local function After(widget, name, fn)
  local original = widget[name]
  widget[name] = function(self, ...)
    original(self, ...)
    fn(self, ...)
  end
end

--[[-----------------------------------------------------------------------------
Constructor
-------------------------------------------------------------------------------]]
local function Constructor()
  local widget = AceGUI:Create(StepperDropdown.Type)
  widget.type = o.Type

  local star = CreateStar(widget.frame)
  star:SetPoint('LEFT', widget.label, 'RIGHT')
  widget.control:ClearAllPoints()
  widget.control:SetPoint('LEFT', star, 'RIGHT', STAR_GAP, 0)
  widget.star = star

  star:SetScript('OnClick', function() Star_OnClick(widget) end)
  star:SetScript('OnEnter', function() Star_OnEnter(widget) end)
  star:SetScript('OnLeave', function() GameTooltip:Hide() end)
  widget.reload = CreateReload(widget)
  widget.GetEntryText = EntryText

  -- Ace sets the option (and its arg) after SetValue; layout runs later
  After(widget, 'OnWidthSet', function(self)
    local size = CONFIG:Layout(self).star
    self.star:SetSize(size.width, size.height)
    RefreshStar(self)
    self.reload:SetShown(CONFIG:ReloadArg(self) ~= nil)
  end)
  After(widget, 'SetDisabled', function(self, disabled) self.star:SetEnabled(not disabled) end)

  return widget
end

AceGUI:RegisterWidgetType(o.Type, Constructor, o.Version)
