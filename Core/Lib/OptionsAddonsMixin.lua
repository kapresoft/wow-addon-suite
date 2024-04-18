--[[-----------------------------------------------------------------------------
Lua Vars
-------------------------------------------------------------------------------]]
local sformat = string.format

--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace
local ns = select(2, ...)
local O, GC, M, MSG, KO, LibStub = ns.O, ns.GC, ns.M, ns.GC.M, ns:KO(), ns.LibStub
local Table, String =  KO.Table, KO.String
--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
local libName = M.OptionsAddonsMixin
--- @return OptionsAddonsMixin, Kapresoft_CategoryLogger
local function CreateLib()
    --- @class OptionsAddonsMixin : BaseLibraryObject_WithAceEvent
    --- @field optionsMixin OptionsMixin
    --- @field locale AceLocale
    local newLib = LibStub:NewLibrary(libName); if not newLib then return nil end
    ns:AceEvent(newLib)
    local logger = ns:LC().OPTIONS:NewLogger(libName)
    return newLib, logger
end; local S, p = CreateLib(); if not S then return end
--[[-----------------------------------------------------------------------------
Support Functions
-------------------------------------------------------------------------------]]
local function m() return O.AddOnManager  end
local sp = '                                                                   '

--- @param fallback boolean The fallback value
--- @param addonName string The key value
local function AutoLoadAddOnsGet(addonName, fallback)
    return function(_) return ns:profile().enabledAddons[addonName] or fallback end
end
--- @param addonName string The key value
local function AutoLoadAddOnsSet(addonName)
    --- @param v boolean
    return function(_, v) ns.requiresReload = true; ns:profile().enabledAddons[addonName] = v; end
end

--- @return ProfileSelect
local function CreateProfileSelect()
    local function GetProfiles() return ns:db():GetProfiles() end
    local function GetCurrentProfile() return ns:db():GetCurrentProfile()  end
    --- @param info table Ignored
    --- @param val string The profile name selected
    local function SetCurrentProfile(info, val) ns:db():SetProfile(val) end
    --- Get the Profile names to be used for the select values
    --- @return table<string, string> key is the same as value
    local function GetSortedProfiles()
        local profiles = {}
        for _, profileName in ipairs(GetProfiles()) do
            profiles[profileName] = profileName
        end
        return Table.getSortedKeys(profiles)
    end
    --- Get the Profile names to be used for the select values
    --- This table has to match the order of the original profile
    --- @return table<string, string> key is the same as value
    local function GetProfilesKV()
        local profiles = {}
        for _, pr in ipairs(GetProfiles()) do
            profiles[pr] = pr
        end
        return profiles
    end

    --- @class ProfileSelect
    local ret = {
        kvPairs = GetProfilesKV,
        sorting = GetSortedProfiles,
        get = GetCurrentProfile,
        set = SetCurrentProfile,
    }
    return ret
