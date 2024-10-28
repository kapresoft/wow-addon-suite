--[[-----------------------------------------------------------------------------
Type: OptionsAddons
-------------------------------------------------------------------------------]]
--- @class OptionsAddons

--[[-----------------------------------------------------------------------------
Lua Vars
-------------------------------------------------------------------------------]]
local C_Timer_NewTicker = C_Timer.NewTicker
local GetNumAddOns = GetNumAddOns or C_AddOns.GetNumAddOns
--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace
local ns = select(2, ...)
local O, GC, M, MSG, K, KO = ns.O, ns.GC, ns.M, ns.GC.M, ns:K(), ns:KO()
local Table, String     = KO.Table, KO.String
local AceEvent          = ns:AceEvent()
local ACU = KO.AceConfigUtil:New(ns.addon, not ns:IsDev())

--[[-----------------------------------------------------------------------------
OnLoad
-------------------------------------------------------------------------------]]
local fVersion = K:cf(BLUE_FONT_COLOR)
local fDisabled = K:cf(LIGHTGRAY_FONT_COLOR)
local fLib      = K:cf(LIGHTBLUE_FONT_COLOR)

--- @type string
local libPrefix
--- @type AceLocale
local L

local API, ADU = M.API, M.AddOnDependencyUtil
ns:OnAddOnStartLoad(function()
    API, ADU = O.API, O.AddOnDependencyUtil
    API:PrefetchAddOnInfo()
    L = ns:AceLocale()
    libPrefix = L['Lib:'] .. ' '
end)

--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
local libName = M.OptionsAddonsMixin()

--- @class OptionsAddonsMixin
--- @field optionsMixin OptionsMixin
local S = ns:NewLibWithEvent(libName)
local p = ns:LC().OPTIONS:NewLogger(libName)

--[[-----------------------------------------------------------------------------
Support Functions
-------------------------------------------------------------------------------]]
local sp = '                                                                   '

--- @return ProfileSelect
local function CreateProfileSelect()
    local function GetProfiles() return ns:db():GetProfiles() end
    local function GetCurrentProfile() return ns:db():GetCurrentProfile()  end
    --- @param info table Ignored
    --- @param val string The profile name selected
    local function SetCurrentProfile(info, val)
        ns:db():SetProfile(val)
        AceEvent:SendMessage(MSG.OnUpdateMinimapState, libName)
    end
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
CoroutineManager: This component warms up the cache in the background on login so that
the WoW UI can prioritize the threads.
-------------------------------------------------------------------------------]]
--- Coroutine manager for handling async tasks
--- @class OptionsCoroutineManager
local CoroutineManager = {
    coroutines = {},
    ticker = nil
}

--- @type OptionsCoroutineManager
local CM = CoroutineManager

--- Creates a coroutine and stores it in the manager
function CM:Create(fn)
    local co = coroutine.create(fn)
    table.insert(self.coroutines, co)
    if not self.ticker then self:StartTicker() end
    return co
end

--- Resumes all coroutines and processes their results
function CM:ResumeAll()
    for i = #self.coroutines, 1, -1 do
        local co = self.coroutines[i]
        if coroutine.status(co) == "suspended" then
            local success, result = coroutine.resume(co)
            if not success then
                p:e(function() return "Coroutine error: %s", result end)
                table.remove(self.coroutines, i)
            elseif coroutine.status(co) == "dead" then
                table.remove(self.coroutines, i)
            end
        end
    end
    if #self.coroutines == 0 then
        self:StopTicker()
        p:f1('CoroutineManager ticker stopped.')
    end
end

--- Starts the ticker to resume coroutines periodically
function CM:StartTicker()
    self.ticker = C_Timer_NewTicker(0.1, function() self:ResumeAll() end)
    p:f1('CoroutineManager ticker started.')
end

function CM:StopTicker()
    if self.ticker then
        self.ticker:Cancel()
        self.ticker = nil
    end
end

--[[-----------------------------------------------------------------------------
Methods: OptionsAddonsMixin
-------------------------------------------------------------------------------]]
--- @type OptionsAddonsMixin | AceEventInterface
local LIB = S

