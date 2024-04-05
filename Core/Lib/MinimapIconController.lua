--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace
local ns = select(2, ...)
local MSG = ns.GC.M

local LibDBIcon = ns:LibDBIcon()
local LibDataBroker = ns:LibDataBroker()

local L = ns:AceLocale()
local minimapName = ns.name .. "MinimapIcon"
local libName = 'MinimapIconController'
--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
--- @class MinimapIconController : BaseLibraryObject_WithAceEvent
local S = ns:NewLibWithEvent(libName)
local p = ns:CreateDefaultLogger(libName)
local pm = ns:LC().MESSAGE:NewLogger(libName)
local icon     = "Interface\\Icons\\inv_cask_01"
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

--- The global UIDROPDOWNMENU_OPEN_MENU is non-nil whenever a drop-down is showing
--- @return boolean
local function IsDropDownShowing() return UIDROPDOWNMENU_OPEN_MENU ~= nil end

local function FC(hexColor, text) return ns.ch:FormatColor(hexColor, text) end
local function FCOS(text) return ns.ch:FormatColor(textOutOfSyncColor, text) end

---@param tooltip _GameTooltip
---@param inSync boolean
local function OutOfSyncMessage(tooltip, inSync)
    if inSync == true then return end
    local msg = FCOS(L['Profile is out of sync']) .. '. '
    tooltip:AddLine(msg)
    tooltip:AddLine(L['Click Key To Sync'] .. '.\n\n')
end

---@param inSync boolean
local function CurrentProfileText(inSync)
    local currentProfile = ns:db():GetCurrentProfile()
    local profText = ns.ch:T(L['Current Profile'])
    local prof = FC(profileInSyncColor, currentProfile)
    if not inSync then prof = FCOS(currentProfile) end
    return profText, prof
end

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
--- @param o MinimapIconController | AceEvent
local function PropsAndMethods(o)

    function o:GetAddOnState() return ns.O.AddOnStateController:GetAddOnState() end

    --- @private
    function o:Init()
        self.addon = ns:a()
        self:RegisterMessage(MSG.OnToggleMinimapIcon, function(...) self:OnToggleMinimapIcon(...)  end)
    end

    --- @public
    --- @return MinimapIconController
    function o:New() return ns:K():CreateAndInitFromMixin(o) end

    --- Toggles (Show/Hide state)
    --- @param msg string The message name
    --- @param source string The source library name
    function o:OnToggleMinimapIcon(msg, source)
        pm:f1(function() return "Received[%s] from %s", tostring(msg), tostring(source) end)
        local hide = ns:global().minimap.hide == true
        if hide then
            LibDBIcon:Hide(minimapName); return
        end
        LibDBIcon:Show(minimapName); return
    end

    --- @public
    function o:InitMinimapIcon()
        self:CreateAndRegisterMinimapDataObject()
    end

    --- @public
    function o:CreateAndRegisterMinimapDataObject()
        local mainSelf = self
        local A = self.addon

        local minimapObjectName = ns.name .. "Minimap"

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

        --- @type LibDataBroker_DataObject
        local dataObject = LibDataBroker:GetDataObjectByName(minimapObjectName)
        if dataObject then
            p:d(function() return 'LibDataBroker-DataObject already registered: %s',
                    tostring(type(dataObject) ~= nil) end)
            return
        end

        local s = self; dataObject = LibDataBroker:NewDataObject(minimapObjectName, {
            type = "data source",
            text = ns.GC.C.FRIENDLY_NAME,
            icon = icon,
            OnClick = function(self, button)
                if button == "LeftButton" then
                    if IsAltKeyDown() then
                        local inSync = s:GetAddOnState():IsEmpty()
                        if inSync ~= true then return s:SendMessage(MSG.OnShowReloadConfirm, libName) end
                    end

                    if mainSelf.tooltip then mainSelf.tooltip:Hide() end
                    local menu = mainSelf:BuildProfilesMenu()
                    --- @class AddonSuiteDropdownMenu : _Frame
                    local ddm = ns.AddonSuiteDropdownMenu
                    if not ddm then
                        ns.AddonSuiteDropdownMenu = CreateFrame("Frame", ns.name .. "DropdownMenu", UIParent, "UIDropDownMenuTemplate")
                        ddm = ns.AddonSuiteDropdownMenu
                    end
                    EasyMenu(menu, ddm, 'cursor', 0 , 0, 'MENU')
                else
                    if IsShiftKeyDown() then return A:OpenConfigMinimapProfileMenu() end
                    A:OpenConfig()
                end
            end,
            --- @param tooltip _GameTooltip
            OnTooltipShow = function(tooltip)
                if IsDropDownShowing() then return end
                if not tooltip or not tooltip.AddLine then return end
                mainSelf.tooltip = tooltip

                local inSync = s:GetAddOnState():IsEmpty()
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
                tooltip:AddDoubleLine(ns.ch:S("/ads or /addon-suite"), ns.ch:T(L['View available commands']))
                tooltip:AddDoubleLine(ns.ch:S("/ads config"), ns.ch:T(L['Open settings dialog']))
            end,
        })

        LibDBIcon:Register(minimapName, dataObject, ns:global().minimap)
        self:RegisterMessage(MSG.OnAddOnStateChangedWithConfirmation, o.OnAddOnStateChangedWithConfirmation)

    end

    function o.OnAddOnStateChangedWithConfirmation()
        local dataObj = LibDBIcon.objects[minimapName]
        if not dataObj then return end
        --- @type LayeredRegion
        local iconT = dataObj.icon; if not iconT then return end
        local inSync = o:GetAddOnState():IsEmpty()
        p:d(function() return 'inSync: %s', inSync end)
        if inSync then return iconT:SetVertexColor(1, 1, 1, 1) end

        iconT:SetVertexColor(iconOutOfSyncColor:GetRGBA())
    end

    --- @return table<number, MinimapIconProfilesMenuItem>
    function o:BuildProfilesMenu()

        --- @class MinimapIconProfilesMenuItem
        --- @field text Name
        --- @field isTitle boolean
        --- @field notCheckable boolean
        --- @field checked boolean
        --- @field func fun() | "function() end" | "A function action handler"
        --- @field _sortKey string The sort key (Custom Field)
        --- @type table<number, MinimapIconProfilesMenuItem>

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
        local function FnHandler(profile)
            return function() self:SendMessage(ns.GC.M.OnSwitchProfile, libName, profile) end
        end

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
        table.insert(menu, { text = "Cancel " .. img, notCheckable = true })

        return menu
    end

    --- @param acceptFn ProfilePredicateFn | "function(profile) return true end"
    --- @param callbackFn ProfileCallbackFn | "function(profile) print('profile') end"
    function o:ForEachProfile(acceptFn, callbackFn)
        for name, profile in pairs(ns:db().profiles) do
            if acceptFn(name, profile) == true then callbackFn(name, profile) end
        end
    end

end; PropsAndMethods(S)

