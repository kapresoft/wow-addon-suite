--[[-----------------------------------------------------------------------------
Type: AddOnStateData
-------------------------------------------------------------------------------]]
--- @class AddOnStateData

--[[-----------------------------------------------------------------------------
Type: CheckedState
-------------------------------------------------------------------------------]]
--- @class CheckedState

--[[-----------------------------------------------------------------------------
Blizzard Vars
-------------------------------------------------------------------------------]]
local C_AddOns_GetAddOnInfo = C_AddOns.GetAddOnInfo or GetAddOnInfo

--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace
local ns = select(2, ...)

local O, MSG, API = ns.O, ns.GC.M, ns.O.API
local K, L        = ns:K(), ns:AceLocale()

local DEV_RELOAD_CONFIRM_DLG = 'DEV_RELOAD_CONFIRM'

local c1 = K:cf(RED_FONT_COLOR)
local c1L = K:cfHex('FB7E7Ecf')
local c2 = K:cf(YELLOW_FONT_COLOR)
local c3 = K:cf(GREEN_FONT_COLOR)
local c4 = K:cf(LIGHTGRAY_FONT_COLOR)
local ca = K:cf(BLUE_FONT_COLOR)


--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
local libName = ns.M.AddOnStateController()
local libNameShort = 'AOSC'
--- @class AddOnStateController
local S = ns:NewLibWithEvent(libName)
ns:AceHook(S)
local p = ns:LC().STATE:NewLogger(libNameShort)

--[[-----------------------------------------------------------------------------
Support Functions
-------------------------------------------------------------------------------]]
---@param detailsText string
local function ShowReloadConfirm(detailsText)
    if not StaticPopupDialogs[DEV_RELOAD_CONFIRM_DLG] then
        StaticPopupDialogs[DEV_RELOAD_CONFIRM_DLG] = {
            text = ":: %s ::\n\n\n%s",
            button1 = YES,
            button2 = NO,
            timeout = 0,
            whileDead = true,
            hideOnEscape = true,
            showAlert = true,
            OnAccept = function(self) S:OnApplyAndRestartNoConfirmation() end,
            OnCancel = function(self, data, reason)
                S:SendMessage(MSG.OnUpdateMinimapIconState, ns.name)
            end,
        }
    end
    local dlgMsg = L['REQUIRES_RELOAD_PROFILE_CHANGED'] .. '\n\n'
    StaticPopup_Show(DEV_RELOAD_CONFIRM_DLG, ns.name, dlgMsg)
end

--- Converts a table into a string with elements separated by ", " and a newline every 5 elements.
--- @param tbl table The table to be converted into a string.
--- @return string The formatted string.
---@param wrapEvery number
function TableToString(tbl, wrapEvery)
    local result = {}
    for i, value in ipairs(tbl) do
        -- Append the current value to the result table.
        table.insert(result, tostring(value))
        -- Check if the current index is a multiple of 5.
        if i % wrapEvery == 0 then
            -- Append a newline if it's the 5th element.
            table.insert(result, "\n")
        else
            -- Otherwise, append a comma and space, unless it's the last element.
            if i ~= #tbl then
                table.insert(result, ", ")
            end
        end
    end
    -- Concatenate all parts of the result table into a single string.
    return table.concat(result)
end

-- Define return codes
--- @class AddOnStateCodes
local AddOnStateCodes = {
    NOT_INSTALLED          = 0,
    ENABLED_BUT_NOT_LOADED = 1,
    DISABLED_BUT_LOADED    = 2,
    LOAD_ON_DEMAND         = 3,
    NO_ACTION_REQUIRED     = 4,
}
local asc = AddOnStateCodes; do
    local _names = {}
    for name, code in pairs(AddOnStateCodes) do
        if type(code) == 'number' then
            _names[code] = ns.sformat('%s(%s)', name, code)
        end
    end
    --- @param code number
    function asc:Get(code) return c4(_names[code] or 'UNKNOWN') end
end

