--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace
local ns = select(2, ...)
local O, GC, M = ns.O, ns.GC, ns.M
local libName = M.OptionsMinimapMixin
local sformat = ns.sformat
--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
--- @class OptionsMinimapMixin : BaseLibraryObject_WithAceEvent
local S = ns:NewLibWithEvent(libName)
local p = ns:CreateDefaultLogger(libName)
local pm = ns:LC().MESSAGE:NewLogger(libName)

--[[-----------------------------------------------------------------------------
Support Functions
-------------------------------------------------------------------------------]]
local function h1(header) return '     ' .. header .. '     ' end

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
---@param o OptionsMinimapMixin
local function PropsAndMethods(o)

    local sp = '                                                                   '

    --- @public
    --- @param optionsMixin OptionsMixin
    --- @param order Kapresoft_LibUtil_SequenceMixin
    --- @return OptionsMinimapMixin
    function o:New(optionsMixin, order) return ns:K():CreateAndInitFromMixin(o, optionsMixin, order) end

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

        --- @type AceConfigOption
        self.options = {
            h1 = {  type = 'header', name = h1(L['General Minimap Settings']), descStyle = 'inline', order = order:next(), },
            hide_minimap_icon = {
                name = L['Hide Minimap Icon'], desc = self:G('Hide Minimap Icon::Desc'),
                order = self.order:next(), type="toggle", width='normal',
                get = function() return ns:global().minimap.hide == true end,
                set = function(_, v)
                    ns:db().global.minimap.hide = (v == true)
                    self:SendMessage(GC.M.OnToggleMinimapIcon, libName)
                end
            },
            confirm_reloads = {
                name = L['Confirm Reloads When Switching Profiles'],
                desc = self:G('Confirm Reloads When Switching Profiles::Desc'),
                order = order:next(), type="toggle", width=2.0,
                get = function() return ns:global().minimap.confirm_reloads == true end,
                set = function(_, v)
                    ns:db().global.minimap.confirm_reloads = (v == true)
                end
            },
            spacer1 = { type="description", name = sp, width="full", order = order:next() },
            --- @type AceConfigOption
            h2 = {  type = 'header', name = h1(L['Favorite Profiles']), descStyle = 'inline',
                    order = order:next() },
            spacer2 = { type="description", name = sp, width="full", order = order:next() },
            desc1 = { type = 'description', name = L['Favorite Profiles::Desc'], fontSize = 'medium', order = order:next(), },
            spacer3 = { type="description", name = sp, width="full", order = order:next() },
        }
        self.startingOrder = order:get()
        self:CreateToggles(self.options)
        self:RegisterCallbacks()
        return self.options
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
        self:RegisterMessage(GC.M.OnProfileChanged, function(evt, source, newProfileKey)
            pm:f3(function()
                return 'MSG:R:%s received from[%s]. newProfileKey=%s', evt, source, newProfileKey end)
            self:OnProfileChanged(newProfileKey)
        end)

        --- Use "self" to register here so we have visibility to the instance
        --- @param evt string
        --- @param source string The source Event
        --- @param deletedProfileKey string
        self:RegisterMessage(GC.M.OnProfileDeleted, function(evt, source, deletedProfileKey)
            pm:f3(function()
                return 'MSG:R:%s received from[%s]. DeletedProfileKey=%s', evt, source, deletedProfileKey end)
            self:OnProfileDeleted(deletedProfileKey)
        end)
    end

end; PropsAndMethods(S)

