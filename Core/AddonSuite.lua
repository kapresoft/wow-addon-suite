--[[-----------------------------------------------------------------------------
Blizzard Vars
-------------------------------------------------------------------------------]]
local C_Timer_After = C_Timer.After

--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace
local ns = select(2, ...)
local O, GC, C, LibStub = ns.O, ns.GC, ns.GC.C, ns.LibStub

local AceDbInitializerMixin, OptionsMixin = O.AceDbInitializerMixin, O.OptionsMixin

local Table, String = ns:Table(), ns:String()
local AceConfigDialog = ns:AceConfigDialog()
local IsAnyOf, IsEmptyTable = String.IsAnyOf, Table.isEmpty

--- @class AddonSuite
local A = LibStub:NewAddon(ns.addon); if not A then return end
local p = ns:CreateDefaultLogger(ns.name)
local pa = ns:LC().ADDON:NewLogger(ns.name)

--[[-----------------------------------------------------------------------------
Lua Vars
-------------------------------------------------------------------------------]]
local sformat, unpack = ns.sformat, unpack

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
--- @type AddonSuite | AddonInterface
local o = A

o:SendMessage(GC.M.OnAddOnStartLoad, ns.addon)

function o:OnEnable()
    p:f1("OnEnable called..")
end

function o:OnInitialize()
    p:f1("Initialized called..")
    self:SendMessage(GC.M.OnBeforeInitialize, ns.addon)

    self:RegisterSlashCommands()
    AceDbInitializerMixin:New(self):InitDb()
    OptionsMixin:New(self):InitOptions()
    C_Timer_After(0.5, function() self:SendMessage(GC.M.OnAfterInitialize, ns.addon) end)
end

function o:RegisterSlashCommands()
    self:RegisterChatCommand(C.CONSOLE_COMMAND_NAME, "SlashCommands")
    self:RegisterChatCommand(C.CONSOLE_COMMAND_SHORT, "SlashCommands")
end

function o:SlashCommand_OpenConfig() o:OpenConfig() end
function o:SlashCommand_Info_Handler() p:a(GC:GetAddonInfoFormatted()) end
function o:SlashCommand_Help_Handler()
    p:a('')
    local COMMAND_INFO_TEXT = "Prints additional addon info"
    local COMMAND_CONFIG_TEXT = "Shows the config UI"
    local COMMAND_HELP_TEXT = "Shows this help"
    local COMMAND_FLUSH_TEXT = "Flushes dependency cache"
    local OPTIONS_LABEL = "options"
    local USAGE_LABEL = sformat("usage: %s [%s]", GC.C.CONSOLE_PLAIN, OPTIONS_LABEL)
    p:a(USAGE_LABEL)
    p:a(OPTIONS_LABEL .. ":")
    p:a(function() return C.CONSOLE_OPTIONS_FORMAT, 'config', COMMAND_CONFIG_TEXT end)
    p:a(function() return C.CONSOLE_OPTIONS_FORMAT, 'info', COMMAND_INFO_TEXT end)
    p:a(function() return C.CONSOLE_OPTIONS_FORMAT, 'help', COMMAND_HELP_TEXT end)
    p:a(function() return C.CONSOLE_OPTIONS_FORMAT, 'flushcache', COMMAND_FLUSH_TEXT end)
end

--- @param spaceSeparatedArgs string
function o:SlashCommands(spaceSeparatedArgs)
    local args = Table.parseSpaceSeparatedVar(spaceSeparatedArgs)
    if IsEmptyTable(args) then
        self:SlashCommand_Help_Handler(); return
    end
    if IsAnyOf('config', unpack(args)) or IsAnyOf('conf', unpack(args)) then
        self:SlashCommand_OpenConfig(); return
    end
    if IsAnyOf('info', unpack(args)) then
        self:SlashCommand_Info_Handler(); return
    end
    if IsAnyOf('flushcache', unpack(args)) then
        ns.O.AddOnDependencyUtil:FlushAddOnDependencyDetailsCache()
        return
    end
    -- Otherwise, show help
    self:SlashCommand_Help_Handler()
end

--- Since AceConfigDialog caches the frames, we want to make sure the appName is this addOn
--- @param name Name The appName
--- @param frame Frame
function o:OnHide(frame, name)
    if ns.name ~= name then return end
    pa:d(function() return 'OnHide() name=%s', name end)
    self:OnHideSettings(true)
end

function o:OnHideBlizzardOptions() self:OnHideSettings(false) end

--- @param enableSound BooleanOptional
function o:OnHideSettings(enableSound)
    local enable = enableSound == true
    pa:d(function() return 'OnHideSettings called with enableSound=%s', tostring(enable) end)
    if true == enable then PlaySound(SOUNDKIT.IG_CHARACTER_INFO_CLOSE) end
    self:SendMessage(GC.M.OnHideSettings, ns.name, 'OnHideSettings')
end
function o:CloseConfig()
    if not AceConfigDialog.OpenFrames[ns.name] then return end
    AceConfigDialog:Close(ns.name)
end

---@param group string|nil | "'debugging'" | "'profiles'" | "'minimap'"
function o:OpenConfig(group)
    if group and AceConfigDialog.OpenFrames[ns.name] then
        return AceConfigDialog:SelectGroup(ns.name, group or "general")
    end
    AceConfigDialog:Open(ns.name)
    self:DialogGlitchHack(group);

    PlaySound(SOUNDKIT.IG_CHARACTER_INFO_OPEN)
    self.configDialogWidget = AceConfigDialog.OpenFrames[ns.name]
    if not self.configDialogWidget then return end

    --- @type _Frame
    local frame = self.configDialogWidget.frame
    -- Set the frame strata so it doesn't overlap with Confirm Dialog
    frame:SetFrameStrata('DIALOG')
    frame:SetFrameLevel(1)
    if frame then
        local success, msg = pcall(function()
            self:HookScript(frame, 'OnHide', function()
                self:OnHide(frame, self.configDialogWidget:GetUserData('appName'))
            end)
        end)
        if success ~= true then p:f3(function() return "onHideHookFailed: %s", msg end) end
    end
end
function o:OpenConfigDebugging()
    self:OpenConfig('debugging')
end
function o:OpenConfigProfiles()
    self:OpenConfig('profiles')
end
function o:OpenConfigMinimapProfileMenu()
    self:OpenConfig('minimap')
end
--- This hacks solves the range UI notch not positioning properly
---@param group string|nil | "'debugging'" | "'profiles'" | "'minimap'"
function o:DialogGlitchHack(group)
    AceConfigDialog:SelectGroup(ns.name, "debugging")
    AceConfigDialog:Open(ns.name)
    C_Timer.After(0.01, function()
        AceConfigDialog:ConfigTableChanged('anyEvent', ns.name)
        AceConfigDialog:SelectGroup(ns.name, group or "general")
    end)
end
--- @see Bindings.xml
function o.BINDING_ADDON_SUITE_OPTIONS_DLG() o:OpenConfig() end
function o.BINDING_ADDON_SUITE_OPTIONS_DLG_MINIMAP() o:OpenConfigMinimapProfileMenu() end


ADDON_SUITE = A

