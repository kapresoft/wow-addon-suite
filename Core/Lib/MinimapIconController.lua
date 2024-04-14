--[[-----------------------------------------------------------------------------
Type: MinimapButton
-------------------------------------------------------------------------------]]
--- @class MinimapButton
--- @field icon TextureBase

--[[-----------------------------------------------------------------------------
Type: MinimapIconProfilesMenuItem
-------------------------------------------------------------------------------]]
--- @class MinimapIconProfilesMenuItem
--- @field text Name
--- @field isTitle boolean
--- @field notCheckable boolean
--- @field checked boolean
--- @field func fun() | "function() end" | "A function action handler"
--- @field _sortKey string The sort key (Custom Field)
--- @type table<number, MinimapIconProfilesMenuItem>

--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace
local ns = select(2, ...)
local API, MSG, C = ns.O.API, ns.GC.M, ns.GC.C

local LibDBIcon = ns:LibDBIcon()
local LibDataBroker = ns:LibDataBroker()

local L = ns:AceLocale()
local minimapName = ns.name
local libName = 'MinimapIconController'
--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
--- @class MinimapIconController : BaseLibraryObject_WithAceEvent
local S = ns:NewLibWithEvent(libName)
local p = ns:LC().MINIMAP:NewLogger(libName)
local pm = ns:LC().MESSAGE:NewLogger(libName)
local icon     = "Interface/AddOns/AddonSuite/Core/Assets/addon-icon.tga"
local iconRed     = "Interface/AddOns/AddonSuite/Core/Assets/addon-icon-red.tga"
local iconText = ns.sformat('|T%s:18:18:0:0|t', icon)
-- red-ish color
local iconOutOfSyncColor = CreateColor(1, 0.3, 0.3, 1)
local textOutOfSyncColor = L['Current Profile Color::OutOfSync']
local profileInSyncColor = L['Current Profile Color']
local currentSymbol = L['Current::Symbol::Minimap']

--[[-----------------------------------------------------------------------------
Support Functions
-------------------------------------------------------------------------------]]
local function IsConfirmReload()
    local minimap = ns:db().global.minimap
    return minimap and minimap.confirm_reloads == true
end

--- This local function is dynamic and needs to be here
local function GetConfirmReloadText()
    local confirmationText = ns.ch:T('Currently configured to load %s confirmation')
    local without      = L['without']
    local with         = L['with']

    local text = ns.sformat(confirmationText, ns.ch:S(with))
    if not IsConfirmReload() then
        text = ns.sformat(confirmationText, ns.ch:S(without))
    end
    return text
end

local function FC(hexColor, text) return ns.ch:FormatColor(hexColor, text) end
local function FCOS(text) return ns.ch:FormatColor(textOutOfSyncColor, text) end

--- The global UIDROPDOWNMENU_OPEN_MENU is non-nil whenever a drop-down is showing
--- @return boolean
local function IsDropDownShowing() return UIDROPDOWNMENU_OPEN_MENU ~= nil end

local function IsHide() return ns:global().minimap.hide == true end
local function IsShownInTP() return ns:db().char.shownInTitanPanel == true end
local function IsHideWhenInTP() return ns:global().minimap.hide_when_titan_panel_added == true end

---@param tooltip _GameTooltip
---@param inSync boolean
local function OutOfSyncMessage(tooltip, inSync)
    if inSync == true then return end
    local msg = FCOS(L['Profile is out of sync']) .. '. '
    tooltip:AddLine(msg)
    tooltip:AddLine(L['Click Key To Sync'] .. '.\n\n')
end

--- @param inSync boolean
local function CurrentProfileText(inSync)
    local currentProfile = ns:db():GetCurrentProfile()
    local profText = ns.ch:T(L['Current Profile'])
    local prof = FC(profileInSyncColor, currentProfile)
    if not inSync then prof = FCOS(currentProfile) end
    return profText, prof
end

