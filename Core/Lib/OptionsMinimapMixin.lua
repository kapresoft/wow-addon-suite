--[[-----------------------------------------------------------------------------
Type: OptionsMinimap
-------------------------------------------------------------------------------]]
--- @class OptionsMinimap

--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace
local ns = select(2, ...)
local M, MSG = ns.M, ns.GC.M
local libName = M.OptionsMinimapMixin()
local sformat = ns.sformat
--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
--- @class OptionsMinimapMixin
local S = ns:NewLibWithEvent(libName)
local p = ns:CreateDefaultLogger(libName)
local pm = ns:LC().MESSAGE:NewLogger(libName)

--[[-----------------------------------------------------------------------------
Support Functions
-------------------------------------------------------------------------------]]
local function h1(header) return '     ' .. header .. '     ' end
local sp = '                                                                   '

--[[-----------------------------------------------------------------------------
Library Methods
-------------------------------------------------------------------------------]]
--- @type OptionsMinimapMixin | AceEventInterface
local LIB = S

--- @public
--- @param optionsMixin OptionsMixin
--- @param order Kapresoft_LibUtil_SequenceMixin
--- @return OptionsMinimap
function LIB:New(optionsMixin, order) return ns:K():CreateAndInitFromMixin(S, optionsMixin, order) end

--[[-----------------------------------------------------------------------------
Instance Methods
-------------------------------------------------------------------------------]]
--- @type OptionsMinimap | AceEventInterface
local o = S

--- Called Automatically by CreateAndInitFromMixin
--- @private
--- @param optionsMixin OptionsMixin
--- @param order Kapresoft_LibUtil_SequenceMixin
function o:Init(optionsMixin, order)
    self.optionsMixin = optionsMixin
    self.util = self.optionsMixin.util
    self.order = order
    self.startingOrder = order:get()
end

--- @return AceConfigOption
function o:CreateOptions()
    local L = self.optionsMixin.locale

    --- @type AceConfigOption
    local group = {
        type = 'group',
        name = L['Minimap'],
        desc = L['Minimap::Desc'],
        order = self.order:next(),
        args = self:CreateSubGroup(self.order)
    }
    return group
end

function o:G(localeText)
    return self.locale[localeText] .. '\n' .. self.locale['Global Setting']
end
function o:C(localeText)
    return self.locale[localeText] .. '\n' .. self.locale['Character Setting']
end

--- @param order Kapresoft_LibUtil_SequenceMixin
--- @return AceConfigOption
function o:CreateSubGroup(order)
    local L = self.optionsMixin.locale; self.locale = L;
    local minimap = ns:minimap()

    --- @type AceConfigOption
    local options = {
        h1 = {  type = 'header', name = h1(L['General Minimap Settings']), descStyle = 'inline', order = order:next(), },
        hideMinimapIcon = {
            name = L['Hide Minimap Icon'], desc = self:G('Hide Minimap Icon::Desc'),
            order = self.order:next(), type="toggle", width=2.0,
            get = function() return minimap.hide == true end,
            set = function(_, v)
                ns:db().global.minimap.hide = (v == true)
                self:SendMessage(MSG.OnToggleMinimapIcon, libName)
            end
        },
        syncStatusIndicator = {
            name = L['Profile Sync Status Indicator'], desc=L['Profile Sync Status Indicator::Desc'],
            order = order:next(), type="toggle", width=1.3,
            get = function() return minimap.sync_status_indicator == true end,
            set = function(_, v)
                ns:db().global.minimap.sync_status_indicator = (v == true)
            end
        },
        confirmReloads = {
            name = L['Confirm Reloads When Switching Profiles'],
            desc = self:G('Confirm Reloads When Switching Profiles::Desc'),
            order = order:next(), type="toggle", width=2.0,
            get = function() return minimap.confirm_reloads == true end,
            set = function(_, v)
                ns:db().global.minimap.confirm_reloads = (v == true)
            end
        },
    }; self.options = options

    self:CreateTitanPanelOptions(options, order, L)

    options.spacer1 = { type="description", name = sp, width="full", order = order:next() }
    --- @type AceConfigOption
    options.h3 = {  type = 'header', name = h1(L['Favorite Profiles']), descStyle = 'inline', order = order:next() }
    options.spacer2 = { type="description", name = sp, width="full", order = order:next() }
    options.desc1 = { type = 'description', name = L['Favorite Profiles::Desc'], fontSize = 'medium', order = order:next(), }
    options.spacer3 = { type="description", name = sp, width="full", order = order:next() }

    self.startingOrder = order:get()
    self:CreateToggles(options)
    self:RegisterCallbacks()

    return options
end

