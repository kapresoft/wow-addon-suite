--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type ADS_Namespace
local ns = select(2, ...)
local O, GC, M = ns.O, ns.GC, ns.M
local API = O.API
--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
local libName = 'Developer'
--- @class Developer
local o = {}
das = o
local p, t = ns:log(libName)

C_Timer.After(1, function() t('loaded...') end)

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
function o:en(nameOrIndex) return API:IsAddOnEnabled(nameOrIndex) end

-- Can Be Enabled
function o:cbe(addon)
  local info = O.API:GetDependencyDetails(addon)
  return info:CanBeEnabled()
end

--- @return table<number, { label: string, key: string? }>
local function CharacterKeys()
  return {
    { label = 'all (nil)', key = nil },
    { label = 'UnitName', key = UnitName('player') },
    { label = 'UnitGUID', key = UnitGUID('player') },
  }
end

--- @param state Enum.AddOnEnableState
--- @return string
local function StateName(state)
  for name, value in pairs(Enum.AddOnEnableState) do
    if value == state then return name end
  end
  return tostring(state)
end

--- Prints the add-on's enable state read with each form
--- of the character argument.
--- ### Example:
--- ```lua
--- das:EnableState('ActionbarPlus')
--- ```
--- @param addOn string
function o:EnableState(addOn)
  print(('[das] %s enable state:'):format(addOn))
  for _, c in ipairs(CharacterKeys()) do
    local state = C_AddOns.GetAddOnEnableState(addOn, c.key)
    print(('  %-10s %-28s %s'):format(c.label, tostring(c.key), StateName(state)))
  end
end

--- Flips the add-on's enable state for this character by
--- GUID, then prints every form again.
--- ### Example:
--- ```lua
--- das:ToggleByGUID('ActionbarPlus')
--- ```
--- @param addOn string
function o:ToggleByGUID(addOn)
  local guid = UnitGUID('player')
  local enabled = C_AddOns.GetAddOnEnableState(addOn, guid) > Enum.AddOnEnableState.None
  if enabled then
    C_AddOns.DisableAddOn(addOn, guid)
  else
    C_AddOns.EnableAddOn(addOn, guid)
  end
  print(('[das] %s by GUID: %s'):format(enabled and 'disabled' or 'enabled', addOn))
  self:EnableState(addOn)
end
