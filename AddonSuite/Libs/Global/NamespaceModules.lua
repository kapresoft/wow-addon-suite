--- @type ADS_CoreNamespace
local ns = select(2, ...)

--[[-----------------------------------------------------------------------------
Type: Modules
-------------------------------------------------------------------------------]]
--- @type Kapresoft-ModuleUtil-2-0
local ModuleUtil = LibStub('Kapresoft-ModuleUtil-2-0')

--- @class Modules
local M = {
  --- @type Kapresoft-AceConfigUtil-2-0
  AceConfigUtil = {},
  --- @type Kapresoft-AddonInfoUtil-2-0
  AddonInfoUtil = {},
  --- @type Kapresoft-AddonUtil-2-0
  AddonUtil = {},
  --- @type Kapresoft-AceLib-2-0
  AceLib = {},
  --- @type Kapresoft-String-2-0
  String = {},
  --- @type Kapresoft-SequenceMixin-2-0
  SequenceMixin = {},
  --- @type Kapresoft-Table-2-0
  Table = {},
  --- @type Kapresoft-TimeUtil-2-0
  TimeUtil = {},

  --- @type AceDbInitializerMixin
  AceDbInitializerMixin = {},
  --- @type AddOnDependencyUtil
  AddOnDependencyUtil = {},
  --- @type AddOnStateController
  AddOnStateController = {},
  --- @type API
  API = {},
  --- @type AceConfigDialogUtil
  AceConfigDialogUtil = {},
  --- @type DebuggingSettingsGroup
  DebuggingSettingsGroup = {},
  --- @type EventMessagesMixin
  EventMessagesMixin = {},
  --- @type EventToMessageRelay
  EventToMessageRelay = {},
  --- @type Kapresoft-GameVersion-2-0
  GameVersionMixin = {},
  --- @type ConfigDialogController
  ConfigDialogController = {},
  --- @type MainController
  MainController = {},
  --- @type MinimapIconControllerMixin
  MinimapIconControllerMixin = {},
  --- @type OptionsAddonsMixin
  OptionsAddonsMixin = {},
  --- @type OptionsMixin
  OptionsMixin = {},
  --- @type OptionsMinimapMixin
  OptionsMinimapMixin = {},
  --- @type OptionsUtil
  OptionsUtil = {},
  --- @type SynchronizedAddOns
  SynchronizedAddOns = {},
}; ModuleUtil:EnrichModules(M); ns.M = M


--[[-----------------------------------------------------------------------------
ThirdParty References
-------------------------------------------------------------------------------]]
ns:Register(M.GameVersionMixin(), LibStub('Kapresoft-GameVersionMixin-2-0'))
ns:Register(M.AceConfigUtil(), LibStub('Kapresoft-AceConfigUtil-2-0'))
ns:Register(M.AddonInfoUtil(), LibStub('Kapresoft-AddonInfoUtil-2-0'))
ns:Register(M.AddonUtil(), LibStub('Kapresoft-AddonUtil-2-0'))
ns:Register(M.AceLib(), LibStub('Kapresoft-AceLib-2-0'))
ns:Register(M.String(), LibStub('Kapresoft-String-2-0'))
ns:Register(M.SequenceMixin(), LibStub('Kapresoft-SequenceMixin-2-0'))
ns:Register(M.Table(), LibStub('Kapresoft-Table-2-0'))
ns:Register(M.TimeUtil(), LibStub('Kapresoft-TimeUtil-2-0'))