--- Checks if an addon is enabled but requires a restart or is load on demand.
--- @param name AddOnName The name of the addon to check.
--- @return boolean, number True if the addon requires a restart, the code, and a message.
local function CheckAddonState(name)
    local _name = C_AddOns_GetAddOnInfo(name)
    if not _name then return false, AddOnStateCodes.NOT_INSTALLED end
    local enabled = GetAddOnEnableState(UnitName("player"), name) > 0
    local loaded = API:IsAddOnLoaded(name)
    local loadOnDemand = API:IsAddOnLoadOnDemand(name)

    if loadOnDemand then
        return false, AddOnStateCodes.LOAD_ON_DEMAND
    elseif enabled and not loaded then
        return true, AddOnStateCodes.ENABLED_BUT_NOT_LOADED
    elseif not enabled and loaded then
        return true, AddOnStateCodes.DISABLED_BUT_LOADED
    else
        return false, AddOnStateCodes.NO_ACTION_REQUIRED
    end
end

local function _cond(n)
    return ns:String().IsAnyOf(n, 'ActionbarPlus', 'Bagnon', 'BagBrother',
                               'Bagnon_GuildBank', 'Scrap', 'Scrap_Config')
end

---@param info AddOnInfo
local function _DebugCheckedState(info, requiresRestart, statusCode)
    local n = info.name
    local loaded, onDemand = API:IsAddOnLoaded(n), API:IsAddOnLoadOnDemand(n)
    local enabled = ns:KO().AddonUtil:IsAddOnEnabled(n)
    local depsInfo = API:GetDependencyDetails(n)
    if _cond(n) then
        local nn = ca(n)
        local rr = requiresRestart
        local od = onDemand
        local _enabled = (enabled and c3(enabled)) or c1L(enabled)
        local _loaded = loaded; if loaded == true then _loaded = c3(loaded) end
        local cbe = (depsInfo:CanBeEnabled() and c3(depsInfo:CanBeEnabled())) or c1L(depsInfo:CanBeEnabled())
        if requiresRestart then rr = c1(rr) end
        if onDemand == true then od = c2(od) end

        p:f1(function()
            return '[%s]:: enabled=%s can-be-enabled=%s loaded=%s '
                    .. 'on-demand=%s status=%s requires-restart=%s',
                    nn, _enabled, cbe, _loaded, od, AddOnStateCodes:Get(statusCode), rr
        end)
    end
end

--[[-----------------------------------------------------------------------------
Mixin: CheckedStateMixin
-------------------------------------------------------------------------------]]
--- @class CheckedStateMixin
local CheckedStateMixin = { }
--- @return CheckedState
function CheckedStateMixin:New() return K:CreateAndInitFromMixin(CheckedStateMixin) end

