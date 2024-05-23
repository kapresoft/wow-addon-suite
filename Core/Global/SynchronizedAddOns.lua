--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace
local ns = select(2, ...)

--[[-----------------------------------------------------------------------------
Struct
-------------------------------------------------------------------------------]]
local SyncData = {

    --- @type table<string, table<number, AddOnName>>
    items = {
        ['BugSack']      = { '!BugGrabber' },
        ['!BugGrabber']  = { 'BugSack' },
        ['VuhDo']        = { 'VuhDoOptions' },
        ['BadBoy']       = { 'BadBoy_Ignore', 'BadBoy_Levels' },
        ['Bagnon']       = { 'BagBrother', 'Bagnon_Config',
                             'Bagnon_ItemInfo', 'Bagnon_Scrap' },
        ['Scrap']        = { 'Scrap_Config', 'Scrap_Merchant', 'Bagnon_Scrap' },
        ['TitanClassic'] = { 'TitanVolume', 'TitanXP' },
    }
}

--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
local libName = 'SynchronizedAddOns'
--- @class SynchronizedAddOns
--- @field private synchronized table<AddOnName, boolean>
local S = { synchronized = {} }

--[[-----------------------------------------------------------------------------
Mixin Methods
-------------------------------------------------------------------------------]]
--- @type SynchronizedAddOns
local o = S; for addon in pairs(SyncData.items) do o.synchronized[addon] = true end

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

ns[libName] = S
