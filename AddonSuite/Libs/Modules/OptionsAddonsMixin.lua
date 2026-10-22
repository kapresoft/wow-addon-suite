--[[-----------------------------------------------------------------------------
Type: OptionsAddons
-------------------------------------------------------------------------------]]

--- @class OptionsAddons

--[[-----------------------------------------------------------------------------
Lua Vars
-------------------------------------------------------------------------------]]
local C_Timer_NewTicker = C_Timer.NewTicker
local GetNumAddOns = GetNumAddOns or C_AddOns.GetNumAddOns

--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type ADS_Namespace
local ns = select(2, ...)

local O, GC, M, MSG = ns.O, ns.GC, ns.M, ns.GC.M
local String = ns.O.String
local AceEvent = ns:AceEvent()
local AceConfigRegistry = ns:AceConfigRegistry()
local API, ACU, ADU = O.API, ns:ACU(), O.AddOnDependencyUtil
local OptionsTitanPanelMixin = O.OptionsTitanPanelMixin
local OptionsFavoritesMixin = O.OptionsFavoritesMixin
local HelpTour = O.HelpTour
local ActionLabel, FavoriteDropdown = O.ActionLabelWidget, O.FavoriteDropdownWidget
local SearchBox = O.SearchBoxWidget

local libName = M.OptionsAddonsMixin()
local p, t = ns:log(libName)

--- @type table<string, string>
local L = ns:GetLocale()
local libPrefix = L['Lib:'] .. ' '

--- @type boolean
local IsOptionsVisible = false

local ADDON_ROW_ARG = 'AddonSuite.AddOnRow'
local ADDON_LIST_TAB = 'addonList'

--- Session only; `searchNeedle` is the trimmed, lowercased match key
local searchQuery, searchNeedle = '', ''

local fVersion = ns:ColorFn(BLUE_FONT_COLOR)
local fDisabled = ns:ColorFn(LIGHTGRAY_FONT_COLOR)
local fLib = ns:ColorFn(LIGHTBLUE_FONT_COLOR)
local fLabel = ns:ColorFn(YELLOW_FONT_COLOR)

--[[-----------------------------------------------------------------------------
OnAddOnEnabled
-------------------------------------------------------------------------------]]
ns:OnAddOnEnabled(function() API:PrefetchAddOnInfo() end)

--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
--- @class OptionsAddonsMixin : AceEvent-3.0
--- @field optionsMixin OptionsMixin
local o = ns:Register(libName, ns:NewAceEvent())

--- @class OptionsAddons : OptionsAddonsMixin

--[[-----------------------------------------------------------------------------
Support Functions
-------------------------------------------------------------------------------]]
local sp = '                                                                   '

local function GetSortedKeys(t)
  if type(t) ~= 'table' then return tostring(t) end
  local keys = {}
  for k in pairs(t) do
    table.insert(keys, k)
  end
  table.sort(keys)
  return keys
end

--- @param text string?
--- @return string
local function StripColors(text)
  local stripped = (text or ''):gsub('|c%x%x%x%x%x%x%x%x', ''):gsub('|r', '')
  return stripped
end

--- @param info AddOnInfo
--- @return string @Folder name and title, lowercased
local function SearchTextFor(info) return (info.name .. ' ' .. StripColors(info.title)):lower() end

--- @param searchText string
--- @return boolean
local function MatchesSearch(searchText)
  return searchNeedle == '' or searchText:find(searchNeedle, 1, true) ~= nil
end

--- @param option AceConfigOption
--- @return boolean
local function IsAddOnRow(option) return option.type == 'toggle' and option.arg == ADDON_ROW_ARG end

--- Re-selecting the list's tab rebuilds only the list,
--- so the search box above it keeps focus
--- @param widget AceGUIWidget @The search box
local function RefreshAddOnList(widget)
  for _, child in ipairs(widget.parent.children) do
    if child.type == 'TabGroup' then return child:SelectTab(ADDON_LIST_TAB) end
  end
end

