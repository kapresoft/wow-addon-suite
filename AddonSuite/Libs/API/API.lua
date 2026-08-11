--[[-----------------------------------------------------------------------------
Blizzard Vars
-------------------------------------------------------------------------------]]
local GetNumAddOns = GetNumAddOns or C_AddOns.GetNumAddOns
local EnableAddOn, DisableAddOn =
  EnableAddOn or C_AddOns.EnableAddOn, DisableAddOn or C_AddOns.DisableAddOn
local IsAddOnLoaded = C_AddOns.IsAddOnLoaded or IsAddOnLoaded
local C_Timer_NewTicker, C_Timer_After = C_Timer.NewTicker, C_Timer.After
local GetAddOnMetadata = C_AddOns.GetAddOnMetadata or GetAddOnMetadata
--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type ADS_Namespace
local ns = select(2, ...)

local O, M = ns.O, ns.M
local AU, String = O.AddonUtil, O.String
local IsAnyOfString, EqualsIgnoreCase = String.IsAnyOf, String.EqualsIgnoreCase

local excludedAddOns = { ns.addon, 'DebugChatFrame' }
local sformat = ns.sformat

local function depUtil() return O.AddOnDependencyUtil end

--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
local libName = M.API()
--- @class API
local o = ns:Register(libName, {})
local p, t = ns:log(libName)

--[[-----------------------------------------------------------------------------
Support Functions
-------------------------------------------------------------------------------]]
--- @return boolean Returns true if it is to be included
--- @param info AddOnInfo
local function developerAddOnsPredicateFn(info)
  local include = not IsAnyOfString(info.name, unpack(excludedAddOns))
  return include
end

--[[-----------------------------------------------------------------------------
AddOn Dependencies Cache
-------------------------------------------------------------------------------]]
--- @class AddOnInfoDetail : AddOnInfo
--- @field desc string The info.notes description part

--[[-----------------------------------------------------------------------------
AddOnCache
-------------------------------------------------------------------------------]]
--- @type table<Index, AddOnName>
local LocalCache = { info = {} }

do
  local c = LocalCache
  local function pfn(n) return ns.sformat(libName .. '::Cache:: %s', n) end
  --- @param name AddOnName
  --- @return AddOnInfoDetail
  function c:GetInfo(name)
    if self.info[name] == nil then
      --- @type AddOnInfoDetail
      local info = AU:GetAddOnInfo(name)
      info.desc = string.gsub(info.notes or '', "[\|n]+$", "")
      self.info[name] = info
    end
    return self.info[name]
  end
end

--- @param index Index The AddOnIndex
--- @return AddOnName, boolean, Enabled
local function GetAddOnExtraInfo(index)
  local info = AU:GetAddOnInfo(index)
  local name = info.name
  local lod = o:IsAddOnLoadOnDemand(name)
  local enabled = o:IsAddOnEnabled(name)
  return name, lod, enabled
end

--[[-----------------------------------------------------------------------------
Instance Methods
-------------------------------------------------------------------------------]]
--- @param indexOrName Name|Index
--- @return AddOnInfoDetail
function o:GetAddOnInfo(indexOrName)
  local name = indexOrName
  local c = LocalCache
  if c.info[name] == nil then
    --- @type AddOnInfoDetail
    local info = AU:GetAddOnInfo(name)
    info.desc = string.gsub(info.notes or '', '[|n]+$', '')
    c.info[name] = info
  end
  return c.info[name]
end

function o:GetUIScale()
  local useUiScale = GetCVar('useUiScale') -- This returns "1" if UI scaling is enabled, "0" otherwise.
  if useUiScale == '1' then
    local uiScale = GetCVar('uiScale') -- Get the UI scale setting.
    return tonumber(uiScale) -- Convert to number for calculations.
  else
    return 1 -- UI scaling is not enabled, so scale is effectively 1.
  end
end

function o:GetEnabledAndInstalledAddOns()
  local toRemove = {}
  for name in pairs(ns:profile().enabledAddons) do
    local addOn = self:GetAddOnInfo(name)
    if addOn:IsMissing() then table.insert(toRemove, name) end
  end
  for _, name in ipairs(toRemove) do
    ns:profile().enabledAddons[name] = nil
  end

  return ns:profile().enabledAddons
end

function o:GetEnabledAddOns() return self:GetEnabledAndInstalledAddOns() end

function o:IsTitanPanelAvailable() return type(TitanPanelButton_OnShow) == 'function' end

--- @param indexOrName IndexOrName
--- @return Enabled
function o:IsAddOnEnabled(indexOrName) return AU:IsAddOnEnabled(indexOrName) end

--- @param indexOrName IndexOrName
--- @return Enabled
function o:IsAddOnDisabled(indexOrName) return not self:IsAddOnEnabled(indexOrName) end

--- @param indexOrName Name|IndexOrName
--- @return boolean
function o:IsAddOnLoadOnDemand(indexOrName)
  return AddonList_IsAddOnLoadOnDemand(indexOrName) == true
end

--- @param indexOrName IndexOrName
--- @boolean
function o:IsAddOnLoaded(indexOrName) return IsAddOnLoaded(indexOrName) end

