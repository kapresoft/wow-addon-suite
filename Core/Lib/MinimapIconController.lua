--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace
local ns = select(2, ...)
local O, GC, MSG = ns.O, ns.GC, ns.GC.M

local LibDBIcon = ns.LibStubAce("LibDBIcon-1.0")
local LibDataBroker = ns.LibStubAce("LibDataBroker-1.1")
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
p:v(function() return "Loaded: %s", libName end)

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
---@param o MinimapIconController
local function PropsAndMethods(o)

    --- @private
    --- @param addon AddonSuite | MainController
    function o:Init(addon)
        local _addon = (addon and addon.OpenConfig and addon) or addon.addon
        assert(_addon, "AddonSuite is required")
        assert(_addon.OpenConfig, "AddonSuite is required in " .. libName .. ':Init(..)')
        self.addon = _addon
        self:RegisterMessage(MSG.OnToggleMinimapIcon, function(...) self:OnToggleMinimapIcon(...)  end)
    end

    --- @public
    --- @param addon AddonSuite | MainController
    --- @return MinimapIconController
    function o:New(addon) return ns:K():CreateAndInitFromMixin(o, addon) end

    ---@param msg string The message name
    ---@param source string The source library name
    function o:OnToggleMinimapIcon(msg, source)
        pm:vv(function() return "Received[%s] from %s", tostring(msg), tostring(source) end)
        local hide = ns:global().minimap.hide == true
        if hide then
            LibDBIcon:Hide(minimapName); return
        end
        LibDBIcon:Show(minimapName); return
    end

    --- @public
    function o:InitMinimapIcon()
        local mainSelf = self
        local A = self.addon
        local icon = "inv_cask_01"
        local dataObject = LibDataBroker:NewDataObject(ns.name .. "Minimap", {
            type = "data source",
            text = ns.GC.C.FRIENDLY_NAME,
            icon = "Interface\\Icons\\" .. icon,
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
                    if IsShiftKeyDown() then
                        A:OpenConfigProfiles()
                        return
                    end
                    A:OpenConfig()
                end
            end,
            ---@param tooltip _GameTooltip
            OnTooltipShow = function(tooltip)
                if not tooltip or not tooltip.AddLine then return end
                mainSelf.tooltip = tooltip
                local line1 = ns.ch:S("Left-Click") .. ' ' .. ns.ch:T(L['to view or switch profiles'])
                local line2 = ns.ch:S("Right-Click") .. ' ' .. ns.ch:T(L['to open settings dialog'])
                local line3 = ns.ch:S("Shift-Right-Click") .. ' ' .. ns.ch:T(L['to open profiles dialog'])
                local commandLines = ns.ch:P(L['Command Lines'] .. ":")
                local line4 = ns.ch:S("/ads or /addon-suite") .. ' ' .. ns.ch:T(L['to view available commands'])
                local line5 = ns.ch:S("/ads config") .. ' ' .. ns.ch:T(L['to open settings dialog'])

                local header1 = ns.sformat('%s\n\n%s: %s\n\n', ns.ch:P(ns.GC.C.FRIENDLY_NAME),
                        ns.ch:T(L['Current Profile']), ns.ch:S(ns:db():GetCurrentProfile()))
                tooltip:AddLine(header1)
                tooltip:AddLine(line1, 0.8, 0.8, 0.8)
                tooltip:AddLine(line2, 0.8, 0.8, 0.8)
                tooltip:AddLine(line3, 0.8, 0.8, 0.8)
                tooltip:AddLine(' ')
                tooltip:AddLine(commandLines, 1, 1, 1)
                tooltip:AddLine(line4, 0.8, 0.8, 0.8)
                tooltip:AddLine(line5, 0.8, 0.8, 0.8)
                -- Add more lines as needed
            end,
        })

        LibDBIcon:Register(minimapName, dataObject, ns:global().minimap)
    end

    --- TODO: On profile change listener
    --- @return table<number, MinimapIconProfilesMenuItem>
    function o:BuildProfilesMenu()
        --- @class MinimapIconProfilesMenuItem
        --- @field text Name
        --- @field isTitle boolean
        --- @field notCheckable boolean
        --- @field checked boolean
        --- @field func fun() | "function() end" | "A function action handler"

        --- @class table<number, MinimapIconProfilesMenuItem>
        local menu = {
            { text = ns.ch:T('Select Profile:'), isTitle = true, notCheckable = true }
        }

        local function FnHandler(profile)
            return function() self:SendMessage(ns.GC.M.OnSwitchProfile, libName, profile) end
        end

        local db = ns:db()
        local current = db:GetCurrentProfile()

        for name, p in pairs(db.profiles) do
            --- @type MinimapIconProfilesMenuItem
            local menuItem = { text = name, func = FnHandler(name) }
            if name == current then
                menuItem.text = ns.ch:S(menuItem.text .. ns.sformat(" (%s)", L['current']))
                menuItem.checked = true
                menuItem.func = nil
            end
            table.insert(menu, menuItem)
        end

        return menu
    end

end; PropsAndMethods(S)

