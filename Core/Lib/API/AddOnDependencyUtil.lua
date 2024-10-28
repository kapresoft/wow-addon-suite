--[[-----------------------------------------------------------------------------
Blizzard Vars
-------------------------------------------------------------------------------]]
local C_Timer_After = C_Timer.After

--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
--- @type Namespace
local ns = select(2, ...)
local K, KO, O, GC = ns:K(), ns.KO(), ns.O, ns.GC
local MSG = GC.M
local AU = KO.AddonUtil

local sformat = ns.sformat

--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
local libName = ns.M.AddOnDependencyUtil()
--- @class AddOnDependencyUtil
local S = ns:NewLib(libName)
local p = ns:LC().DEPENDENCY:NewLogger('AddOnDU')

--[[-----------------------------------------------------------------------------
Support Functions
-------------------------------------------------------------------------------]]
local c1 = ns:K():cf(FACTION_RED_COLOR)
local c2 = ns:K():cf(BLUE_FONT_COLOR)
local c3 = K:cf(YELLOW_FONT_COLOR)

--- @param state boolean
--- @return string
local function AddOnNameFormatter(txt, state)
    if state == true then return txt end
    return c1(txt)
end

--[[-----------------------------------------------------------------------------
AddOnCache
-------------------------------------------------------------------------------]]
--- @field dependencies table<Index, AddOnName>
local LocalCache = {
    dependencies = {},
    dependencyDetails = {},
}

local IsTableEmpty = ns:Table().IsEmpty

local c = LocalCache; do
    ---@param reference Name Informational parameter to display the referenceID of the caller.
    function c:Flush(reference)
        if IsTableEmpty(self.dependencyDetails) then return end
        self.dependencyDetails = {}
        local fmt = 'Cache %s.'
        if reference then fmt = fmt .. ' [ref=%s]' end
        p:d(function() return fmt, c2('flushed'), reference end)
    end
end

--[[-----------------------------------------------------------------------------
Type: AddOnDependencyDetailsMixin
-------------------------------------------------------------------------------]]
--- @class AddOnDependencyDetailsMixin
local AddOnDependencyDetailsMixin = {}; do

    --- @type AddOnDependencyDetailsMixin
    local D = AddOnDependencyDetailsMixin

    --- @param name AddOnName
    --- @return AddOnDependencyDetails
    function D:New(name)
        return ns:K():CreateAndInitFromMixinWithDefExc(D, name)
    end

end

--- @type AddOnDependencyDetails
local ddm = AddOnDependencyDetailsMixin; do

    --- @class AddOnDependencyDetails
    --- @field name AddOnName
    --- @field disabledCount number The number of dependencies that are cannot be enabled or currently disabled
    --- @field deps table<number, Name> AddOn Names First-level dependencies on other AddOns
    --- @field allDeps table<number, string> All AddOn dependencies including dependencies of dependencies
    --- @field allDepsFormattedText string The formatted version of the allDeps field

    --- @private
    --- @param name AddOnName
    function ddm:Init(name)
        assert(type(name) == 'string', 'AddOnDependencyDetails:Init():AddOnName is required')
        self.name          = name
        self.deps          = S:GetAddOnDependencies(name)
        self.allDeps       = {}
        self.disabledCount = 0

        self.allDepsFormattedText = ''
    end

    --- @return boolean
    function ddm:HasDependencies() return self:SizeOfDeps() > 0 end

    --- @return number
    function ddm:SizeOfDeps() if self.deps then return #self.deps end; return 0 end

    --- @return boolean
    function ddm:CanBeEnabled() return self.disabledCount == 0 end

    --- @return string
    function ddm:GetDependencyLabel() return c3('Dependencies: ') .. self.allDepsFormattedText end
end

--[[-----------------------------------------------------------------------------
Mixin Methods
-------------------------------------------------------------------------------]]
--- @type AddOnDependencyUtil
local o = S
local cache = LocalCache

--- @param name AddOnName
--- @return AddOnDependencyDetails
function o:NewDependencyDetails(name)
    local inst = AddOnDependencyDetailsMixin:New(name)
    LocalCache.dependencyDetails[name] = inst
    return inst
end

--- @param name AddOnName
--- @return AddOnDependencyDetails
function o:GetDepsDetail(name) return cache.dependencyDetails[name] end

--- @param name AddOnName
--- @return table<Index, AddOnName>
function o:GetAddOnDependencies(name)
    if cache.dependencies[name] == nil then
        cache.dependencies[name] = AU:GetAddOnDependencies(name)
    end
    return cache.dependencies[name]