--- @param self MinimapIconController
local function OnOutOfSyncIndicator(self)
    if ns:global().minimap.sync_status_indicator ~= true then
        return self:UpdateOutOfSyncIndicator(true)
    end
    local inSync, details = self:IsInSync()
    self:UpdateOutOfSyncIndicator(inSync, details)
end

--- Toggles (Show/Hide state)
--- @param self MinimapIconController
local function OnToggleMinimapIcon(self) self:SetShowOnMinimap(not IsHide()) end

--- @param self MinimapIconController
local function OnToggleMinimapIconTitanPanel(self)
    if IsHide() or (IsShownInTP() and IsHideWhenInTP()) then
        return self:SetShowOnMinimap(false)
    end
    self:SetShowOnMinimap(true)
end

--- @param self MinimapIconController
--- @param profileName string
local function OnSwitchProfile(self, profileName)
    assert(profileName, "Profile Name is missing.")
    p:f1(function() return "OnSwitchProfile: %s", profileName end )
    ns:db():SetProfile(profileName)
    ns:a():CloseConfig()
    self:SendMessage(MSG.OnAddOnStateChanged, libName)
end

--- @param self MinimapIconController
local function OnTitanPanelHide(self)
    ns:db().char.shownInTitanPanel = false
    if IsHide() then return end
    self:SetShowOnMinimap(true)
end

--- @param self MinimapIconController
--- @param tooltip _GameTooltip
local function OnTooltipShow(self, tooltip)
    if IsDropDownShowing() then return end
    if not tooltip or not tooltip.AddLine then return end
    self.tooltip = tooltip

    OnOutOfSyncIndicator(self)

    local inSync, checkedState = self:IsInSync()
    local currentProfileText, currentProfile = CurrentProfileText(inSync)
    local confirmationLine = GetConfirmReloadText()

    local header1 = ns.sformat('%s %s', iconText, ns.ch:P(ns.GC.C.FRIENDLY_NAME))
    local header3 = ns.sformat('%s: %s', currentProfileText, currentProfile)

    tooltip:AddDoubleLine(header1, header3)
    tooltip:AddLine(ns.locale.lineSeparator1)
    OutOfSyncMessage(tooltip, inSync)
    tooltip:AddLine(confirmationLine)
    tooltip:AddLine(' ')

    local commandLines = ns.ch:P(L['Command Lines'] .. ":")
    if not inSync then
        local syncKey = FCOS(L['ALT-LEFT-Click'])
        tooltip:AddDoubleLine(syncKey, ns.ch:T(L['Sync with Profile and Reload']))
    end
    tooltip:AddDoubleLine(ns.ch:S(L['LEFT-Click']), ns.ch:T(L['View or switch profiles']))
    tooltip:AddDoubleLine(ns.ch:S(L['RIGHT-Click']), ns.ch:T(L['Open settings dialog']))

    tooltip:AddDoubleLine(ns.ch:S(L['SHIFT-RIGHT-Click']), ns.ch:T(L['Open minimap settings dialog']))
    tooltip:AddLine(' ')
    tooltip:AddLine(commandLines)
    local cmdLine = ns.sformat("/%s or /%s", C.CONSOLE_COMMAND_NAME, C.CONSOLE_COMMAND_SHORT)
    local cmdLineCfg = ns.sformat("/%s config", C.CONSOLE_COMMAND_SHORT)
    tooltip:AddDoubleLine(ns.ch:S(cmdLine), ns.ch:T(L['View available commands']))
    tooltip:AddDoubleLine(ns.ch:S(cmdLineCfg), ns.ch:T(L['Open settings dialog']))

    if inSync then return end

    tooltip:AddLine('\n\n')
    tooltip:AddLine(ns.locale.lineSeparator1)
    checkedState:tooltipSummary(tooltip)
end