do
    --- @type CheckedState
    local o = CheckedStateMixin

    --- @private
    function o:Init()
        self.checkedButNotLoaded = {}
        self.loadedButNotChecked = {}
    end

    function o:GetCheckedButNotLoadedCount()
        return (self.checkedButNotLoaded and #self.checkedButNotLoaded) or 0
    end

    function o:GetLoadedButNotCheckedCount()
        return (self.loadedButNotChecked and #self.loadedButNotChecked) or 0
    end

    function o:GetCount() return self:GetCheckedButNotLoadedCount() + self:GetLoadedButNotCheckedCount() end

    --- @param singleLine boolean|nil
    function o:summary(singleLine)
        singleLine = singleLine or true

        local summary = ''
        if #self.checkedButNotLoaded > 0 then
            local enableText = GREEN_FONT_COLOR:WrapTextInColorCode('CheckedButNotLoaded')
            summary = summary .. enableText .. ': '
            summary = summary .. table.concat(self.checkedButNotLoaded, ", ")
        end
        if #self.loadedButNotChecked > 0 then
            if not singleLine then summary = summary .. '\n\n' end
            local disableText = ' ' .. RED_FONT_COLOR:WrapTextInColorCode('LoadedButNotChecked')
            summary = summary .. disableText .. ': '
            summary = summary .. table.concat(self.loadedButNotChecked, ", ")
        end

        return summary
    end

    ---@param tooltip GameTooltip
    function o:tooltipSummary(tooltip)
        if #self.checkedButNotLoaded > 0 then
            tooltip:AddLine('\n')
            tooltip:AddLine(L['Enabled (After Reload)'] .. ':', GREEN_FONT_COLOR:GetRGB())
            tooltip:AddLine('  • ' .. TableToString(self.checkedButNotLoaded, 5))
        end
        if #self.loadedButNotChecked > 0 then
            tooltip:AddLine('\n')
            tooltip:AddLine(L['Disabled (After Reload)'] .. ':', RED_FONT_COLOR:GetRGB())
            tooltip:AddLine('  • ' .. TableToString(self.loadedButNotChecked, 5))
        end
        if self:GetCount() > 0 then tooltip:AddLine('\n') end
    end

    function o:IsInSync() return #self.checkedButNotLoaded <= 0 and #self.loadedButNotChecked <= 0 end
end

--[[-----------------------------------------------------------------------------
Mixin: AddOnStateDataMixin
-------------------------------------------------------------------------------]]
--- @class AddOnStateDataMixin
local D = {}

--- @public
--- @return AddOnStateData
function D:New() return ns:K():CreateAndInitFromMixin(D) end

do
    --- @type AddOnStateData
    local asd = D

    --- @private
    function asd:Init()
        self.enable = {}
        self.disable = {}
    end
    function asd:DisableCount() return self.disable and #self.disable end
    function asd:EnableCount() return self.enable and #self.enable end
    --- @param name Name AddOn Name
    function asd:Enable(name)
        assert(name, "AddOn name is required.")
        return table.insert(self.enable, name)
    end
    --- @param name Name AddOn Name
    function asd:Disable(name)
        assert(name, "AddOn name is required.")
        return table.insert(self.disable, name)
    end

    function asd:IsEmpty()
        return self:EnableCount() <=0 and self:DisableCount() <= 0
    end
    --- @param singleLine boolean|nil
    function asd:summary(singleLine)
        singleLine = singleLine == true
        local summary = ''
        if self:EnableCount() > 0 then
            local enableText = GREEN_FONT_COLOR:WrapTextInColorCode('Enable')
            summary = summary .. enableText .. ': '
            summary = summary .. table.concat(self.enable, ", ")
        end
        if self:DisableCount() > 0 then
            if not singleLine then summary = summary .. '\n\n' end
            local disableText = ' ' .. RED_FONT_COLOR:WrapTextInColorCode('Disable')
            summary = summary .. disableText .. ': '
            summary = summary .. table.concat(self.disable, ", ")
        end

        return summary
    end
end

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
--- @type AddOnStateController | AceEventInterface | AceHookInterface
local o = S
--- @private
--- @param preview boolean|nil
function o:SynchronizeAddOns(preview)
    preview = preview == true

    local inSync, checkBoxState, dataState = self:GetSynchronizedState()
    p:d(function() return 'SynchronizeAddOns() in-sync: %s summary=%s check-state-summary=%s',
                inSync, dataState:summary(true), checkBoxState:summary(true) end)
    if preview or dataState:IsEmpty() then return end

    if dataState:EnableCount() > 0 then
        O.API:EnableAddOnsForCharacter(dataState.enable)
    end
    if dataState:DisableCount() > 0 then
        O.API:DisableAddOnsForCharacter(dataState.disable)
    end
end

function o.OnApplyAndRestartNoConfirmation()
    p:f1('OnApplyAndRestartNoConfirmation() called...')
    ReloadUI()
end

--- The dialog automatically synchronizes the addons. No need ot call SynchronizeAddOns()
function o.OnApplyAndRestart()
    p:f1('OnApplyAndRestart() called...')
    o.OnApplyAndRestartNoConfirmation()
end

--- Get AddOn States and Confirm Reload
--- Thi minimap doesn't synchronize when switching profiles so we need to call SynchronizeAddOns()
function o.OnAddOnStateChanged()
    o:SendMessage(MSG.OnUpdateMinimapIconState, ns.name)
    o:SynchronizeAddOns()
    if o:IsInSync() then return end

    if ns:global().minimap.confirm_reloads == true then
        return ShowReloadConfirm()
    end
    o.OnApplyAndRestartNoConfirmation()
end

--- Blizzard Detection for Reload Required
--- @private
--- @return boolean
function o:IsInSyncBlizzard() return AddonList_HasAnyChanged() ~= true end

--- @return boolean, CheckedState
function o:IsInSync()
    local state = self:GetCheckedState()
    return state:IsInSync(), state
end

--- If out of sync, always show Confirmation after closing the settings dialog
--- The dialog automatically synchronizes the addons. No need ot call SynchronizeAddOns()
function o.OnHideSettings()
    o:SendMessage(MSG.OnUpdateMinimapIconState, ns.name)
    if ns:global().sync_addon_states ~= true then return end
    o:SynchronizeAddOns(true)
    if o:IsInSync() == true then return end
    return ShowReloadConfirm();
end

function o.OnHideSettingsBlizzardAddonsList()
    p:f1("OnHideSettingsBlizzardAddonsList called..")
end

--- @return boolean, CheckedState, AddOnStateData
function o:GetSynchronizedState()
    local checkState = self:GetCheckedState()
    return checkState:IsInSync(), checkState, self:GetAddOnState()
end

--- @return AddOnStateData
function o:GetAddOnState()
    local addons = ns:profile().enabledAddons
    if not addons then return end

    local addOnState = D:New()

    API:ForEachCheckedAndLoadableAddon(function(name)
        addOnState:Enable(name)
    end)
    API:ForEachAddOnThatCanBeDisabled(function(name)
        addOnState:Disable(name)
    end)

    p:f2(function()
        return "enable=%s disable=%s empty=%s",
        addOnState.enable, addOnState.disable, addOnState:IsEmpty() end)

    return addOnState
end

--- @return CheckedState The state of the addOn checkboxes compared to the Enabled state of the addOn
function o:GetCheckedState()
    local state = CheckedStateMixin:New()
    API:ForEachAddOn(function(info)
        local n = info.name
        local requiresRestart, status = CheckAddonState(n)
        --@do-not-package@
        if ns:IsDev() then _DebugCheckedState(info, requiresRestart, status) end
        --@end-do-not-package@
        if AddOnStateCodes.LOAD_ON_DEMAND == status then return state end

        local depsInfo = API:GetDependencyDetails(n)
        if AddOnStateCodes.ENABLED_BUT_NOT_LOADED == status and depsInfo:CanBeEnabled() then
            table.insert(state.checkedButNotLoaded, n)
        elseif AddOnStateCodes. DISABLED_BUT_LOADED == status then
            table.insert(state.loadedButNotChecked, n)
        end
    end)
    return state
end

function o.OnAfterOnAddOnReady()
    o:RegisterMessage(MSG.OnApplyAndRestart, o.OnApplyAndRestart)
    o:RegisterMessage(MSG.OnHideSettings, o.OnHideSettings)
    o:RegisterMessage(MSG.OnAddOnStateChanged, o.OnAddOnStateChanged)
    o:RegisterMessage(MSG.OnAfterOnAddOnReady, o.OnAfterOnAddOnReady)

    local success, res = pcall(function()
        o:SecureHook(AddonList, 'Hide', function()
            o.OnHideSettingsBlizzardAddonsList()
        end)
    end)
    if not success then
        -- can be ignored
        p:d(function()
            return ORANGE_THREAT_COLOR:WrapTextInColorCode("OnAddOnReady::SecureHook(This can be ignored):")
                    .. " failed: %s", res end)
    end
    o:SendMessage(MSG.OnUpdateMinimapIconState, ns.name)
end

o:RegisterMessage(MSG.OnAfterOnAddOnReady, o.OnAfterOnAddOnReady)
