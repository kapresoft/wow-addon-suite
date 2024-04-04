--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace
local ns = select(2, ...)
local O, MSG = ns.O, ns.GC.M
local L = ns:AceLocale()
local sformat = ns.sformat
local libName = 'AddOnStateController'
--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
--- @class AddOnStateController : AceEvent
local S = ns:NewLibWithEvent(libName)
local p = ns:CreateDefaultLogger(libName)

--[[-----------------------------------------------------------------------------
Support Functions
-------------------------------------------------------------------------------]]
--- @param msg string
local function ShowReloadConfirm(msg)
    local v = 'DEV_RELOAD_CONFIRM'
    if not StaticPopupDialogs[v] then

        local text1 = L['REQUIRES_RELOAD_PROFILE_CHANGED']
        local baseMsg = sformat(':: %s ::\n\n\n%s\n\n', ns.name, text1)

        StaticPopupDialogs[v] = {
            text =  baseMsg .. '%s\n\n',
            button1 = YES,
            button2 = NO,
            OnAccept = function(self) S:OnApplyAndRestartNoConfirmation() end,
            timeout = 0,
            whileDead = true,
            hideOnEscape = true,
            showAlert = true,
        }
    end
    StaticPopup_Show(v, msg)
end

--[[-----------------------------------------------------------------------------
Mixin: AddOnStateDataMixin
-------------------------------------------------------------------------------]]
--- @class AddOnStateDataMixin
local D = {}
---@param o AddOnStateDataMixin
local function MethodsAndProps(o)
    --- @public
    --- @return AddOnStateDataMixin
    function o:New()
        return ns:K():CreateAndInitFromMixin(o)
    end
    --- @private
    function o:Init()
        self.enable = {}
        self.disable = {}
    end
    function o:DisableCount() return self.disable and #self.disable end
    function o:EnableCount() return self.enable and #self.enable end
    --- @param name Name AddOn Name
    function o:Enable(name)
        assert(name, "AddOn name is required.")
        return table.insert(self.enable, name)
    end
    --- @param name Name AddOn Name
    function o:Disable(name)
        assert(name, "AddOn name is required.")
        return table.insert(self.disable, name)
    end

    function o:IsEmpty()
        return self:EnableCount() <=0 and self:DisableCount() <= 0
    end
    function o:GetSummary()
        local summary = ''
        if self:EnableCount() > 0 then
            local enableText = GREEN_FONT_COLOR:WrapTextInColorCode('Enable')
            summary = summary .. enableText .. ': '
            summary = summary .. table.concat(self.enable, ", ")
        end
        if self:DisableCount() > 0 then
            summary = summary .. '\n\n'
            local disableText = RED_FONT_COLOR:WrapTextInColorCode('Disable')
            summary = summary .. disableText .. ': '
            summary = summary .. table.concat(self.disable, ", ")
        end

        return summary
    end
end; MethodsAndProps(D)

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
--- @param o AddOnStateController
local function PropsAndMethods(o)

    function o.OnApplyAndRestartNoConfirmation()
        local data = o:GetAddOnState(); if not data then return end

        if #data.enable then
            O.API:EnableAddOnsForCharacter(data.enable)
        end
        if #data.disable then
            O.API:DisableAddOnsForCharacter(data.disable)
        end
        ReloadUI()
    end

    --- Get AddOn States and Confirm Reload
    function o.OnAddOnStateChanged()
        local state = o:GetAddOnState()
        if state:IsEmpty() then return end

        --- Will call self:OnApplyAndRestart(..)
        if ns:global().minimap.confirm_reloads == true then
            ShowReloadConfirm(state:GetSummary())
            return
        end
        o.OnApplyAndRestartNoConfirmation()
    end

    --- Get AddOn States and Confirm Reload
    function o.OnAddOnStateChangedWithConfirmation()
        if ns:global().sync_addon_states ~= true then return end

        local state = o:GetAddOnState()
        if state:IsEmpty() then return end

        --- Will call self:OnApplyAndRestart(..)
        ShowReloadConfirm(state:GetSummary())
    end

    --- @return AddOnStateDataMixin
    function o:GetAddOnState()
        local API = O.API
        local addons = API:GetEnabledAddOns()
        if not addons then return end

        local addOnState = D:New()

        API:ForEachCheckedAndLoadableAddon(function(info)
            addOnState:Enable(info.name)
        end)
        API:ForEachAddOnThatCanBeDisabled(function(info)
            addOnState:Disable(info.name)
        end)

        p:d(function()
            return "enable=%s disable=%s empty=%s",
            addOnState.enable, addOnState.disable, addOnState:IsEmpty() end)

        return addOnState
    end

    function o.OnAddOnReady()
        o:RegisterMessage(MSG.OnApplyAndRestart, o.OnApplyAndRestartNoConfirmation)
        o:RegisterMessage(MSG.OnAddOnStateChanged, o.OnAddOnStateChanged)
        o:RegisterMessage(MSG.OnAddOnStateChangedWithConfirmation, o.OnAddOnStateChangedWithConfirmation)

        -- Initial prompt on login/reload
        o.OnAddOnStateChangedWithConfirmation()
    end

    o:RegisterMessage(MSG.OnAddOnReady, o.OnAddOnReady)

end; PropsAndMethods(S)
