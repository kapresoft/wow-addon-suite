--[[-----------------------------------------------------------------------------
Lua Vars
-------------------------------------------------------------------------------]]
local sformat, unpack = string.format, unpack
local LibStub = LibStub
--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace
local ns = select(2, ...)
local O, GC, M, LibStub = ns.O, ns.GC, ns.M, ns.LibStubAce
local KO = ns:KO()

local ACE, Table, String = O.AceLibrary, KO.Table, KO.String
local AceConfigDialog = ACE.AceConfigDialog
local IsAnyOf, IsEmptyTable = String.IsAnyOf, Table.isEmpty

---@class AddonSuite
local A = LibStub("AceAddon-3.0"):NewAddon(ns.name, "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")
local mt = getmetatable(A) or {}
mt.__tostring = ns:ToStringFunction()
local p = ns:CreateDefaultLogger(ns.name)

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
--- @param o AddonSuite
local function MethodsAndProps(o)
    O.MainController:Init(o)

    function o:OnInitialize()
        p:f1("Initialized called..")
        self:RegisterSlashCommands()
        O.AceDbInitializerMixin:New(self):InitDb()
        O.OptionsMixin:New(self):InitOptions()
        self:SendMessage(GC.M.OnAfterInitialize, self)
    end

    function o:RegisterSlashCommands()
        self:RegisterChatCommand(GC.C.CONSOLE_COMMAND_NAME, "SlashCommands")
        self:RegisterChatCommand(GC.C.CONSOLE_COMMAND_SHORT, "SlashCommands")
    end

    function o:SlashCommand_OpenConfig() o:OpenConfig() end
    function o:SlashCommand_Info_Handler() p:vv(GC:GetAddonInfoFormatted()) end
    function o:SlashCommand_Help_Handler()
        p:vv('')
        local COMMAND_INFO_TEXT = "Prints additional addon info"
        local COMMAND_CONFIG_TEXT = "Shows the config UI"
        local COMMAND_HELP_TEXT = "Shows this help"
        local OPTIONS_LABEL = "options"
        local USAGE_LABEL = sformat("usage: %s [%s]", GC.C.CONSOLE_PLAIN, OPTIONS_LABEL)
        p:vv(USAGE_LABEL)
        p:vv(OPTIONS_LABEL .. ":")
        p:vv(function() return GC.C.CONSOLE_OPTIONS_FORMAT, 'config', COMMAND_CONFIG_TEXT end)
        p:vv(function() return GC.C.CONSOLE_OPTIONS_FORMAT, 'info', COMMAND_INFO_TEXT end)
        p:vv(function() return GC.C.CONSOLE_OPTIONS_FORMAT, 'help', COMMAND_HELP_TEXT end)
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
        -- Otherwise, show help
        self:SlashCommand_Help_Handler()
    end

    --- @param enableSound BooleanOptional
    function o:OnHide_Config(enableSound)
        local enable = enableSound == true
        p:d(function() return 'OnHide_Config called with enableSound=%s', tostring(enable) end)
        if true == enable then PlaySound(SOUNDKIT.IG_CHARACTER_INFO_CLOSE) end
        O.MainController:RefreshAutoLoadedAddons()
    end
    function o:OnHide_Config_WithSound() self:OnHide_Config(true) end
    function o:OnHide_Config_WithoutSound() self:OnHide_Config() end
    function o:CloseConfig()
        if not AceConfigDialog.OpenFrames[ns.name] then return end
        AceConfigDialog:Close(ns.name)
    end
    function o:OpenConfig()
        if AceConfigDialog.OpenFrames[ns.name] then return end
        AceConfigDialog:Open(ns.name)
        self:DialogGlitchHack();
        self.onHideHooked = self.onHideHooked or false
        PlaySound(SOUNDKIT.IG_CHARACTER_INFO_OPEN)
        self.configDialogWidget = AceConfigDialog.OpenFrames[ns.name]
        --- @type _Frame
        local f = self.configDialogWidget.frame
        -- Set the frame strata so it doesn't overlap with Confirm Dialog
        f:SetFrameStrata('DIALOG')
        if not self.onHideHooked then
            self:HookScript(self.configDialogWidget.frame, 'OnHide', 'OnHide_Config_WithSound')
            self.onHideHooked = true
        end
    end
    function o:OpenConfigDebugging()
        AceConfigDialog:SelectGroup(ns.name, "debugging")
        AceConfigDialog:Open(ns.name)
    end
    function o:OpenConfigProfiles()
        AceConfigDialog:SelectGroup(ns.name, "profiles")
        AceConfigDialog:Open(ns.name)
    end
    --- This hacks solves the range UI notch not positioning properly
    function o:DialogGlitchHack()
        AceConfigDialog:SelectGroup(ns.name, "debugging")
        AceConfigDialog:Open(ns.name)
        C_Timer.After(0.01, function()
            AceConfigDialog:ConfigTableChanged('anyEvent', ns.name)
            AceConfigDialog:SelectGroup(ns.name, "general")
        end)
    end
    --- @see Bindings.xml
    function o.BINDING_ADDON_SUITE_OPTIONS_DLG() o:OpenConfig() end
end; MethodsAndProps(A); ADDON_SUITE = A; _G[ns.addon] = A