--- @public
--- @param options Options
--- @return OptionsAddons
function LIB:New(options) return ns:K():CreateAndInitFromMixin(S, options) end

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
--- @type OptionsAddons | AceEventInterface
local o = S

--- Called Automatically by CreateAndInitFromMixin
--- @private
--- @param options Options
function o:Init(options)
    self.mainOptions = options
    self.util        = options.util
    self.order       = options.order
end

--- @return AceConfigOption
function o:CreateAddOnsGroup()
    self.order = self.order

    --- @type AceConfigOption
    local group = {
        type  = 'group',
        name  = L['General'],
        desc  = L['General::Desc'],
        order = self.order:next(),
        args  = self:CreateAddOnsOptions()
    }
    return group
end

--- @return AceConfigOption
function o:CreateAddOnsOptions()
    local order = self.order
    local util  = self.util
    local ps    = CreateProfileSelect()

    local versionLabel = GC.C.FRIENDLY_NAME .. fVersion(' v' .. GC:GetAddonInfo())

    --- @type table<string, AceConfigOption>
    local options = {
        labelVersion = ACU:CreateLabelByName(versionLabel, {
            order = order:next(),
        }), spacer1a  = ACU:CreateSpacer(order:next()),
        showInQuickProfileSwitchMenu = ACU:CreateGlobalOption('Add to Favorite', {
            order = order:next(), type = "toggle", width = 'normal',
            get   = util:QuickProfileMenuGet(),
            set   = util:QuickProfileMenuSet()
        }),
        syncAddOnStates = ACU:CreateGlobalOption('Prompt me to Reload UI', {
            order = order:next(), type = "toggle", width = 3.0,
            get   = util:GlobalGet('sync_addon_states'),
            set   = util:GlobalSet('sync_addon_states'),
        }), spacer1b = ACU:CreateSpacer(order:next()),
        reloadUI = ACU:CreateOption('Reload UI', {
            name = L['Reload UI'], desc = L['Reload UI::Desc'],
            type = "execute", order = order:next(), width = 0.7,
            func = function() util:SendEventMessage(GC.M.OnApplyAndRestart, libName) end
        }),
        profileSelection = ACU:CreateCharOption('Select Profile', {
            type   = "select", width = "normal", order = order:next(),
            values = ps.kvPairs, sorting = ps.sorting,
            get    = ps.get,
            set    = ps.set
        }),
    }

    options.spacer1     = ACU:CreateSpacer({ order = order:next(), width = 0.5 })
    options.enable_all  = self:CreateEnableAll()
    options.disable_all = self:CreateDisableAll()
    options.spacer3     = ACU:CreateLabel('Add-Ons::Desc', {
        order = order:next(), width=3.5
    })
    options.spacer1c = ACU:CreateSpacer(order:next())

    local addOnCount = GetNumAddOns()
    if addOnCount <= 0 then
        options['no_addon_found'] = {
            name = "\n\nNo Add-Ons were detected", type = "description", order=order:next(),
        }
        return options
    end
    self.addonsOptions = options

    self:CreateAddOnCheckList()

    return options
end

--- Clicking a parent AddOn will enable the dependent addOns if configured
--- @see SynchronizedAddOns
--- @param options AceConfigOption
--- @param name AddOnName
--- @param v boolean The checked value
function o:OnSyncCheckedStateWithRelatedAddOns(options, name, v)
    local syncd = ns.SynchronizedAddOns
    syncd:ForEachSyncdAddOn(name, function(syncdAddOnName)
        if not options[syncdAddOnName] then
            p:w(function()
                return 'AddOnNotInstalled: %s. Fix SynchronizedAddOns configuration.', syncdAddOnName
            end)
            ns:profile().enabledAddons[syncdAddOnName] = nil
            return
        end
        ns:profile().enabledAddons[syncdAddOnName] = v
        o:UpdateEnabledState(syncdAddOnName, v)
    end)
end

--- This part depends on the addon dependency details cache being called
--- @see AddOnDependencyUtil#FlushAddOnDependencyDetailsCache
--- @param indexOrName IndexOrName The AddOn Index or Name
--- @return string
function o.GetDisplayName(indexOrName)
    local name = indexOrName
    if API:IsAddOnLibraryType(name) then return fLib(libPrefix .. name) end
    return (ADU:CanEnableByProfile(name) and name) or fDisabled(name)
