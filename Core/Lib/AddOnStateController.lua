--[[-----------------------------------------------------------------------------
Type: AddOnStateData
-------------------------------------------------------------------------------]]
--- @class AddOnStateData

--[[-----------------------------------------------------------------------------
Type: CheckedState
-------------------------------------------------------------------------------]]
--- @class CheckedState

--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace
local ns = select(2, ...)

local O, MSG, API = ns.O, ns.GC.M, ns.O.API
local K, L        = ns:K(), ns:AceLocale()

local DEV_RELOAD_CONFIRM_DLG = 'DEV_RELOAD_CONFIRM'
--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
local libName = ns.M.AddOnStateController()
--- @class AddOnStateController
local S = ns:NewLibWithEvent(libName)
ns:AceHook(S)
local p = ns:CreateDefaultLogger(libName)

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

--- @return boolean, CheckedState, AddOnStateDataMixin
function o:GetSynchronizedState()
    local checkState = self:GetCheckedState()
    return checkState:IsInSync(), checkState, self:GetAddOnState()
end

--- @return AddOnStateDataMixin
function o:GetAddOnState()
    local addons = ns:profile().enabledAddons
    if not addons then return end

    local addOnState = D:New()

    API:ForEachCheckedAndLoadableAddon(function(info)
        addOnState:Enable(info.name)
    end)
    API:ForEachAddOnThatCanBeDisabled(function(info)
        addOnState:Disable(info.name)
    end)

    p:f1(function()
        return "enable=%s disable=%s empty=%s",
        addOnState.enable, addOnState.disable, addOnState:IsEmpty() end)

    return addOnState
end

--- @return CheckedState
function o:GetCheckedState()
    local _m = 'GetCheckedState()'
    local addons = ns:profile().enabledAddons
    local state = CheckedStateMixin:New()
    for n, checked in pairs(addons) do
        local ai = O.AddOnManagerMixin:New(n)
        if checked == true and ai.loadable then
            local loaded, onDemand = API:IsAddOnLoaded(n), API:IsAddOnLoadOnDemand(n)
            local hasDisabledDeps = not ai.dependencyEnabled
            if not (loaded or onDemand or hasDisabledDeps) then
                p:f1(function() return '%s [%s] checked but not loaded', _m, n end);
                table.insert(state.checkedButNotLoaded, n)
            end
        elseif not checked and not ai.loadable and ai.loaded then
            -- TODO: Retail behavior different when disabling 'AddonUsage'
            -- Going from enabled to disabled (unchecked), still shows as syncd.
            if not ai.loadOnDemand then
                p:f1(function() return '%s [%s] Loaded but not checked', _m, n end);
                table.insert(state.loadedButNotChecked, n)
            end
        end
    end
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
