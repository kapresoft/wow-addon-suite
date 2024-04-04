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
local Table =  KO.Table
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
        self.addonsOptions = group.args
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

        local includeVar = 'include_addon_changes_in_reload_confirmation'

        local options = {
            header1 = { order = order:next(), type = 'header', name = h(L['General']) },
            showInQuickProfileSwitchMenu = {
                name = L['Add to Favorite'], desc = self:C('Add to Favorite::Desc'),
                order = order:next(), type="toggle", width='normal',
                get = util:QuickProfileMenuGet(),
                set = util:QuickProfileMenuSet()
            },
            syncAddOnStates = {
                name = L['Sync addon states'], desc = self:G('Sync addon states::Desc'),
                order = order:next(), type="toggle", width='normal',
                get = util:GlobalGet('sync_addon_states'),
                set = util:GlobalSet('sync_addon_states'),
            },
            includeAddOnChanges = {
                name = L['Include Addon Changes in Reload Confirmation'],
                desc = self:G('Include Addon Changes in Reload Confirmation::Desc'),
                order = order:next(), type="toggle", width=2.0,
                get = util:GlobalGet(includeVar),
                set = util:GlobalSet(includeVar),
            },
            spacer1a = { order = order:next(), type = "description", name = "", width='full' },
        }
        options.applyAll = {
            name = L['Apply and Reload'], desc = L['Apply and Reload::Desc'],
            type = "execute", order = order:next(), width = 'normal',
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

        O.API:ForEachAddOn(function(addOn)
            local name = addOn.name
            local title = addOn.addOnInfo.title
            if name ~= ns.name then
                options[name] = {
                    order = order:next(),
                    name = title,
                    type = 'toggle',
                    width = 1.3,
                    get = AutoLoadAddOnsGet(name),
                    set = AutoLoadAddOnsSet(name)
                }
            end
        end)

        return options
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