end

--- @param name AddOnName
--- @return boolean
function o:HasDependencies(name) return #self:GetAddOnDependencies(name) > 0 end

function o:FlushAddOnDependencyDetailsCache() LocalCache:Flush(libName) end

--- @param addOnName Name
--- @return AddOnDependencyDetails
--- @param useCache boolean defaults to true
function o:GetDependencyDetails(addOnName, useCache)
    useCache = (useCache == nil) or useCache
    --- @type AddOnDependencyDetails
    local info = self:GetDepsDetail(addOnName); if useCache and info then return info end

    return self:GetDependenciesInfoInternal(addOnName, useCache)
end

--- @private
--- @param addOnName Name
--- @return AddOnDependencyDetails
function o:GetDependenciesInfoInternal(addOnName)
    local info = self:NewDependencyDetails(addOnName)
    if not info:HasDependencies() then return info end

    local disabledCount = 0

    --- Color formatted version of dependencies
    local addOnDepsFormatted = {}
    --- Represents All Dependencies including downstream
    local addOnDeps          = {}

    --- @param name AddOnName
    local function addFormattedDep(name)
        local enabled = AU:IsAddOnEnabled(name)
        if not enabled then disabledCount = disabledCount + 1 end

        if addOnDeps[name] then return end
        addOnDeps[name] = true
        local depAddonPretty = AddOnNameFormatter(name, enabled)
        table.insert(addOnDepsFormatted, depAddonPretty)
    end

    for _, addOnL1 in ipairs(info.deps) do
        addFormattedDep(addOnL1)
        local depsL2 = self:GetAddOnDependencies(addOnL1)
        for _, addOnL2 in ipairs(depsL2) do addFormattedDep(addOnL2) end
    end

    for _name in pairs(addOnDeps) do table.insert(info.allDeps, _name) end

    info.disabledCount = disabledCount
    info.allDepsFormattedText = ''
    if #addOnDepsFormatted > 0 then
        info.allDepsFormattedText = table.concat(addOnDepsFormatted, ', ')
    end

    return info
end

--- @param name AddOnName
--- @return boolean
function o:CanEnableByProfile(name)
    local depsInfo = self:GetDependencyDetails(name)
    for _, n in ipairs(depsInfo.allDeps) do
        local v = ns:profile().enabledAddons[n]
        if v ~= true then return false end
    end

    return true
end

--- Generates a GUID-like string.
--- @return string A unique string identifier.
local function createGUID()
    local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
    local function getRandomHexDigit()
        return string.format("%x", math.random(0, 15))
    end
    local function getRandomHexDigitOr8or9()
        return string.format("%x", math.random(8, 11))
    end
    return string.gsub(template, "[xy]", function(c)
        if c == "x" then
            return getRandomHexDigit()
        else
            return getRandomHexDigitOr8or9()
        end
    end)
end

---@param tbl table<string, any>
local function firstKey(tbl)
    if type(tbl) ~= 'table' then return nil end
    for k in pairs(tbl) do if k then return k end end
    return nil
end

--- @param payload string|table
--- @param msg string
local function createRef(payload, msg)
    --@do-not-package@
    if ns:IsDev() then
        local caller
        if type(payload) == 'string' then caller = payload
        else
            caller = firstKey(payload)
        end
        local srcName = caller or libName
        local guid    = createGUID()
        return srcName .. '::' .. msg .. '::' .. guid
    end
    --@end-do-not-package@
    return ''
end
---@param delay TimeDelayInSec
local function FlushDelayed(delay, src)
    delay = (delay and delay > 0.0 and delay) or 0.1
    C_Timer_After(delay, function() LocalCache:Flush(src) end)
end

--[[-----------------------------------------------------------------------------
Events / Messages
-------------------------------------------------------------------------------]]
ns:OnAddOnStartLoad(function()
    local AceEvent = ns:AceEvent()
    local AceBucket = ns:AceBucket()

    AceEvent:RegisterMessage(MSG.OnProfileChanged, function(msg, src)
        FlushDelayed(0.1, createRef(src, 'OnProfileChanged'))
    end)

    --- When selecting "All" or "None" button, we need to use AceBucket to reduce the event
    --- because all of the addOn checkboxes will change
    AceBucket:RegisterBucketMessage(MSG.OnFlushAddOnDependenciesCache, 0.1, function(...)
        local payload = ...
        FlushDelayed(0.1, createRef(payload, 'OnFlushAddOnDependenciesCache'))
    end)
end)