end

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
---@param o OptionsAddonsMixin
local function PropsAndMethods(o)

    --- @public
    --- @param optionsMixin OptionsMixin
    --- @return OptionsAddonsMixin
    function o:New(optionsMixin) return ns:K():CreateAndInitFromMixin(o, optionsMixin) end

    --- Called Automatically by CreateAndInitFromMixin
    --- @private
    --- @param optionsMixin OptionsMixin
    function o:Init(optionsMixin)
        self.optionsMixin = optionsMixin
    end

    --- @param order Kapresoft_LibUtil_SequenceMixin
    --- @return AceConfigOption
    function o:CreateAddOnsGroup(order)
        local L = self.optionsMixin.locale
        --- @type AceConfigOption
        local group = {
            type = 'group',
            name = L['General'],
            desc = L['General::Desc'],
            order = order:next(),
            args = self:CreateAddOnsOptions(order)
        }
        return group
    end

    ---@param name string
    local function h(name)
        return sformat('      %s      ', name)
    end

    function o:G(localeText)
        return self.locale[localeText] .. '\n' .. self.locale['Global Setting']
    end
    function o:C(localeText)
        return self.locale[localeText] .. '\n' .. self.locale['Character Setting']
    end

    --- @return AceConfigOption
    --- @param order Kapresoft_LibUtil_SequenceMixin
    function o:CreateAddOnsOptions(order)
        local L = self.optionsMixin.locale; self.locale = L;
        local util = self.optionsMixin.util
        local ps = CreateProfileSelect()

        local versionText = GC:GetAddonInfo()
        local versionLabel = GC.C.FRIENDLY_NAME .. BLUE_FONT_COLOR:WrapTextInColorCode(' v' .. versionText)

        --- @type table<string, AceConfigOption>
        local options = {
            labelVersion = { order = order:next(), type = "description", width='full',
                             fontSize='medium', name = versionLabel,  },
            spacer1aa = { order = order:next(), type = "description", name = " ", width='full', fontSize='small' },
            showInQuickProfileSwitchMenu = {
                name = L['Add to Favorite'], desc = self:C('Add to Favorite::Desc'),
                order = order:next(), type="toggle", width='normal',
                get = util:QuickProfileMenuGet(),
                set = util:QuickProfileMenuSet()
            },
            syncAddOnStates = {
                name = L['Prompt me to Reload UI'], desc = self:G('Prompt me to Reload UI::Desc'),
                order = order:next(), type="toggle", width=2.0,
                get = util:GlobalGet('sync_addon_states'),
                set = util:GlobalSet('sync_addon_states'),
            },
            spacer1a = { order = order:next(), type = "description", name = "", width='full' },
        }
        options.reloadUI = {
            name = L['Reload UI'], desc = L['Reload UI::Desc'],
            type = "execute", order = order:next(), width = 0.7,
            func = function() util:SendEventMessage(GC.M.OnApplyAndRestart, libName) end
        }
        options.profileSelection = {
            name = L['Select Profile'] .. ':', desc = L['Select Profile::Desc'], order = order:next(),
            type = "select", width="normal",
            values = ps.kvPairs, sorting = ps.sorting,
            get = ps.get,
            set = ps.set
        }
        options.spacer1 = { order = order:next(), type = "description", name = "", width=0.3 }
        options.enable_all = self:CreateEnableAll(options, order, L)
        options.disable_all = self:CreateDisableAll(options, order, L)
        options.spacer3 = { order = order:next(), type = "description", name = L['Add-Ons::Desc'] .. '\n\n', fontSize='medium' }

        local addOnCount = GetNumAddOns()
        if addOnCount <= 0 then
            options['no_addon_found'] = {
                name = "\n\nNo Add-Ons were detected", type = "description", order=order:next(),
            }
            return options
        end
        self.addonsOptions = options

        self:CreateAddOnCheckList(order)

        return options
    end

    --- @param addOnName Name
    --- @param state boolean
    local function UpdateEnabledState(addOnName, state)
        local currentlyEnabled = O.API:IsAddOnEnabled(addOnName)
        p:f1(function() return 'AddOn[%s] is enabled: %s', addOnName, currentlyEnabled end)
        if state == true and not currentlyEnabled then
            return O.API:EnableAddOnForCharacter(addOnName)
        end
        if state == false and currentlyEnabled then
            O.API:DisableAddOnForCharacter(addOnName)
        end
    end

    function o.CreateGetFn(addOnName)
        --- @return boolean
        return function()
            local v = ns:profile().enabledAddons[addOnName] == true
            p:f3(function() return 'Handle Get[%s]: val=%s', addOnName, v end)
            UpdateEnabledState(addOnName, v)
            return v
        end
    end

    --- @param addOnName Name
    function o.CreateSetFn(addOnName)
        return function(_, v)
            ns:profile().enabledAddons[addOnName] = v
            --@do-not-package@
            if ns.debug:IsDeveloper() then
                if String.IsAnyOf(addOnName, 'Ace3', 'BugSack', '!BugGrabber') then
                    ns:profile().enabledAddons[addOnName] = true
                end
            end
            --@end-do-not-package@
            UpdateEnabledState(addOnName, v)
            p:f3(function() return 'Handle Set[%s]: val=%s', addOnName, v end)
        end
    end

    ---@param self AceConfigOption
    function o.GetAddOnName(self, name)
        return function()
            local ai = m():New(name)
            p:f1(function() return "[%s]: reason: %s enabled: %s", ai.name, ai.reason, ai.enabled end)
            return ai:GetNameAndDesc(self.get())
        end
    end
    ---@param self AceConfigOption
    function o.GetAddOnDesc(self, name)
        return function() return select(2, m():New(name):GetNameAndDesc()) end
    end

    function o:CreateAddOnCheckList(order)
        local options = self.addonsOptions
        local A = O.API

        A:ForEachAddOn(function(info)
            local name = info.name
            options[name] = {
                order = order:next(),
                type = 'toggle',
                width = 1.3,
                get = o.CreateGetFn(name),
                set = o.CreateSetFn(name),
            }
            local opt = options[name];
            opt.name = o.GetAddOnName(opt, name)
            opt.desc = o.GetAddOnDesc(opt, name)
        end)
    end

    --- @param options AceConfigOption
    --- @param order Kapresoft_LibUtil_SequenceMixin
    --- @param L AceLocale
    function o:CreateEnableAll(options, order, L)
        return {
            name = L['General::Enable All::Button'], desc = L['General::Enable All::Button::Desc'],
            type = "execute", order = order:next(), width = 'half',
            -- todo: update label color?
            func = function() self:ForEachToggle(function(opt) opt.set({}, true) end) end
        }
    end

    --- @param options AceConfigOption
    --- @param order Kapresoft_LibUtil_SequenceMixin
    --- @param L AceLocale
    function o:CreateDisableAll(options, order, L)
        return {
            name = L['General::Disable All::Button'], desc = L['General::Disable All::Button::Desc'],
            type="execute", order=order:next(), width = 'half',
            func = function() self:ForEachToggle(function(opt) opt.set({}, false) end) end
        }
    end

    --- @param applyFn fun(option:AceConfigOption) | "function(option) end"
    function o:ForEachToggle(applyFn)
        for _, option in pairs(self.addonsOptions) do
            if option.type == 'toggle' then applyFn(option) end
        end
    end

end; PropsAndMethods(S)