--- @return ProfileSelect
local function CreateProfileSelect()
  local function GetProfiles() return ns:db():GetProfiles() end
  local function GetCurrentProfile() return ns:db():GetCurrentProfile() end
  --- @param info table Ignored
  --- @param val string The profile name selected
  local function SetCurrentProfile(info, val)
    ns:db():SetProfile(val)
    HelpTour:CompleteStep('ProfileDropdown')
    AceEvent:SendMessage(MSG.OnUpdateMinimapState, libName)
  end
  --- Get the Profile names to be used for the select values
  --- @return table<string, string> key is the same as value
  local function GetSortedProfiles()
    local profiles = {}
    for _, profileName in ipairs(GetProfiles()) do
      profiles[profileName] = profileName
    end
    return GetSortedKeys(profiles)
  end
  --- Get the Profile names to be used for the select values
  --- This table has to match the order of the original profile
  --- @return table<string, string> key is the same as value
  local function GetProfilesKV()
    local profiles = {}
    for _, pr in ipairs(GetProfiles()) do
      profiles[pr] = pr
    end
    return profiles
  end

  --- @class ProfileSelect
  local ret = {
    kvPairs = GetProfilesKV,
    sorting = GetSortedProfiles,
    get = GetCurrentProfile,
    set = SetCurrentProfile,
  }
  return ret
end
--[[-----------------------------------------------------------------------------
CoroutineManager: This component warms up the cache in the background on login so that
the WoW UI can prioritize the threads.
-------------------------------------------------------------------------------]]
--- Coroutine manager for handling async tasks
--- @class OptionsCoroutineManager
local CoroutineManager = {
  coroutines = {},
  ticker = nil,
}

--- @type OptionsCoroutineManager
local CM = CoroutineManager

--- Creates a coroutine and stores it in the manager
function CM:Create(fn)
  local co = coroutine.create(fn)
  table.insert(self.coroutines, co)
  if not self.ticker then self:StartTicker() end
  return co
end

--- Resumes all coroutines and processes their results
function CM:ResumeAll()
  for i = #self.coroutines, 1, -1 do
    local co = self.coroutines[i]
    if coroutine.status(co) == 'suspended' then
      local success, result = coroutine.resume(co)
      if not success then
        table.remove(self.coroutines, i)
      elseif coroutine.status(co) == 'dead' then
        table.remove(self.coroutines, i)
      end
    end
  end
  if #self.coroutines == 0 then self:StopTicker() end
end

--- Starts the ticker to resume coroutines periodically
function CM:StartTicker()
  self.ticker = C_Timer_NewTicker(0.1, function() self:ResumeAll() end)
end

function CM:StopTicker()
  if self.ticker then
    self.ticker:Cancel()
    self.ticker = nil
  end
end

--[[-----------------------------------------------------------------------------
Methods: OptionsAddonsMixin
-------------------------------------------------------------------------------]]
--- @type OptionsAddonsMixin
local LIB = o

--- @public
--- @param options Options
--- @return OptionsAddons
function LIB:New(options) return CreateAndInitFromMixin(o, options) end

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]

--- Called Automatically by CreateAndInitFromMixin
--- @private
--- @param options Options
function o:Init(options)
  self.mainOptions = options
  self.util = options.util
  self.order = options.order
end

--- @return AceConfigOption
function o:CreateAddOnsGroup()
  local order = self.order
  local addOnsTab = self:CreateAddOnsTab()
  local optionsTab = self:CreateOptionsTab()
  local favoritesTab = OptionsFavoritesMixin:New(self.mainOptions):CreateTab()
  local titanPanelTab = OptionsTitanPanelMixin:New(self.mainOptions):CreateTab()
  ---@type AceConfigOption
  local group = {
    type = 'group',
    name = L['General'],
    desc = L['General::Desc'],
    order = order:next(),
    childGroups = 'tab',
    args = {
      addons = addOnsTab,
      options = optionsTab,
      favorites = favoritesTab,
      titanPanel = titanPanelTab,
    },
  }
  return group
end

--- The add-on list is a child group so it scrolls on its own;
--- Ace only wraps groups without child groups in a scroll frame.
--- @return AceConfigOption
function o:CreateAddOnsTab()
  local order = self.order:next()
  return {
    type = 'group',
    name = L['Manage Add-Ons'],
    order = order,
    childGroups = 'tab',
    args = self:CreateAddOnsOptions(),
  }
end