end

--- @param name AddOnName The AddOn Index or Name
--- @return string
function o.GetDesc(name)
    local info     = API:GetAddOnInfo(name)
    local depsInfo = API:GetDependencyDetails(name)
    local desc     = info.desc
    local label    = ''

    desc = info.title .. '\n\n' .. desc
    if depsInfo:HasDependencies() then
        label = label .. '\n\n' .. depsInfo:GetDependencyLabel()
    end
    desc = desc .. label
    return desc
end

--- @param name AddOnName
--- @param state boolean
--- @param flush boolean Flushes the AddOnDependencyDetails cache; defaults to false
function o:UpdateEnabledState(name, state, flush)
    flush = flush == true or false
    local currentlyEnabled = API:IsAddOnEnabled(name)
    if state == true and not currentlyEnabled then
        if flush then
            AceEvent:SendMessage(MSG.OnFlushAddOnDependenciesCache, libName)
        end
        return API:EnableAddOnForCharacter(name)
    elseif state == false and currentlyEnabled then
        if flush then
            AceEvent:SendMessage(MSG.OnFlushAddOnDependenciesCache, libName)
        end
        API:DisableAddOnForCharacter(name)
    end
end

function o.CreateGetFn(addOnName)
    --- @return boolean
    return function()
        local v = ns:profile().enabledAddons[addOnName] == true
        o:UpdateEnabledState(addOnName, v)
        return v
    end
end

--- @param addOnName Name
--- @param options AceConfigOption
function o.CreateSetFn(options, addOnName)
    return function(ctx, v)
        ns:profile().enabledAddons[addOnName] = v
        --@do-not-package@
        if ns:IsDev() then
            if String.IsAnyOf(addOnName, unpack(ns.debug.alwaysEnabledAddOns)) then
                ns:profile().enabledAddons[addOnName] = true
                v = true
            end
        end
        --@end-do-not-package@
        o:OnSyncCheckedStateWithRelatedAddOns(options, addOnName, v)
        o:UpdateEnabledState(addOnName, v, true)
        AceEvent:SendMessage(MSG.OnUpdateMinimapState, libName)
    end
end

--- @param name Name The addon name
function o.GetAddOnNameFn(name)
    return function()
        local displayName
        local co = CoroutineManager:Create(function()
            displayName = o.GetDisplayName(name)
            coroutine.yield(displayName)
        end)
        coroutine.resume(co)
        return displayName
    end
end

--- @param name Name The addon name
function o.GetAddOnDescFn(name)
    return function()
        local description
        local co = CoroutineManager:Create(function()
            description = o.GetDesc(name)
            coroutine.yield(description)
        end)
        coroutine.resume(co)
        return description
    end
end

function o:CreateAddOnCheckList()
    local order = self.order
    local options = self.addonsOptions

    API:ForEachAddOn(function(info)
        local name = info.name
        options[name] = {
            order = order:next(),
            type = 'toggle',
            width = 1.3,
            get = o.CreateGetFn(name),
        }
        local opt = options[name];
        opt.set = o.CreateSetFn(options, name)
        opt.name = o.GetAddOnNameFn(name)
        opt.desc = o.GetAddOnDescFn(name)
    end)
end

function o:CreateEnableAll()
    return ACU:CreateOption('General::Enable All::Button', {
        type = "execute", order = self.order:next(), width = 'half',
        func = function() self:ForEachToggle(function(opt) opt.set({ isBulkOperation=true }, true) end) end
    })
end

function o:CreateDisableAll()
    return ACU:CreateOption('General::Disable All::Button', {
        type="execute", order=self.order:next(), width = 'half',
        func = function() self:ForEachToggle(function(opt) opt.set({ isBulkOperation=true }, false) end) end
    })
end

--- @param applyFn fun(option:AceConfigOption) | "function(option) end"
function o:ForEachToggle(applyFn)
    for _, option in pairs(self.addonsOptions) do
        if option.type == 'toggle' then applyFn(option) end
    end
end
