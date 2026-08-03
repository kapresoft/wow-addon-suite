--[[-----------------------------------------------------------------------------
Blizzard Vars
-------------------------------------------------------------------------------]]
local C_Timer_After = C_Timer.After

--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type ADS_Namespace
local ns = select(2, ...)
local O, GC, C = ns.O, ns.GC
local C = GC.C
local AceAddon = ns:AceAddon()

local AceDbInitializerMixin, OptionsMixin = O.AceDbInitializerMixin, O.OptionsMixin

local Table, String = O.Table, O.String
local AceConfigDialog = ns:AceConfigDialog()
local IsAnyOf, IsEmptyTable = String.IsAnyOf, Table.IsEmpty

--- @class AddonSuite : AceAddon, AceConsole-3.0, AceEvent-3.0, AceHook-3.0
local o = AceAddon:NewAddon(ns.addon, 'AceConsole-3.0', 'AceEvent-3.0', 'AceHook-3.0')
ADDON_SUITE = o

local p, t = ns:log('Addon')

--[[-----------------------------------------------------------------------------
Lua Vars
-------------------------------------------------------------------------------]]
local sformat, unpack = ns.sformat, unpack

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
function o:OnEnable()
  self:SendMessage(GC.M.OnAddOnEnabled, ns.addon)
end

function o:OnInitialize()
  self:SendMessage(GC.M.OnBeforeInitialize, ns.addon)

  self:RegisterSlashCommands()
  AceDbInitializerMixin:New(self):InitDb()
  OptionsMixin:New(self):InitOptions()
  C_Timer_After(0.5, function() self:SendMessage(GC.M.OnAfterInitialize, ns.addon) end)
end

function o:RegisterSlashCommands()
  self:RegisterChatCommand(C.CONSOLE_COMMAND_NAME, 'SlashCommands')
  self:RegisterChatCommand(C.CONSOLE_COMMAND_SHORT, 'SlashCommands')
end

function o:SlashCommand_OpenConfig() o:OpenConfig() end
function o:SlashCommand_Info_Handler() ns.printer(GC:GetAddonInfoFormatted()) end

function o:SlashCommand_Help_Handler()
  ns.printer('')
  local COMMAND_INFO_TEXT = 'Prints additional addon info'
  local COMMAND_CONFIG_TEXT = 'Shows the config UI'
  local COMMAND_HELP_TEXT = 'Shows this help'
  local OPTIONS_LABEL = 'options'
  local USAGE_LABEL = sformat('usage: %s [%s]', GC.C.CONSOLE_PLAIN, OPTIONS_LABEL)
  ns.printer(USAGE_LABEL)
  ns.printer(OPTIONS_LABEL .. ':')
  ns.printer(C.CONSOLE_OPTIONS_FORMAT:format('config', COMMAND_CONFIG_TEXT))
  ns.printer(C.CONSOLE_OPTIONS_FORMAT:format('info', COMMAND_INFO_TEXT))
  ns.printer(C.CONSOLE_OPTIONS_FORMAT:format('help', COMMAND_HELP_TEXT))
end

--- @param text string The space separated string. Example: 'one two three'
--- @return string[]
local function ParseSpaceSeparatedVar(text)
  local rt = {}
  for a in text:gmatch('%S+') do
    table.insert(rt, a)
  end
  return rt
end

--- @param spaceSeparatedArgs string
function o:SlashCommands(spaceSeparatedArgs)
  local args = ParseSpaceSeparatedVar(spaceSeparatedArgs)
  if IsEmptyTable(args) then
    self:SlashCommand_Help_Handler()
    return
  end
  if IsAnyOf('config', unpack(args)) or IsAnyOf('conf', unpack(args)) then
    self:SlashCommand_OpenConfig()
    return
  end
  if IsAnyOf('info', unpack(args)) then
    self:SlashCommand_Info_Handler()
    return
  end
  -- Otherwise, show help
  self:SlashCommand_Help_Handler()
end

--- Since AceConfigDialog caches the frames, we want to make sure the appName is this addOn
--- @param name Name The appName
--- @param frame Frame
function o:OnHide(frame, name)
  if ns.addon ~= name then return end
  self:OnHideSettings(true)
end

function o:OnHideBlizzardOptions() self:OnHideSettings(false) end

--- @param enableSound BooleanOptional
function o:OnHideSettings(enableSound)
  local enable = enableSound == true
  if true == enable then PlaySound(SOUNDKIT.IG_CHARACTER_INFO_CLOSE) end
  self:SendMessage(GC.M.OnHideSettings, ns.addon, 'OnHideSettings')
end
function o:CloseConfig()
  if not AceConfigDialog.OpenFrames[ns.addon] then return end
  AceConfigDialog:Close(ns.addon)
end

---@param group string|nil | "'debugging'" | "'profiles'" | "'minimap'"
function o:OpenConfig(group)
  if group and AceConfigDialog.OpenFrames[ns.addon] then
    return AceConfigDialog:SelectGroup(ns.addon, group or 'general')
  end
  AceConfigDialog:Open(ns.addon)
  self:DialogGlitchHack(group)

  PlaySound(SOUNDKIT.IG_CHARACTER_INFO_OPEN)
  self.configDialogWidget = AceConfigDialog.OpenFrames[ns.addon]
  if not self.configDialogWidget then return end

  --- @type _Frame
  local frame = self.configDialogWidget.frame
  -- Set the frame strata so it doesn't overlap with Confirm Dialog
  frame:SetFrameStrata('DIALOG')
  frame:SetFrameLevel(1)
  if frame then
    if not self:IsHooked(frame, 'OnHide') then
      local success, msg = pcall(function()
        self:HookScript(frame, 'OnHide', function() self:OnHide(frame, self.configDialogWidget:GetUserData('appName')) end )
      end)
      if success ~= true then ns.tr('hooked=', self:IsHooked(frame, 'OnHide'), 'onHideHookFailed:', msg) end
    end
  end
end
function o:OpenConfigDebugging() self:OpenConfig('debugging') end
function o:OpenConfigProfiles() self:OpenConfig('profiles') end
function o:OpenConfigMinimapProfileMenu() self:OpenConfig('minimap') end
--- This hacks solves the range UI notch not positioning properly
---@param group string|nil | "'debugging'" | "'profiles'" | "'minimap'"
function o:DialogGlitchHack(group)
  AceConfigDialog:SelectGroup(ns.addon, 'debugging')
  AceConfigDialog:Open(ns.addon)
  C_Timer.After(0.01, function()
    AceConfigDialog:ConfigTableChanged('anyEvent', ns.addon)
    AceConfigDialog:SelectGroup(ns.addon, group or 'general')
  end)
end
--- @see Bindings.xml
function o.BINDING_ADDON_SUITE_OPTIONS_DLG() o:OpenConfig() end
function o.BINDING_ADDON_SUITE_OPTIONS_DLG_MINIMAP() o:OpenConfigMinimapProfileMenu() end