--- Global toggles, separate from the add-on rows
--- @return AceConfigOption
function o:CreateOptionsTab()
  local order, util, minimap = self.order, self.util, ns:minimap()

  local function HideIconGet() return minimap.hide == true end
  local function HideIconSet(_, v)
    minimap.hide = (v == true)
    AceEvent:SendMessage(MSG.OnToggleMinimapIcon, libName)
  end
  local function SyncIndicatorGet() return minimap.sync_status_indicator == true end
  local function SyncIndicatorSet(_, v) minimap.sync_status_indicator = (v == true) end
  local function ConfirmReloadsGet() return minimap.confirm_reloads == true end
  local function ConfirmReloadsSet(_, v) minimap.confirm_reloads = (v == true) end

  local options = {
    syncAddOnStates = util:SettingsCheckbox(
      'Prompt me to Reload UI',
      order:next(),
      util:GlobalGet('sync_addon_states'),
      util:GlobalSet('sync_addon_states')
    ),
    hideMinimapIcon = util:SettingsCheckbox(
      'Hide Minimap Icon',
      order:next(),
      HideIconGet,
      HideIconSet
    ),
    syncStatusIndicator = util:SettingsCheckbox(
      'Profile Sync Status Indicator',
      order:next(),
      SyncIndicatorGet,
      SyncIndicatorSet
    ),
    confirmReloads = util:SettingsCheckbox(
      'Confirm Reloads When Switching Profiles',
      order:next(),
      ConfirmReloadsGet,
      ConfirmReloadsSet
    ),
  }
  return { type = 'group', name = L['Options'], order = order:next(), args = options }
end

--- @return AceConfigOption
function o:CreateAddOnsOptions()
  local order = self.order
  local ps = CreateProfileSelect()

  --- @type table<string, AceConfigOption>
  local options = {
    profileSelection = ACU:CreateCharOption('Profile', {
      type = 'select',
      dialogControl = FavoriteDropdown.Type,
      width = 'full',
      order = order:next(),
      arg = {
        favorite = self:CreateFavoriteArg(),
        reload = self:CreateReloadArg(),
        helpTip = 'Profile',
      } --[[@as ADS_Ace3WidgetArg]],
      values = ps.kvPairs,
      sorting = ps.sorting,
      get = ps.get,
      set = ps.set,
    }),
  }

  options.addonsHeader = ACU:CreateLabel('Add-Ons::Desc', {
    order = order:next(),
    dialogControl = ActionLabel.Type,
    arg = {
      actions = { self:CreateEnableAllAction(), self:CreateDisableAllAction() },
      -- Onto the Add-Ons tab strip, next to the rows they act on
      actionsAnchor = 'below',
      layout = { action = { x = -8, y = -11 } },
      helpTip = 'AddOnsHeader',
    } --[[@as ADS_Ace3WidgetArg]],
  })
  options.addonsSearch = self:CreateSearchOption()

  --- @type table<string, AceConfigOption>
  local list = {}
  options[ADDON_LIST_TAB] =
    { type = 'group', name = L['Add-Ons'], order = order:next(), args = list }
  self.addonsOptions = list

  if GetNumAddOns() <= 0 then
    list['no_addon_found'] = {
      name = '\n\nNo Add-Ons were detected',
      type = 'description',
      order = order:next(),
    }
    return options
  end

  list.noMatches = {
    type = 'description',
    name = L['Add-Ons::No Matches'],
    order = order:next(),
    hidden = function() return self:AnyAddOnRowShown() end,
  }
  self:CreateAddOnCheckList()

  return options
end

--- Clicking a parent AddOn will enable the dependent addOns if configured
--- @see SynchronizedAddOns
--- @param options AceConfigOption
--- @param name AddOnName
--- @param v boolean The checked value
function o:OnSyncCheckedStateWithRelatedAddOns(options, name, v)
  local syncd = O.SynchronizedAddOns
  syncd:ForEachSyncdAddOn(name, function(syncdAddOnName)
    if not options[syncdAddOnName] then
      ns:profile().enabledAddons[syncdAddOnName] = nil
      return
    end
    ns:profile().enabledAddons[syncdAddOnName] = v
    o:UpdateEnabledState(syncdAddOnName, v)
  end)
end

