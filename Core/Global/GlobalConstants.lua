--[[-----------------------------------------------------------------------------
Lua Vars
-------------------------------------------------------------------------------]]
local sformat = string.format

--[[-----------------------------------------------------------------------------
Blizzard Vars
-------------------------------------------------------------------------------]]
local GetAddOnMetadata = GetAddOnMetadata or C_AddOns.GetAddOnMetadata
local date = date

--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
local LibStub = LibStub

--- @type string
local addon
--- @type CoreNamespace
local ns
addon, ns = ...
local kch = ns.Kapresoft_LibUtil.CH

local addonShortName = 'AddonSuite'
local addonFriendlyName = 'Addon Suite'
local consoleCommand = "addonsuite"
local consoleCommandShort = "ads"
local consoleCommandOptions = consoleCommand .. '-options'

local globalVarName = "ADDON_SUITE"
local useShortName = false

local globalVarPrefix = globalVarName .. "_"
local dbName = globalVarPrefix .. 'DB'
local logLevel = globalVarPrefix .. 'LOG_LEVEL'
local debugMode = globalVarPrefix .. 'DEBUG_MODE'

local ADDON_INFO_FMT = '%s|cfdeab676: %s|r'
local TOSTRING_ADDON_FMT = '|cfdfefefe{{|r|cfdeab676%s|r|cfdfefefe}}|r'
local TOSTRING_SUBMODULE_FMT = '|cfdfefefe{{|r|cfdeab676%s|r|cfdfefefe::|r|cfdfbeb2d%s|r|cfdfefefe}}|r'

--[[-----------------------------------------------------------------------------
Console Colors
-------------------------------------------------------------------------------]]
--- @type Kapresoft_LibUtil_ColorDefinition
local consoleColors = ns.consoleColors

local command = kch:FormatColor(consoleColors.primary, '/' .. consoleCommand)
local commandShort = kch:FormatColor(consoleColors.primary, '/' .. consoleCommandShort)


--[[-----------------------------------------------------------------------------
Support Functions
-------------------------------------------------------------------------------]]
--- @param moduleName string
--- @param optionalMajorVersion number|string
local function LibName(moduleName, optionalMajorVersion)
    assert(moduleName, "Module name is required for LibName(moduleName)")
    local majorVersion = optionalMajorVersion or '1.0'
    local v = sformat("%s-%s-%s", addon, moduleName, majorVersion)
    return v
end
--- @param moduleName string
local function ToStringFunction(moduleName)
    local name = addon
    if useShortName then name = addonShortName end
    if moduleName then return function() return string.format(TOSTRING_SUBMODULE_FMT, name, moduleName) end end
    return function() return string.format(TOSTRING_ADDON_FMT, name) end
end

local function InitGlobalVars(varPrefix)
    if 'table' ~= type(_G[dbName]) then _G[dbName] = {} end
    if 'number' ~= type(_G[logLevel]) then _G[logLevel] = 1 end
    if 'boolean' ~= type(_G[debugMode]) then _G[debugMode] = false end
end
InitGlobalVars(globalVarPrefix)

--[[-----------------------------------------------------------------------------
GlobalConstants
-------------------------------------------------------------------------------]]
--- @class GlobalConstants
local S = {}

