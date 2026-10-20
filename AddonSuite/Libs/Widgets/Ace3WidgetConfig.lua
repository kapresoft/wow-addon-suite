--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type ADS_Namespace
local ns = select(2, ...)
local t_merge = ns.O.Table.MergeRecursive

--[[-----------------------------------------------------------------------------
Types
-------------------------------------------------------------------------------]]
--- Per-option override passed through AceConfig's `arg`
--- @class ADS_Ace3WidgetArg
--- @field layout? ADS_Ace3WidgetLayout
--- @field tooltip? ADS_Ace3WidgetTooltipArg
--- @field favorite? ADS_Ace3WidgetFavoriteArg
--- @field reload? ADS_Ace3WidgetReloadArg
--- @field actions? ADS_Ace3WidgetActionArg[] @ActionLabel buttons, left to right

--- Binds a FavoriteDropdown's star; separate from the option's get/set
--- @class ADS_Ace3WidgetFavoriteArg
--- @field get fun(): boolean
--- @field set fun(value: boolean)
--- @field tooltip? fun(tooltip: GameTooltip)
--- @field isFavorite? fun(key: any): boolean @Stars that entry in the menu

--- Shows a FavoriteDropdown's trailing reload button when set
--- @class ADS_Ace3WidgetReloadArg
--- @field onClick fun()
--- @field tooltip? fun(tooltip: GameTooltip)

--- An ActionLabel icon button; `overlay` draws over `atlas`
--- @class ADS_Ace3WidgetActionArg
--- @field atlas string
--- @field overlay? string
--- @field onClick fun()
--- @field tooltip? fun(tooltip: GameTooltip)

--- Tooltip content, keyed by the part it shows over
--- @class ADS_Ace3WidgetTooltipArg
--- @field dropdown? string|fun(tooltip:GameTooltip) @Shown over the dropdown, not its arrows

--- @class ADS_Ace3WidgetSize
--- @field width? number  @px
--- @field height? number @px

--- Only height is used; AceGUI sets the row width
--- @class ADS_Ace3WidgetRow : ADS_Ace3WidgetSize

--- @class ADS_Ace3WidgetLabel : ADS_Ace3WidgetSize

--- Width includes the stepper arrows
--- @class ADS_Ace3WidgetDropdown : ADS_Ace3WidgetSize

--- @class ADS_Ace3WidgetStar : ADS_Ace3WidgetSize

--- @class ADS_Ace3WidgetCheckbox : ADS_Ace3WidgetSize

--- @class ADS_Ace3WidgetAction : ADS_Ace3WidgetSize

--- Width excludes the value label
--- @class ADS_Ace3WidgetSlider : ADS_Ace3WidgetSize

--- Tooltip BOTTOMLEFT offset from its context's TOPRIGHT
--- @class ADS_Ace3WidgetTooltip
--- @field x? number @px
--- @field y? number @px

--- @class ADS_Ace3WidgetLayout
--- @field row? ADS_Ace3WidgetRow
--- @field label? ADS_Ace3WidgetLabel
--- @field dropdown? ADS_Ace3WidgetDropdown
--- @field star? ADS_Ace3WidgetStar
--- @field checkbox? ADS_Ace3WidgetCheckbox
--- @field action? ADS_Ace3WidgetAction
--- @field slider? ADS_Ace3WidgetSlider
--- @field tooltip? ADS_Ace3WidgetTooltip

--[[-----------------------------------------------------------------------------
Defaults
-------------------------------------------------------------------------------]]
--- @type ADS_Ace3WidgetLayout
local DEFAULT_LAYOUT = {
  row = { height = 30 },
  label = { width = 150 },
  dropdown = { width = 260, height = 30 },
  star = { width = 18, height = 18 },
  checkbox = { width = 30, height = 30 },
  action = { width = 20, height = 20 },
  slider = { width = 220, height = 19 },
  tooltip = { x = 20, y = 20 },
}

--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
local libName = ns.M.Ace3WidgetConfig()
--- Shared by our AceGUI widgets so their rows line up
--- @class ADS_Ace3WidgetConfig
local o = {}; ns:Register(libName, o)

--[[-----------------------------------------------------------------------------
Support Functions
-------------------------------------------------------------------------------]]
--- @param widget AceGUIWidget
--- @return ADS_Ace3WidgetArg? @The option's AceConfig `arg`; nil if unset
local function ArgFor(widget)
  local option = widget:GetUserData('option')
  return option and option.arg
end

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
--- The option's `arg.layout` merged over the defaults
--- @param widget AceGUIWidget
--- @return ADS_Ace3WidgetLayout
function o:Layout(widget)
  local arg = ArgFor(widget)
  local override = type(arg) == 'table' and arg.layout or {}
  -- Merge into a copy; arg tables are shared across options
  return t_merge(DEFAULT_LAYOUT, t_merge(override, {}))
end

--- @param widget AceGUIWidget
--- @return (string|fun(tooltip:GameTooltip))? @nil if the option sets none
function o:DropdownTooltip(widget)
  local arg = ArgFor(widget)
  local tooltip = type(arg) == 'table' and arg.tooltip
  return type(tooltip) == 'table' and tooltip.dropdown or nil
end

--- @param widget AceGUIWidget
--- @return ADS_Ace3WidgetFavoriteArg? @nil if the option sets none
function o:FavoriteArg(widget)
  local arg = ArgFor(widget)
  return type(arg) == 'table' and arg.favorite or nil
end

--- @param widget AceGUIWidget
--- @return ADS_Ace3WidgetReloadArg? @nil if the option sets none
function o:ReloadArg(widget)
  local arg = ArgFor(widget)
  return type(arg) == 'table' and arg.reload or nil
end

--- @param widget AceGUIWidget
--- @return ADS_Ace3WidgetActionArg[] @Empty if the option sets none
function o:ActionsArg(widget)
  local arg = ArgFor(widget)
  return type(arg) == 'table' and arg.actions or {}
end
