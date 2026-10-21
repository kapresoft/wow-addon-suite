--[[-----------------------------------------------------------------------------
TourList: every help tour, in priority order.

Tours without `since` are always eligible (the welcome tour). Feature tours
set `since` one past the highest in use, so only users who installed before
it see them. Step keys must be unique across all tours.

The host is the settings dialog's AceGUI frame. Its widgets are rebuilt on
every refresh, so anchors look them up each time: an option tagged with
`arg.helpTip` is found by that tag.
@see HelpTour.lua
-------------------------------------------------------------------------------]]
--- @type ADS_Namespace
local ns = select(2, ...)

local libName = ns.M.HelpTourList()

--[[-----------------------------------------------------------------------------
Support Functions
-------------------------------------------------------------------------------]]
--- Depth-first search of an AceGUI widget tree
--- @param widget table
--- @param predicate fun(widget: table): boolean
--- @return table? @nil if no widget matches
local function FindWidget(widget, predicate)
  if predicate(widget) then return widget end
  for _, child in ipairs(widget.children or {}) do
    local found = FindWidget(child, predicate)
    if found then return found end
  end
end

--- @param dialog table
--- @param helpTip string @The option's `arg.helpTip`
--- @return table? @nil unless that option is drawn
local function OptionWidget(dialog, helpTip)
  return FindWidget(dialog, function(widget)
    local option = widget:GetUserData('option')
    local arg = option and option.arg
    return type(arg) == 'table' and arg.helpTip == helpTip
  end)
end

--- @param dialog table
--- @param value string @The tab's group key
--- @return Button? @nil unless a tab group shows that tab
local function TabButton(dialog, value)
  local tabGroup = FindWidget(dialog, function(widget) return widget.type == 'TabGroup' end)
  for _, tab in ipairs(tabGroup and tabGroup.tabs or {}) do
    if tab.value == value and tab:IsShown() then return tab end
  end
end

--- @param helpTip string
--- @param field string @The widget's region to point at
--- @return fun(dialog: table): Region?
local function OptionPart(helpTip, field)
  return function(dialog)
    local widget = OptionWidget(dialog, helpTip)
    return widget and widget[field]
  end
end

--[[-----------------------------------------------------------------------------
Tours
-------------------------------------------------------------------------------]]
--- @type ADS_HelpTourDef[]
local tours = {
  {
    id = 'welcome',
    host = 'Settings',
    steps = {
      {
        key = 'ProfileDropdown',
        textKey = 'Profile::HelpTip',
        anchor = OptionPart('Profile', 'dropdown'),
      },
      {
        key = 'FavoriteStar',
        textKey = 'Favorite::HelpTip',
        anchor = OptionPart('Profile', 'star'),
      },
      {
        key = 'ReloadButton',
        textKey = 'Reload::HelpTip',
        anchor = OptionPart('Profile', 'reload'),
      },
      {
        key = 'CheckAllNone',
        textKey = 'Check All::HelpTip',
        anchor = function(dialog)
          local widget = OptionWidget(dialog, 'AddOnsHeader')
          return widget and widget.buttons[1]
        end,
      },
      {
        key = 'FavoritesTab',
        textKey = 'Favorite Profiles::HelpTip',
        anchor = function(dialog) return TabButton(dialog, 'favorites') end,
      },
    },
  },
}
ns:Register(libName, tours)