--- @param o GlobalConstants
local function GlobalConstantProperties(o)
    --- @class GlobalAttributes
    local C = {
        VAR_NAME = globalVarName,
        FRIENDLY_NAME = addonFriendlyName,
        CONSOLE_COMMAND_NAME = consoleCommand,
        CONSOLE_COMMAND_SHORT = consoleCommandShort,
        CONSOLE_COMMAND_OPTIONS = consoleCommandOptions,
        DB_NAME = dbName,
        CONSOLE_HEADER_FORMAT = '|cfdeab676### %s ###|r',
        CONSOLE_OPTIONS_FORMAT = '  - %-8s|cfdeab676:: %s|r',

        CONSOLE_PLAIN = command,
    }

    --- @class EventNames
    local E = {
        OnEnter = 'OnEnter',
        OnEvent = 'OnEvent',
        OnLeave = 'OnLeave',
        OnModifierStateChanged = 'OnModifierStateChanged',
        OnDragStart = 'OnDragStart',
        OnDragStop = 'OnDragStop',
        OnMouseUp = 'OnMouseUp',
        OnMouseDown = 'OnMouseDown',
        OnReceiveDrag = 'OnReceiveDrag',

        PLAYER_ENTERING_WORLD = 'PLAYER_ENTERING_WORLD',
    }
    local function newMsg(msg) return sformat("%s::%s", addon, msg) end
    --- @param event EventName Blizzard Event Name
    local function toMsg(event) return newMsg(event) end

    --- @class MessageNames
    local M = {
        OnAddOnStartLoad                = newMsg('OnAddOnStartLoad'),
        OnAddOnReady                    = newMsg('OnAddonReady'),
        OnAddOnStateChanged             = newMsg('OnAddOnStateChanged'),
        OnAfterInitialize               = newMsg('OnAfterInitialize'),
        OnAfterOnAddOnReady             = newMsg('OnAfterOnAddOnReady'),
        OnApplyAndRestart               = newMsg('OnApplyAndRestart'),
        OnBeforeInitialize              = newMsg('OnBeforeInitialize'),
        OnFlushAddOnDependenciesCache   = newMsg('OnFlushAddOnDependenciesCache'),
        OnHideSettings                  = newMsg('OnHideSettings'),
        OnProfileChanged                = newMsg('OnProfileChanged'),
        OnProfileDeleted                = newMsg('OnProfileDeleted'),
        OnSwitchProfile                 = newMsg('OnSwitchProfile'),
        OnSwitchProfile                 = newMsg('OnSwitchProfile'),
        OnToggleMinimapIcon             = newMsg('OnToggleMinimapIcon'),
        OnToggleMinimapIconTitanPanel   = newMsg('OnToggleMinimapIconTitanPanel'),
        OnToggleShowInQuickProfileMenu  = newMsg('OnToggleShowInQuickProfileMenu'),
        OnUpdateMinimapIconState        = newMsg('OnUpdateMinimapIconState'),
        OnUpdateMinimapState            = newMsg('OnUpdateMinimapState'),
    }

    o.C = C
    o.E = E
    o.M = M
    o.toMsg = toMsg

end

local isDev = ns:IsDev()
--@do-not-package@
isDev = true
--@end-do-not-package@

--- @param o GlobalConstants
local function Methods(o)

    --- @return boolean
    local function IsDev()
        local _isDev = ns:IsDev()
        --@do-not-package@
        _isDev = true
        --@end-do-not-package@
        return _isDev
    end

    function o:GetLogName()
        local logName = addon
        if useShortName then logName = addonShortName end
        return logName
    end

    function o:AIU()
        if o.AddonUtil then return o.AddonUtil end
        o.AddonUtil = ns:AddonInfoUtil():New(addon, ns.consoleColors, IsDev())
        return o.AddonUtil
    end


    ---#### Example
    ---```
    ---local version, curseForge, issues, repo, lastUpdate, wowInterfaceVersion = G:GetAddonInfo()
    ---```
    --- @return string, string, string, string, string, string
    function o:GetAddonInfo()
        local versionText, lastUpdate
        versionText = GetAddOnMetadata(ns.name, 'Version')
        lastUpdate = GetAddOnMetadata(ns.name, 'X-Github-Project-Last-Changed-Date')
        --@do-not-package@
        if isDev then
            versionText = '1.0.0.dev'
            lastUpdate  = date("%m/%d/%y %H:%M:%S")
        end
        --@end-do-not-package@
        local wowInterfaceVersion = select(4, GetBuildInfo())

        return versionText, GetAddOnMetadata(ns.name, 'X-CurseForge'),
                GetAddOnMetadata(ns.name, 'X-Github-Issues'),
                GetAddOnMetadata(ns.name, 'X-Github-Repo'),
                lastUpdate, wowInterfaceVersion
    end

    function o:GetAddonInfoFormatted()
        local version, curseForge, issues, repo, lastUpdate, wowInterfaceVersion = self:GetAddonInfo()
        --p:log("Addon Info:\n  Version: %s\n  Curse-Forge: %s\n  File-Bugs-At: %s\n  Last-Changed-Date: %s\n  WoW-Interface-Version: %s\n",
        --        version, curseForge, issues, lastChanged, wowInterfaceVersion)
        return sformat("Addon Info:\n%s\n%s\n%s\n%s\n%s\n%s",
                sformat(ADDON_INFO_FMT, 'Version', version),
                sformat(ADDON_INFO_FMT, 'Curse-Forge', curseForge),
                sformat(ADDON_INFO_FMT, 'Bugs', issues),
                sformat(ADDON_INFO_FMT, 'Repo', repo),
                sformat(ADDON_INFO_FMT, 'Last-Update', lastUpdate),
                sformat(ADDON_INFO_FMT, 'Interface-Version', wowInterfaceVersion)
        )
    end

    function o:GetMessageLoadedText()
        return self:AIU():GetMessageLoadedText(command, commandShort)
    end

    o.LibName = LibName
    o.ToStringFunction = ToStringFunction
end

GlobalConstantProperties(S); Methods(S); ns.GC = S