--- @param self MinimapIconController
--- @param buttonFrame Button
--- @param button ButtonName i.e. 'LeftButton'
local function OnClick(self, buttonFrame, button)
    if button == "LeftButton" then
        if not self:IsInSync() and IsAltKeyDown() then
            return self:SendMessage(MSG.OnAddOnStateChanged, libName)
        end
        if self.tooltip then self.tooltip:Hide() end
        local menu = self:BuildProfilesMenu()
        --- @class AddonSuiteDropdownMenu : Frame
        local ddm = ns.AddonSuiteDropdownMenu
        if not ddm then
            --- @type Frame
            ns.AddonSuiteDropdownMenu = CreateFrame("Frame", nil, ns:pf(), "UIDropDownMenuTemplate")
            ns.AddonSuiteDropdownMenu:SetParentKey('DropdownMenu')
            ddm = ns.AddonSuiteDropdownMenu
        end
        EasyMenu(menu, ddm, 'cursor', 0 , 0, 'MENU')
    else
        if IsShiftKeyDown() then return ns:a():OpenConfigMinimapProfileMenu() end
        ns:a():OpenConfig()
    end
end

--- @param self MinimapIconController
local function Hook_TitanPanelButton_OnShow(self)
    ---@param frame Frame
    hooksecurefunc('TitanPanelButton_OnShow', function(frame)
        local name, buttonName = frame:GetName(), ns.sformat('TitanPanel%sButton', minimapName)
        if not ns:KO().String.EqualsIgnoreCase(name, buttonName) then return end

        p:f3(function() return 'OnShow(): %s type=%s', frame:GetName(), frame:GetObjectType() end)
        frame:SetScript('OnHide', function() OnTitanPanelHide(self) end)

        ns:db().char.shownInTitanPanel = true
        if not IsHideWhenInTP() then return end

        self:SetShowOnMinimap(false)
    end)