--- This part depends on the addon dependency details cache being called
--- @see AddOnDependencyUtil#FlushAddOnDependencyDetailsCache
--- @param indexOrName IndexOrName The AddOn Index or Name
--- @return string
function o.GetDisplayName(indexOrName)
  local name = indexOrName
  if API:IsAddOnLibraryType(name) then return fLib(libPrefix .. name) end
  return (ADU:CanEnableByProfile(name) and name) or fDisabled(name)
end

--- @param name AddOnName
--- @param title string
--- @return string
local function TitleWithVersion(name, title)
  local version = API:GetAddOnVersion(name)
  if not version then return title end
  return title .. ' ' .. fVersion(version)
end

--- @param name AddOnName
--- @return string @Empty unless the addon is load on demand
local function LoadOnDemandLine(name)
  if not API:IsAddOnLoadOnDemand(name) then return '' end
  local key = API:IsAddOnLoaded(name) and 'Load on demand (loaded)' or 'Load on demand (not loaded)'
  return '\n\n' .. fLabel(L[key])
end

--- @param name AddOnName The AddOn Index or Name
--- @return string
function o.GetDesc(name)
  local info = API:GetAddOnInfo(name)
  local depsInfo = API:GetDependencyDetails(name)
  local desc = info.desc
  local label = ''

  desc = TitleWithVersion(name, info.title) .. '\n\n' .. desc .. LoadOnDemandLine(name)
  if depsInfo:HasDependencies() then label = label .. '\n\n' .. depsInfo:GetDependencyLabel() end
  desc = desc .. label
  return desc
end

--- @param name AddOnName
--- @param state boolean
--- @param flush boolean Flushes the AddOnDependencyDetails cache; defaults to false
function o:UpdateEnabledState(name, state, flush)
  flush = flush == true or false
  local currentlyEnabled = API:IsAddOnEnabled(name)
  if state == true and not currentlyEnabled then
    if flush then AceEvent:SendMessage(MSG.OnFlushAddOnDependenciesCache, libName) end
    return API:EnableAddOnForCharacter(name)
  elseif state == false and currentlyEnabled then
    if flush then AceEvent:SendMessage(MSG.OnFlushAddOnDependenciesCache, libName) end
    API:DisableAddOnForCharacter(name)
  end
end

function o.CreateGetFn(addOnName)
  --- @return boolean
  return function()
    local v = ns:profile().enabledAddons[addOnName] == true
    o:UpdateEnabledState(addOnName, v)
    return v
  end
end

--- @param addOnName Name
--- @param options AceConfigOption
function o.CreateSetFn(options, addOnName)
  return function(ctx, v)
    ns:profile().enabledAddons[addOnName] = v
    --@do-not-package@
    if ns:IsDev() then
      if String.IsAnyOf(addOnName, unpack(ns.debug.alwaysEnabledAddOns)) then
        ns:profile().enabledAddons[addOnName] = true
        v = true
      end
    end
    --@end-do-not-package@
    o:OnSyncCheckedStateWithRelatedAddOns(options, addOnName, v)
    o:UpdateEnabledState(addOnName, v, true)
    AceEvent:SendMessage(MSG.OnUpdateMinimapState, libName)
  end
end

--- @param name Name The addon name
function o.GetAddOnNameFn(name)
  return function() return o.GetDisplayName(name) end
end

--- @param name Name The addon name
function o.GetAddOnDescFn(name)
  return function()
    if not IsOptionsVisible then return '' end
    return o.GetDesc(name)
  end
end

function o:CreateAddOnCheckList()
  local order = self.order
  local options = self.addonsOptions

  API:ForEachAddOn(function(info)
    local name = info.name
    local searchText = SearchTextFor(info)
    options[name] = {
      order = order:next(),
      type = 'toggle',
      width = 1.3,
      arg = ADDON_ROW_ARG,
      get = o.CreateGetFn(name),
      hidden = function() return not MatchesSearch(searchText) end,
    }
    local opt = options[name]
    opt.set = o.CreateSetFn(options, name)
    opt.name = o.GetAddOnNameFn(name)
    opt.desc = o.GetAddOnDescFn(name)
  end)
end

