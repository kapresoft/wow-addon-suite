--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type ADS_Namespace
local ns = select(2, ...)
local AOK = ns:LibAceOptionsKit()

--[[-----------------------------------------------------------------------------
Types: AddonSuite's own `arg` fields, on top of LibAceOptionsKit's
-------------------------------------------------------------------------------]]
--- Per-option settings passed through AceConfig's `arg`
--- @class ADS_Ace3WidgetArg : LibAceOptionsKit_Arg
--- @field layout? ADS_Ace3WidgetLayout
--- @field search? ADS_Ace3WidgetSearchArg
--- @field actions? ADS_Ace3WidgetActionArg[] @ActionLabel buttons, left to right
--- @field actionsAnchor? 'right'|'below'     @ActionLabel buttons beside or under the text
--- @field helpTip? string                     @Help tour finds this option's widget by it

--- Receives a SearchBox's text as the user types
--- @class ADS_Ace3WidgetSearchArg
--- @field onChange fun(query: string, widget: AceGUIWidget)
--- @field focusOnShow? boolean @Focuses the box when its view opens, not on rebuilds

--- An ActionLabel icon button; `overlay` draws over `atlas`
--- @class ADS_Ace3WidgetActionArg
--- @field atlas string
--- @field overlay? string
--- @field onClick fun()
--- @field tooltip? fun(tooltip: GameTooltip)

--- Offsets move the button group from its anchor
--- @class ADS_Ace3WidgetAction : LibAceOptionsKit_Size
--- @field x? number @px
--- @field y? number @px

--- Offsets move the box from under its row's right end
--- @class ADS_Ace3WidgetSearch : LibAceOptionsKit_Size
--- @field x? number @px
--- @field y? number @px

--- @class ADS_Ace3WidgetLayout : LibAceOptionsKit_Layout
--- @field action? ADS_Ace3WidgetAction
--- @field search? ADS_Ace3WidgetSearch

--[[-----------------------------------------------------------------------------
Defaults: AddonSuite's keys only; the library has the rest
-------------------------------------------------------------------------------]]
AOK:SetDefaults(ns.addon, {
  action = { width = 20, height = 20, x = 0, y = 0 },
  search = { width = 160, height = 20, x = 0, y = 0 },
} --[[@as ADS_Ace3WidgetLayout]])

--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
local libName = ns.M.Ace3WidgetConfig()
--- Reads AddonSuite's own `arg` fields for ActionLabel and SearchBox
--- @class ADS_Ace3WidgetConfig
local o = {}; ns:Register(libName, o)

--[[-----------------------------------------------------------------------------
Support Functions
-------------------------------------------------------------------------------]]
--- @param widget AceGUIWidget
--- @return ADS_Ace3WidgetArg? @nil unless the option's `arg` is a table
local function ArgFor(widget) return AOK:ArgFor(widget) --[[@as ADS_Ace3WidgetArg?]] end

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
--- LibAceOptionsKit's merged layout, with AddonSuite's keys
--- @param widget AceGUIWidget
--- @return ADS_Ace3WidgetLayout
function o:Layout(widget) return AOK:Layout(widget) --[[@as ADS_Ace3WidgetLayout]] end

--- @param widget AceGUIWidget
--- @return ADS_Ace3WidgetSearchArg? @nil if the option sets none
function o:SearchArg(widget)
  local arg = ArgFor(widget)
  return arg and arg.search
end

--- @param widget AceGUIWidget
--- @return ADS_Ace3WidgetActionArg[] @Empty if the option sets none
function o:ActionsArg(widget)
  local arg = ArgFor(widget)
  return arg and arg.actions or {}
end

--- @param widget AceGUIWidget
--- @return 'right'|'below'
function o:ActionsAnchor(widget)
  local arg = ArgFor(widget)
  return arg and arg.actionsAnchor or 'right'
end