--- @param options AceConfigOption
--- @param order Kapresoft_LibUtil_SequenceMixin
--- @param L AceLocale
function o:CreateTitanPanelOptions(options, order, L)
    local minimap = ns:minimap()

    options.h2 = {  type = 'header', name = h1(L['Titan Panel Settings']), descStyle = 'inline', order = order:next(), }
    options.TP_hideMinimapIconWhenInTitanPanel = {
        name = L['Hide Minimap Icon TitanPanel'], desc = self:G('Hide Minimap Icon TitanPanel::Desc'),
        order = self.order:next(), type="toggle", width=2.0,
        get = function() return minimap.hide_when_titan_panel_added == true end,
        set = function(_, v)
            minimap.hide_when_titan_panel_added = (v == true)
            self:SendMessage(MSG.OnToggleMinimapIconTitanPanel, libName)
        end
    }
    options.TP_showOutOfSyncCount = {
        name = L['Show Out of Sync Count'], desc = self:G('Show Out of Sync Count::Desc'),
        order = self.order:next(), type="toggle", width=2.0,
        get = function() return minimap.titan_panel.show_out_of_sync_count == true end,
        set = function(_, v)
            minimap.titan_panel.show_out_of_sync_count = (v == true)
            self:SendMessage(MSG.OnUpdateMinimapState, libName)
        end
    }
    options.TP_showProfileName = {
        name = 'Show Profile Name',
        desc = self:G('Show Profile Name::Desc'),
        order = self.order:next(), type="toggle", width=2.0,
        get = function() return minimap.titan_panel.show_profile_name == true end,
        set = function(_, v)
            local val = v == true
            options.TP_maxProfileName.disabled = val ~= true
            minimap.titan_panel.show_profile_name = val
            self:SendMessage(MSG.OnUpdateMinimapState, libName)
        end
    }
    options.TP_maxProfileName = {
        disabled = options.TP_showProfileName.get() ~= true,
        type = 'range',
        order = self.order:next(),
        step = 1,
        min = 1, max = 50,
        softMin = 5,
        softMax = 20,
        width = 1.3,
        name = L['Limit Profile Name Characters'],
        desc = self:G('Limit Profile Name Characters::Desc'),
        get = function() return minimap.titan_panel.profile_name_max_chars end,
        set = function(_, v)
            minimap.titan_panel.profile_name_max_chars = v
            self:SendMessage(MSG.OnUpdateMinimapState, libName)
        end,
    }

end

function o:GetProfileKeys()
    local keys = {}
    for name in pairs(ns:db().profiles) do table.insert(keys, name) end
    local currentProfile = ns:db():GetCurrentProfile()
    if not self.options[currentProfile] then table.insert(keys, currentProfile) end
    table.sort(keys, function(a, b)
        return a < b
    end)
    return keys
end

--- @param options AceConfigOption
function o:CreateToggles(options)
    local L = self.optionsMixin.locale
    local currentColor = L['Current Profile Color']
    local currentSymbol = L['Current::Symbol::Options']

    -- reset each time we re-create
    self.order:Init(self.startingOrder)

    local profileKeys = self:GetProfileKeys()
    for _, pkey in ipairs(profileKeys) do
        --- @type AceConfigOption
        local toggle = {
            name = pkey, type = "toggle", width = 1.3, order = self.order:next(),
            get = self.util:ProfileMenuCheckboxGetFn(pkey), set=self.util:ProfileMenuCheckboxSetFn(pkey)
        }
        local current = ns:db():GetCurrentProfile()
        if pkey == current then
            toggle.name = ns.ch:FormatColor(currentColor, sformat('%s %s', toggle.name, currentSymbol))
            toggle.desc = 'This is the current profile.'
        end
        options[pkey] = toggle
    end

end

--- @param deletedProfileKey string
function o:OnProfileDeleted(deletedProfileKey)
    self.options[deletedProfileKey] = nil
    ns:db().char.showInQuickProfileMenu[deletedProfileKey] = nil
    self:CreateToggles(self.options)
end
--- Handles profile change and profile creation events. The OnNewProfile doesn't fire
--- Note: AceDb OnProfileChanged also gets fired during a delete (for reason I do not know yet)
---@param newProfile string
function o:OnProfileChanged(newProfile)
    pm:f3(function() return "OnProfileChanged received... newProfile=%s", newProfile end)
    self:CreateToggles(self.options)
end

function o:RegisterCallbacks()
    --- Use "self" to register here so we have visibility to the instance
    --- @param evt string
    --- @param source string The source Event
    --- @param newProfileKey string
    self:RegisterMessage(MSG.OnProfileChanged, function(evt, source, newProfileKey)
        pm:f3(function()
            return 'MSG:R:%s received from[%s]. newProfileKey=%s', evt, source, newProfileKey end)
        self:OnProfileChanged(newProfileKey)
    end)

    --- Use "self" to register here so we have visibility to the instance
    --- @param evt string
    --- @param source string The source Event
    --- @param deletedProfileKey string
    self:RegisterMessage(MSG.OnProfileDeleted, function(evt, source, deletedProfileKey)
        pm:f3(function()
            return 'MSG:R:%s received from[%s]. DeletedProfileKey=%s', evt, source, deletedProfileKey end)
        self:OnProfileDeleted(deletedProfileKey)
    end)
end
