--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type ADS_Namespace
local ns = select(2, ...)

--[[-----------------------------------------------------------------------------
Struct
-------------------------------------------------------------------------------]]
local SyncData = {

  --- @type table<string, table<number, AddOnName>>
  items = {
    ['ActionbarPlus'] = {
      'ActionbarPlus-Core',
      'ActionbarPlus-BarsUI',
      'ActionbarPlus-OptionsUI',
      'ActionbarPlus-Masque',
      'ActionbarPlus-ArcLayout',
    },
    ['AtlasLootClassic'] = {
      'AtlasLootClassic_Collections',
      'AtlasLootClassic_Crafting',
      'AtlasLootClassic_Data',
      'AtlasLootClassic_DungeonsAndRaids',
      'AtlasLootClassic_Factions',
      'AtlasLootClassic_Options',
      'AtlasLootClassic_PvP',
    },
    ['BugSack'] = { '!BugGrabber' },
    ['!BugGrabber'] = { 'BugSack' },
    ['VuhDo'] = { 'VuhDoOptions' },
    ['BadBoy'] = { 'BadBoy_Ignore', 'BadBoy_Levels' },
    ['BagBrother'] = {
      'Bagnon',
      'Bagnon_Config',
      'Bagnon_Bank',
      'Bagnon_GuildBank',
      'Bagnon_RequiredLevel',
      'Bagnon_ItemInfo',
      'Bagnon_Scrap',
    },
    ['Baganator'] = { 'Syndicator' },
    ['Capping'] = { 'Capping_Options' },
    ['Details'] = {
      'Details_Compare2',
      'Details_DataStorage',
      'Details_EncounterDetails',
      'Details_RaidCheck',
      'Details_Streamer',
      'Details_TinyThreat',
      'Details_Vanguard',
    },
    ['DBM-Core'] = { 'DBM-GUI', 'DBM-VPVEM', 'DBM-StatusBarTimers' },
    ['GatherMate2'] = { 'GatherMate2Marker' },
    ['Gears'] = { 'Gears-OptionsUI', 'LibIconPicker' },
    ['ItemRack'] = { 'ItemRackOptions' },
    ['LuaDevKit'] = {
      'LuaDevKit-CodeEditor',
      'LuaDevKit-Settings',
      'SharedMediaFontsMono',
    },
    ['Masque'] = {
      'Masque_Apathy',
      'Masque_Caith',
      'Masque_Cirque',
      'Masque_Entropy',
      'Masque_Fusion',
      'Masque_Gears',
      'Masque_Raeli',
      'Masque_Serenity',
      'Masque_Stylo',
    },
    ['Questie'] = { 'QuestieDB' },
    ['Scrap'] = { 'Scrap_Config', 'Scrap_Merchant', 'Bagnon_Scrap' },
    ['ShadowedUnitFrames'] = { 'ShadowedUF_Options' },
    ['Titan'] = {
      'TitanAlts',
      'TitanAmmo',
      'TitanBag',
      'TitanClassic',
      'TitanClock',
      'TitanGold',
      'TitanLocation',
      'TitanLootType',
      'TitanPerformance',
      'TitanPost',
      'TitanRegen',
      'TitanRepair',
      'TitanUI',
      'TitanVolume',
      'TitanXP',
    },
    ['WeakAuras'] = {
      'WeakAurasArchive',
      'WeakAurasModelPaths',
      'WeakAurasOptions',
      'WeakAurasTemplates',
    },
  },
}

--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
local libName = 'SynchronizedAddOns'
--- @class SynchronizedAddOns
--- @field private synchronized table<AddOnName, boolean>
local o = { synchronized = {} }; ns:Register(libName, o)
local p, t = ns:log(libName)

--[[-----------------------------------------------------------------------------
Mixin Methods
-------------------------------------------------------------------------------]]

for addon in pairs(SyncData.items) do
  o.synchronized[addon] = true
end

--- @param name AddOnName
--- @return boolean
function o:IsSynchronized(name) return self.synchronized[name] == true end

---@param name AddOnName The addon that needs to be syncd with others
---@param callbackFn fun(syncdAddOnName:AddOnName) | 'function(syncdAddOnName) end'
function o:ForEachSyncdAddOn(name, callbackFn)
  if not self:IsSynchronized(name) then return end
  for _, syncdAddOn in pairs(SyncData.items[name]) do
    callbackFn(syncdAddOn)
  end
end