--- Sits under the header, hanging onto the Add-Ons tab strip
--- @return AceConfigOption
function o:CreateSearchOption()
  return {
    type = 'input',
    name = L['Add-Ons::Search'],
    width = 'full',
    order = self.order:next(),
    dialogControl = SearchBox.Type,
    arg = {
      search = {
        onChange = function(query, widget) self:OnSearch(query, widget) end,
        focusOnShow = true,
      },
      -- Left of the All/None icons
      layout = { search = { x = -56, y = -7 } },
      helpTip = 'AddOnsSearch',
    } --[[@as ADS_Ace3WidgetArg]],
    get = function() return searchQuery end,
  }
end

--- @param query string
--- @param widget AceGUIWidget
function o:OnSearch(query, widget)
  searchQuery, searchNeedle = query, strtrim(query):lower()
  HelpTour:CompleteStep('AddOnsSearch')
  RefreshAddOnList(widget)
end

--- @return boolean
function o:AnyAddOnRowShown()
  for _, option in pairs(self.addonsOptions) do
    if IsAddOnRow(option) and not option.hidden() then return true end
  end
  return false
end

--- Binds the profile row's star to the current profile's favorite flag
--- @return ADS_Ace3WidgetFavoriteArg
function o:CreateFavoriteArg()
  local get, set = self.util:QuickProfileMenuGet(), self.util:QuickProfileMenuSet()
  return {
    get = function() return get() == true end,
    set = function(value)
      set(nil, value)
      HelpTour:CompleteStep('FavoriteStar')
    end,
    isFavorite = function(profile) return ns:db().char.showInQuickProfileMenu[profile] == true end,
    tooltip = function(tooltip)
      tooltip:SetText(L['Add to Favorite'], NORMAL_FONT_COLOR:GetRGB())
      tooltip:AddLine(L['Add to Favorite::Desc'], 1, 1, 1, true)
    end,
  }
end

--- Binds the profile row's reload button to Reload UI
--- @return ADS_Ace3WidgetReloadArg
function o:CreateReloadArg()
  return {
    onClick = function()
      HelpTour:CompleteStep('ReloadButton')
      self.util:SendEventMessage(GC.M.OnApplyAndRestart, libName)
    end,
    tooltip = function(tooltip)
      tooltip:SetText(L['Reload UI'], NORMAL_FONT_COLOR:GetRGB())
      tooltip:AddLine(L['Reload UI::Desc'], 1, 1, 1, true)
    end,
  }
end

--- @param localeKey string
--- @return fun(tooltip: GameTooltip)
local function ActionTooltip(localeKey)
  return function(tooltip)
    tooltip:SetText(L[localeKey], NORMAL_FONT_COLOR:GetRGB())
    tooltip:AddLine(L[localeKey .. '::Desc'], 1, 1, 1, true)
  end
end

--- A checked box; checks every add-on row
--- @return ADS_Ace3WidgetActionArg
function o:CreateEnableAllAction()
  return {
    atlas = 'checkbox-minimal',
    overlay = 'checkmark-minimal',
    onClick = function() self:SetAllToggles(true) end,
    tooltip = ActionTooltip('General::Enable All::Button'),
  }
end

--- An empty box; unchecks every add-on row
--- @return ADS_Ace3WidgetActionArg
function o:CreateDisableAllAction()
  return {
    atlas = 'checkbox-minimal',
    onClick = function() self:SetAllToggles(false) end,
    tooltip = ActionTooltip('General::Disable All::Button'),
  }
end

--- Header icons bypass Ace's execute path, so refresh by hand
--- @param value boolean
function o:SetAllToggles(value)
  HelpTour:CompleteStep('CheckAllNone')
  self:ForEachShownToggle(function(opt) opt.set({ isBulkOperation = true }, value) end)
  AceConfigRegistry:NotifyChange(ns.addon)
end

--- Rows hidden by the search are skipped
--- @param applyFn fun(option:AceConfigOption) | "function(option) end"
function o:ForEachShownToggle(applyFn)
  for _, option in pairs(self.addonsOptions) do
    if IsAddOnRow(option) and not option.hidden() then applyFn(option) end
  end
end

local AU = ns.O.AceConfigDialogUtil
AU:OnOpenAndClose(
  ns.addon,
  function(msgName, appName, container) IsOptionsVisible = true end,
  function(msgName, appName) IsOptionsVisible = false end
)
AU:AnchorTooltipToRow(ns.addon, ADDON_ROW_ARG)