--  TODO: New Option to "Sort By Index", checked by default, else sort by name
--- @param callbackFn AddOnCallbackFn
function o:ForEachAddOn(callbackFn)
  return self:ForAllAddOns(callbackFn, developerAddOnsPredicateFn, true)
end

---@param name Name
function o:IsAddOnLibraryType(name)
  local type = GetAddOnMetadata(name, 'Category') or GetAddOnMetadata(name, 'X-Category') or ''
  return EqualsIgnoreCase(type, 'libraries') or EqualsIgnoreCase(type, 'library')
end

--- @param callbackFn AddOnCallbackFn
--- @param predicateFn fun(info:AddOnInfo) | "function(info) return true end" | "A function that returns true to accept the element"
---@param sortByName boolean|nil Defaults to true
function o:ForAllAddOns(callbackFn, predicateFn, sortByName)
  sortByName = sortByName or true

  local addOnCount = GetNumAddOns()
  if addOnCount <= 0 then return end

  local addOns = {}
  for i = 1, addOnCount do
    local info = AU:GetAddOnInfo(i)
    info.sortKey = info.name
    if self:IsAddOnLibraryType(info.name) then info.sortKey = '!!A' .. info.name end
    table.insert(addOns, info)
    if not sortByName and predicateFn and predicateFn(info) then callbackFn(info) end
  end
  if not sortByName then return end

  --- @param a AddOnInfo
  --- @param b AddOnInfo
  table.sort(addOns, function(a, b) return a.sortKey < b.sortKey end)
  for _, info in pairs(addOns) do
    if predicateFn and predicateFn(info) then callbackFn(info) end
  end
end

--- @param callbackFn fun(name:AddOnName) | "function(name) end"
function o:ForEachCheckedAndLoadableAddon(callbackFn)
  local addons = self:GetEnabledAddOns()
  if not addons then return end
  for name, checked in pairs(addons) do
    if checked == true then callbackFn(name) end
  end
end

--- @param callbackFn fun(name:AddOnName) | "function(name) end"
function o:ForEachAddOnThatCanBeDisabled(callbackFn)
  local addons = self:GetEnabledAddOns()
  if not addons then return end

  local addOnCount = GetNumAddOns()
  if addOnCount <= 0 then return end

  for addOnIndex = 1, addOnCount do
    local name, lod, enabled = GetAddOnExtraInfo(addOnIndex)
    local checked = addons[name] == true
    local validCandidate = ns.addon ~= name and checked ~= true and not lod and enabled == true
    if validCandidate == true then callbackFn(name) end
  end
end

--- @param name Name The addOn name
--- @param charName Name|nil The character name. Defaults to current
function o:EnableAddOnForCharacter(name, charName)
  assert(name, 'AddOn name is required.')
  charName = charName or UnitName('player')
  EnableAddOn(name, charName)
end

--- @param name Name The addOn name
--- @param charName Name|nil The character name. Defaults to current
function o:DisableAddOnForCharacter(name, charName)
  assert(name, 'AddOn name is required.')
  charName = charName or UnitName('player')
  DisableAddOn(name, charName)
end

--- @param addOnNames table<number, Name> The array of addOn names
function o:EnableAddOnsForCharacter(addOnNames)
  assert(type(addOnNames) == 'table', 'AddOn names array are required.')
  if #addOnNames <= 0 then return end
  local charName = UnitName('player')
  for _, name in ipairs(addOnNames) do
    self:EnableAddOnForCharacter(name, charName)
  end
end

--- @param addOnNames table<number, Name> The array of addOn names
function o:DisableAddOnsForCharacter(addOnNames)
  assert(type(addOnNames) == 'table', 'AddOn names array are required.')
  if #addOnNames <= 0 then return end
  local charName = UnitName('player')
  for _, name in ipairs(addOnNames) do
    self:DisableAddOnForCharacter(name, charName)
  end
end

--- @param addOnName Name
--- @return AddOnDependencyDetails
--- @param useCache boolean defaults to true
function o:GetDependencyDetails(addOnName, useCache)
  return depUtil():GetDependencyDetails(addOnName, useCache)
end

function o:PrefetchAddOnInfo()
  local function PrefetchWithTicker(coThread)
    local throttleInterval = 0.1
    local batchSize = 20
    local maxIterations = 100
    local iterations = 0

    -- Create a ticker to resume the coroutine at regular intervals
    --- @type Ticker
    local ticker

    ticker = C_Timer_NewTicker(throttleInterval, function()
      iterations = iterations + 1
      local processed = 0

      while processed < batchSize and coroutine.status(coThread) == 'suspended' do
        local ok = coroutine.resume(coThread)
        if not ok then break end
        processed = processed + 1
      end

      if
        coroutine.status(coThread) ~= 'suspended'
        or processed == 0
        or iterations >= maxIterations
      then
        ticker:Cancel()
      end
    end)
  end

  local function ProcessAddOnInfo()
    self:ForEachAddOn(function(info)
      local name = info.name
      self:GetAddOnInfo(name)
      self:GetDependencyDetails(name)
      coroutine.yield(name)
    end)
  end

  local co = coroutine.create(ProcessAddOnInfo)
  C_Timer_After(5, function() PrefetchWithTicker(co) end)
end
