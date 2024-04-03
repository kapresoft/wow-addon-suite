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

-- todo: sync "current" in menu by check which addons are enabled
-- todo: prompt user to reload if addons need to be enabled/disabled in general settings

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
--- @param o MinimapIconController
local function PropsAndMethods(o)

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
        local currentColor = L['Current Profile Color']

        --- This local function is dynamic and needs to be here
        local function GetConfirmReloadText()
            local confirmationText = ns.ch:T('Currently configured to load %s confirmation')
            local without      = L['without']
            local with         = L['with']

            local text = ns.sformat(confirmationText, ns.ch:S(with))
            if ns:db().global.confirm_reloads ~= true then
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

        --- The global UIDROPDOWNMENU_OPEN_MENU is non-nil whenever a drop-down is showing
        --- @return boolean
        local function IsDropDownShowing() return UIDROPDOWNMENU_OPEN_MENU ~= nil end

        dataObject = LibDataBroker:NewDataObject(minimapObjectName, {
            type = "data source",
            text = ns.GC.C.FRIENDLY_NAME,
            icon = icon,
            OnClick = function(self, button)
                if button == "LeftButton" then
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

                local currentProfileText = ns.ch:T(L['Current Profile'])
                local header1 = ns.sformat('%s %s', iconText, ns.ch:P(ns.GC.C.FRIENDLY_NAME))
                local header3 = ns.sformat('%s: %s', currentProfileText, ns.ch:FormatColor(currentColor, ns:db():GetCurrentProfile()))
                local confirmationLine = GetConfirmReloadText()
                tooltip:AddDoubleLine(header1, header3)
                tooltip:AddLine(ns.locale.lineSeparator1)
                tooltip:AddLine(confirmationLine)
                tooltip:AddLine(' ')

                local commandLines = ns.ch:P(L['Command Lines'] .. ":")
                tooltip:AddDoubleLine(ns.ch:S("Left-Click"), ns.ch:T(L['View or switch profiles']))
                tooltip:AddDoubleLine(ns.ch:S("Right-Click"), ns.ch:T(L['Open settings dialog']))
                tooltip:AddDoubleLine(ns.ch:S("Shift-Right-Click"), ns.ch:T(L['Open minimap settings dialog']))
                tooltip:AddLine(' ')
                tooltip:AddLine(commandLines)
                tooltip:AddDoubleLine(ns.ch:S("/ads or /addon-suite"), ns.ch:T(L['View available commands']))
                tooltip:AddDoubleLine(ns.ch:S("/ads config"), ns.ch:T(L['Open settings dialog']))
            end,
        })

        LibDBIcon:Register(minimapName, dataObject, ns:global().minimap)
    end

    --- TODO: On profile change listener
    --- @return table<number, MinimapIconProfilesMenuItem>
    function o:BuildProfilesMenu()

        local currentColor = L['Current Profile Color']
        local currentSymbol = L['Current::Symbol::Minimap']

        --- @class MinimapIconProfilesMenuItem
        --- @field text Name
        --- @field isTitle boolean
        --- @field notCheckable boolean
        --- @field checked boolean
        --- @field func fun() | "function() end" | "A function action handler"
        --- @field _sortKey string The sort key (Custom Field)
        --- @type table<number, MinimapIconProfilesMenuItem>

        local sepColor     = ns.locale.lineSeparator1
        local selectProfileText = L['Select a profile below to activate']
        local noConfirmation = L['No Confirmation']
        local confirm, line2 = '', ''
        if ns:db().global.confirm_reloads ~= true then
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
                -- todo: sync with enabled addons
                -- if out-of-sync, then red color and add " click to Apply Settings and Reload UI"
                menuItem.text = ns.ch:FormatColor(currentColor, ns.sformat("%s %s", menuItem.text, currentSymbol))
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