end

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
--- @param o MinimapIconController
local function PropsAndMethods(o)

    --- @private
    function o:Init()
        self.addon = ns:a()
        self:RegisterMessage(MSG.OnToggleMinimapIcon, function() OnToggleMinimapIcon(self) end)
        self:RegisterMessage(MSG.OnToggleMinimapIconTitanPanel, function() OnToggleMinimapIconTitanPanel(self) end)
    end

    --- @public
    --- @return MinimapIconController
    function o:New() return ns:K():CreateAndInitFromMixin(o) end

    --- @public
    function o:InitMinimapIcon() self:CreateAndRegisterMinimapDataObject() end

    --- @public
    function o:CreateAndRegisterMinimapDataObject()
        --- @type LibDataBroker_DataObject
        local dataObject = LibDataBroker:GetDataObjectByName(minimapName)
        if dataObject then
            p:d(function() return 'LibDataBroker-DataObject already registered: %s',
                    tostring(type(dataObject) ~= nil) end)
            return
        end

        dataObject = LibDataBroker:NewDataObject(minimapName, {
            type = "data source",
            text = ns.GC.C.FRIENDLY_NAME,
            icon = icon,
            OnClick = function(...) OnClick(self, ...)  end,
            OnTooltipShow = function(...) OnTooltipShow(self, ...)  end,
        })

        LibDBIcon:Register(minimapName, dataObject, ns:global().minimap)
        self:RegisterMessage(MSG.OnUpdateMinimapIconState, function() OnOutOfSyncIndicator(self) end)
        self.dataObject = dataObject

        if not API:IsTitanPanelAvailable() then return end

        Hook_TitanPanelButton_OnShow(self)
    end

    --- @return table<number, MinimapIconProfilesMenuItem>
    function o:BuildProfilesMenu()

        local sepColor     = ns.locale.lineSeparator1
        local selectProfileText = L['Select profile to activate']
        local noConfirmation = L['No Confirmation']
        local confirm, line2 = '', ''

        if not IsConfirmReload() then
            confirm = ns.sformat(' (%s)', noConfirmation)
            line2 = L['Reloads UI without confirmation']
        end
        line2 = selectProfileText .. confirm .. '.'
        local sep = { text = sepColor, notClickable = true, notCheckable = true }

        local menu = {
            { text = ns.ch:T(L['Switch Profile']), isTitle = true, notCheckable = true },
            { text = ns.ch:FormatColor('fbeb2d', line2), isTitle = true, notCheckable = true },
            sep,
        }
        --- @type table<number, MinimapIconProfilesMenuItem>
        local menuItems = { }

        --- @param profileName Name
        local function FnHandler(profileName) return function() OnSwitchProfile(self, profileName) end end

        local current = ns:db():GetCurrentProfile()
        local char = ns:db().char

        self:ForEachProfile(function(name, profile)
            if (name == current) then return true end
            local data = char.showInQuickProfileMenu
            local show = data[name] == true
            if show == true then
                p:d(function() return "profile[%s]: show-in-menu: %s", name, tostring(show) end)
            end
            return show
        end, function(name, profile)
            --- @type MinimapIconProfilesMenuItem
            local menuItem = { _sortKey=name, text = name, func = FnHandler(name), notCheckable = true }
            if name == current then
                menuItem.text = FC(profileInSyncColor, ns.sformat("%s %s", menuItem.text, currentSymbol))
                menuItem.checked = true
                menuItem.func = nil
            end
            table.insert(menuItems, menuItem)
        end)
        if #menuItems > 0 then
            table.sort(menuItems, function(a, b)
                return a._sortKey < b._sortKey
            end)
            for i=1, #menuItems do table.insert(menu, menuItems[i]) end
        end
        local img = ns.locale.xSymbol
        table.insert(menu, sep)
        table.insert(menu, { text = L['Hide'] .. ' ' .. img, notCheckable = true })

        return menu
    end

    function o:ChangeIconColor(r, g, b)
        local button = self:GetMinimapButton()
        if button and button.icon then
            button.icon:SetVertexColor(r, g, b)
        end
        -- Fire events for each change
        LibDataBroker.callbacks:Fire("LibDataBroker_AttributeChanged_", minimapName, "iconR", r)
        LibDataBroker.callbacks:Fire("LibDataBroker_AttributeChanged_", minimapName, "iconG", g)
        LibDataBroker.callbacks:Fire("LibDataBroker_AttributeChanged_", minimapName, "iconB", b)

    end

    function o:ChangeIcon(newIconPath)
        self.dataObject.icon = newIconPath
        local button = self:GetMinimapButton()
        if button and button.icon then button.icon:SetTexture(newIconPath) end
        LibDataBroker.callbacks:Fire("LibDataBroker_AttributeChanged_", minimapName,
                "icon", newIconPath)
    end

    --- @param inSync boolean
    --- @param details CheckedState|nil
    function o:UpdateOutOfSyncIndicator(inSync, details)
        local d = self.dataObject
        --- @type LayeredRegion
        local iconT = d.icon; if not iconT then return end
        p:d(function()
            if inSync then return 'inSync=%s', inSync end
            return 'inSync=%s details=%s', inSync, details:summary()
        end)
        if inSync then
            d.text = ' '
            return self:ChangeIcon(icon)
        end
        self:ChangeIcon(iconRed)
        d.text = self:GetOutOfSyncCount()
    end

    function o:GetOutOfSyncCount()
        local _, state = self:IsInSync()
        return iconOutOfSyncColor:WrapTextInColorCode(tostring(state:GetCount()))
    end

    --- @param acceptFn ProfilePredicateFn | "function(profile) return true end"
    --- @param callbackFn ProfileCallbackFn | "function(profile) print('profile') end"
    function o:ForEachProfile(acceptFn, callbackFn)
        for name, profile in pairs(ns:db().profiles) do
            if acceptFn(name, profile) == true then callbackFn(name, profile) end
        end
    end

    --- @return boolean, CheckedState
    function o:IsInSync() return ns.O.AddOnStateController:IsInSync() end
    --- @return MinimapButton
    function o:GetMinimapButton() return LibDBIcon:GetMinimapButton(minimapName) end

    function o:SetShowOnMinimap(state)
        if state == true then return LibDBIcon:Show(minimapName) end
        LibDBIcon:Hide(minimapName)
    end

end; PropsAndMethods(S)

